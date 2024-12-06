pipeline {
    agent {
        docker { image 'node:22.12.0-alpine3.20' }
    }
    
    stages {
        stage('Test') {
            steps {
                sh 'node --eval "console.log(process.platform,process.env.CI)"'
            }
        }
    }
}