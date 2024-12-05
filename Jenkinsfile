pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        IMAGE_NAME = 'seu_usuario_docker_hub/nginx-app'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}")
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        docker.image("${IMAGE_NAME}").push()
                    }
                }
            }
        }
        stage('Run') {
            steps {
                script {
                    docker.run("${IMAGE_NAME}", '-p 8080:80')
                }
            }
        }
    }
}
