pipeline {
    agent any

    tools {
        maven 'Maven3'
    }

    environment {
        PROJECT_NAME = "terraform-devops-project"
        DOCKER_IMAGE = "busapooja/terraform-devops-project:${BUILD_NUMBER}"
    }

    stages {

      stage('Checkout') {
    steps {
        git branch: 'main',
        url: 'https://github.com/PoojaBusa09/terraform-devops-project.git',
        credentialsId: 'github-creds'
    }
}
        stage('Build & Test') {
            steps {
                sh 'mvn clean install -DskipTests'
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

                    sh """
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                kubectl apply -f k8s/deployment.yml
                kubectl apply -f k8s/service.yml
                """
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
