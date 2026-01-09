pipeline {
    agent any

    environment {
        IMAGE_NAME = "shankarduppala/myapp"
        KUBECONFIG = "C:\\Users\\Shankar Rao Duppala\\.kube\\config"
    }

    parameters {
        choice(
            name: 'DEPLOYMENT',
            choices: ['blue', 'green', 'rollback'],
            description: 'Choose deployment strategy'
        )
    }

    stages {

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/shankarduppala/jenkins_k8s_Blue_Green_deploy.git',
                    branch: 'main'
            }
        }

        stage('Build Docker Image') {
            when { expression { params.DEPLOYMENT != 'rollback' } }
            steps {
                bat """
                  docker build -t %IMAGE_NAME%:%DEPLOYMENT%-%BUILD_NUMBER% .
                """
            }
        }

        stage('Push Docker Image') {
            when { expression { params.DEPLOYMENT != 'rollback' } }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    bat """
                      echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                      docker push %IMAGE_NAME%:%DEPLOYMENT%-%BUILD_NUMBER%
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                bat """
                  kubectl get nodes
                  kubectl apply -f k8s/
                """
            }
        }
    }

    post {
        success {
            echo "Deployment Successful 🚀"
        }
        failure {
            echo "Deployment Failed ❌"
        }
    }
}
