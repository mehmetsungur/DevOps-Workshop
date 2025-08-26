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
                sh 'mvn test'
                echo "Running Unit Tests Completed"
            }
        }

        stage("SonarQube Analysis") {
            environment {
                scannerHome = tool 'mehmetsungur-sonar-scanner'
            }
            steps {
                withSonarQubeEnv('mehmetsungur-sonarqube') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

        stage("Quality Gate"){
            steps {
                script {
                timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
                def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
                if (qg.status != 'OK') {
                error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
    }
}
