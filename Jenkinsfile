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
                sh 'docker image build -f Dockerfile-jenkins -t jenkins . --network host'
            }
        }
    }
}