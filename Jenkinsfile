pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "busapooja/terraform-devops-project:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/PoojaBusa09/terraform-devops-project.git'
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

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push ${DOCKER_IMAGE}
                    '''
                }
            }
        }

        stage('Kubernetes Deploy') {
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
            echo "🚀 PIPELINE SUCCESS"
        }
        failure {
            echo "❌ PIPELINE FAILED"
        }
    }
}
