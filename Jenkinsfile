pipeline {
    stage('Front-end') {
        agent {
            docker { image 'node:22.12.0-alpine3.20' }
        }
        steps {
            sh 'node --version'
        }
    }
}
