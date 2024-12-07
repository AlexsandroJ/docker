pipeline {
    agent any
    stages {
        stage('test 1 ') {
            steps {
                sh 'docker image build -f Dockerfile-jenkins -t jenkins . --network host'
            }
        }
    }
}