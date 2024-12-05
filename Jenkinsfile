pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        IMAGE_NAME = 'alpine'
    }

    stages {
        stage('Start') {
            steps {
                script {
                    echo "end"
                }
            }
        }
        stage ('Docker Build'){
            sh """
                docker container run -p 80:80 - p 443:443 nginx
            """
    }
        /*
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
        } */
        stage('End') {
            steps {
                script {
                    echo "end"
                }
            }
        }
    }
}
