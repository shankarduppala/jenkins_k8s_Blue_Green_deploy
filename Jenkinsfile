pipeline {
    agent any

    environment {
        IMAGE_NAME = "shankarduppala/myapp"
        VERSION = "${BUILD_NUMBER}"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
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
                git url: 'https://github.com/your-org/jenkins-k8s-project.git',
                    branch: 'main'
            }
        }

        stage('Build Docker Image') {
            when { expression { params.DEPLOYMENT != 'rollback' } }
            steps {
                sh """
                  docker build \
                  --build-arg VERSION=${VERSION} \
                  -t ${IMAGE_NAME}:${params.DEPLOYMENT} .
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
                    sh """
                      echo $PASS | docker login -u $USER --password-stdin
                      docker push ${IMAGE_NAME}:${params.DEPLOYMENT}
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                  if [ "${params.DEPLOYMENT}" = "blue" ]; then
                    kubectl apply -f k8s/deploy-blue.yaml
                    kubectl patch svc web-svc -p '{"spec":{"selector":{"version":"blue"}}}'
                  elif [ "${params.DEPLOYMENT}" = "green" ]; then
                    kubectl apply -f k8s/deploy-green.yaml
                    kubectl patch svc web-svc -p '{"spec":{"selector":{"version":"green"}}}'
                  else
                    kubectl patch svc web-svc -p '{"spec":{"selector":{"version":"blue"}}}'
                  fi
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
