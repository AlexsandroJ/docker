#!/bin/bash

# --- Configurações ---
NAMESPACE="default"
SERVICE_ACCOUNT_NAME="admin-sa"
ROLE_NAME="deployment-service-manager"
ROLE_BINDING_NAME="bind-admin-sa"
TOKEN_SECRET_NAME="admin-sa-token"

# --- Caminho do kubeconfig para K3s ---
KUBECONFIG_PATH=/etc/rancher/k3s/k3s.yaml

# --- 1. Obter e configurar o IP público ---
echo "Descobrindo o IP público da máquina..."
PUBLIC_IP=$(curl -s ifconfig.me)
if [ -z "$PUBLIC_IP" ]; then
    echo "Erro: Não foi possível obter o IP público. Verifique a conectividade de rede."
    exit 1
fi

echo "IP público detectado: $PUBLIC_IP"
echo "Fazendo backup do arquivo kubeconfig original..."
cp $KUBECONFIG_PATH "$KUBECONFIG_PATH.bak"
echo "Substituindo 127.0.0.1 pelo IP público no kubeconfig..."
sed -i "s|127.0.0.1|$PUBLIC_IP|g" $KUBECONFIG_PATH

# --- 2. Manifestos YAML embutidos ---
cat <<EOF > manifests.yaml

apiVersion: v1
kind: ServiceAccount
metadata:
  name: $SERVICE_ACCOUNT_NAME
  namespace: $NAMESPACE
secrets:
- name: $TOKEN_SECRET_NAME
---
apiVersion: v1
kind: Secret
metadata:
  name: $TOKEN_SECRET_NAME
  namespace: $NAMESPACE
  annotations:
    kubernetes.io/service-account.name: "$SERVICE_ACCOUNT_NAME"
type: kubernetes.io/service-account-token
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: $ROLE_NAME
  namespace: $NAMESPACE
rules:
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["create", "get", "list", "watch", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["services"]
  verbs: ["create", "get", "list", "watch", "update", "patch", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: $ROLE_BINDING_NAME
  namespace: $NAMESPACE
subjects:
- kind: ServiceAccount
  name: $SERVICE_ACCOUNT_NAME
  namespace: $NAMESPACE
roleRef:
  kind: Role
  name: $ROLE_NAME
  apiGroup: rbac.authorization.k8s.io
EOF

# --- 3. Aplicar os manifestos ---
echo "Aplicando manifestos no namespace '$NAMESPACE' usando kubeconfig do k3s..."
kubectl --kubeconfig=$KUBECONFIG_PATH apply -f manifests.yaml
if [ $? -ne 0 ]; then
    echo "Erro ao aplicar manifestos. Verifique sua conexão com o cluster K3s."
    rm manifests.yaml
    exit 1
fi
echo "Manifestos aplicados com sucesso!"

# --- 4. Obter o token diretamente do Secret que criamos ---
echo "Obtendo o token do Secret '$TOKEN_SECRET_NAME'..."
TOKEN=$(kubectl --kubeconfig=$KUBECONFIG_PATH get secret "$TOKEN_SECRET_NAME" -n "$NAMESPACE" -o jsonpath='{.data.token}' | base64 --decode)

# --- 5. Limpeza e Saída ---
rm manifests.yaml
echo "Arquivo temporário removido."
echo "---"
echo "TOKEN DE ACESSO GERADO:"
echo ""
echo "$TOKEN"
echo ""
echo "---"
echo "Para testar o acesso de forma externa, use este comando:"
echo ""
echo 'curl -H "Authorization: Bearer '"$TOKEN"'" https://'"$PUBLIC_IP"':6443/api/v1/namespaces/'"$NAMESPACE"'/deployments --insecure'