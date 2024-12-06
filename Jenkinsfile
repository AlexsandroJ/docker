pipeline {
    stage('Back-end') {
        agent {
            docker { image 'maven:3.9.9-eclipse-temurin-21-alpine' }
        }
        steps {
            sh 'mvn --version'
        }
    }
    stage('Front-end') {
        agent {
            docker { image 'node:22.12.0-alpine3.20' }
        }
        steps {
            sh 'node --version'
        }
    }
}
