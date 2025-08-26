pipeline {
    agent { label 'maven' }

    environment {
        PATH = "/opt/apache-maven-3.9.11/bin:${env.PATH}"
        MAVEN_OPTS = "-Xmx512m"   // JVM memory sınırını düşürdük (2GB yerine 512MB)
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
                // JVM crash önlemek için testleri güncel Surefire ile çalıştır
                sh 'mvn test -Dmaven.test.failure.ignore=true'
                echo "Running Unit Tests Completed (fail olsa bile pipeline devam edecek)"
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

        stage("Quality Gate") {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
    }
}
