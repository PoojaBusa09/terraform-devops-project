pipeline {
    agent any

    environment {
        DOCKER_HUB = 'busapooja'
        IMAGE_NAME = 'devopsprojects'
        IMAGE_TAG = 'latest'
        FULL_IMAGE = "busapooja/devopsprojects:latest"
        GIT_REPO = 'https://github.com/PoojaBusa09/terraform-devops-project.git'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $FULL_IMAGE ."
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push $FULL_IMAGE"
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
            echo "🚀 Pipeline Success"
        }
        failure {
            echo "❌ Pipeline Failed"
        }
    }
}
