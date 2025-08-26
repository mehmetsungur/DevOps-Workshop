pipeline {
    agent { label 'maven' }

    environment {
        PATH = "/opt/apache-maven-3.9.11/bin:${env.PATH}"
    }

    stages {
        stage("Build & Deploy") {
            steps {
                echo "Building & Deploying Application Started"
                sh 'mvn clean deploy -DskipTests'
                echo "Building & Deploying Application Completed"
            }
        }

        stage("Test") {
            steps {
                echo "Running Unit Tests Started"
                sh 'mvn surefire-report:report'
                echo "Running Unit Tests Completed"
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
