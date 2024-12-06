pipeline {
    agent any
    stages {
        stage('test 1 ') {
            steps {
                sh 'git -v'
            }
        }
        stage('test 3') {
            steps {
                script{
                    """
                        docker pull alpine
                    """
                }
                
            }
        }
    }
}