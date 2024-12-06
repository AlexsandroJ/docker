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
                sh 'ls'
            }
        }
        stage('test 3') {
            steps {
                sh 'docker container ls'
            }
        }
    }
}