pipeline {
    agent any
    stages {
        stage('test 1 ') {
            steps {
                sh 'git -v'
            }
        }
        stage('test 2') {
            steps {
                sh 'cd portifolio'
                sh 'docker container run -dit --name app -p 3000:3000 nginx'
            }
        }
    }
}