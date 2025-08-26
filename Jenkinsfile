pipeline {
    agent { label 'maven' }

    environment {
        PATH = "/opt/apache-maven-3.9.11/bin:${env.PATH}"
    }

    stages {
        stage("Build & Deploy") {
            steps {
                sh 'mvn clean deploy -DskipTests'
            }
        }
    }
}
