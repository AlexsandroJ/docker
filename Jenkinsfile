pipeline{
    agent any 
    stages{
        stage('Get Source'){
            steps{
                echo "Teste Source"
            }
        }

        stage('Docker Build'){
            steps{
                echo "Teste nginx"
                script { docker.build('nginx') }
            }
        }

        stage('Tests'){
            steps{
                echo "Teste Deploy"
            }
        }

        stage('Docker Deploy'){
            steps{
                echo "Teste Deploy"
            }
        }

        
    }
}