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

        stage("SonarQube Analysis") {
        environment {
            scannerHome = tool 'mehmetsungur-sonar-scanner';
        }

        steps{
            withSonarQubeEnv('mehmetsungur-sonarqube') {
                sh "${scannerHome}/bin/sonar-scanner"
            }
        }
        }
    }
}
