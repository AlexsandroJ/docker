#!/bin/bash

# 1. URL do seu túnel Killercoda
URL="https://209b73e3aeb7-10-244-3-251-31492.saci.r.killercoda.com"
OUTPUT_DIR="./dados_prometheus"

mkdir -p "$OUTPUT_DIR"

echo "--- Passo 1: Buscando nomes das métricas (via Python) ---"

# 2. Faz o download do JSON de nomes e usa Python para criar uma lista simples de texto
LISTA_METRICAS=$(curl -s -k "$URL/api/v1/label/__name__/values" | python -c "
import sys, json
try:
    data = json.load(sys.stdin)
    for metric in data['data']:
        if metric: print(metric)
except Exception as e:
    sys.exit(1)
")

if [ $? -ne 0 ] || [ -z "$LISTA_METRICAS" ]; then
    echo "ERRO: Não foi possível obter as métricas. Verifique o link ou se o Python3 está instalado."
    exit 1
fi

echo "Métricas encontradas. Iniciando downloads..."

# 3. Loop de download
AGORA=$(date +%s)
INICIO=$((AGORA - 7200))

for m in $LISTA_METRICAS; do
    echo "Baixando: $m"
    curl -s -k -G "$URL/api/v1/query_range" \
        --data-urlencode "query=$m" \
        --data-urlencode "start=$INICIO" \
        --data-urlencode "end=$AGORA" \
        --data-urlencode "step=30s" \
        -o "$OUTPUT_DIR/${m}.json"
done

echo "Concluído! Arquivos em $OUTPUT_DIR"