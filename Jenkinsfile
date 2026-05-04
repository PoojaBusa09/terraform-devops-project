pipeline {
    agent any

    environment {
        PROJECT_NAME = "terraform-devops-project"

        GIT_REPO = "https://github.com/PoojaBusa09/terraform-devops-project.git"

        DOCKER_IMAGE = "busapooja/terraform-devops-project:latest"

        SONAR_PROJECT_KEY = "terraform-devops-project"
        SONAR_PROJECT_NAME = "terraform-devops-project"
        SONAR_HOST_URL = "http://192.168.0.50:9000"
    }

    tools {
        maven 'Maven3'
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: "${GIT_REPO}"
                    ]],
                    extensions: [
                        [$class: 'CloneOption', shallow: true, depth: 1, timeout: 20]
                    ]
                ])
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                        -Dsonar.projectName=${SONAR_PROJECT_NAME} \
                        -Dsonar.host.url=${SONAR_HOST_URL} \
                        -Dsonar.login=${SONAR_TOKEN}
                        """
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    script {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "❌ Quality Gate Failed: ${qg.status}"
                        } else {
                            echo "✔ Quality Gate Passed"
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push busapooja/terraform-devops-project:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f k8s/deployment.yml
                kubectl apply -f k8s/service.yml
                '''
            }
        }
    }

    post {
        success {
            echo "🚀 PIPELINE SUCCESS - ${PROJECT_NAME}"
        }
        failure {
            echo "❌ PIPELINE FAILED - ${PROJECT_NAME}"
        }
        always {
            echo "✔ Pipeline execution completed"
        }
    }
}
