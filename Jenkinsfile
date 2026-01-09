pipeline {
    agent any

    environment {
        IMAGE_NAME = "shankarduppala/myapp"
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
                docker build --build-arg ENV=%DEPLOYMENT% -t %IMAGE_NAME%:%DEPLOYMENT%-%BUILD_NUMBER% .
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
            withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                bat """
                kubectl apply -f k8s\\service.yaml

                IF "%DEPLOYMENT%"=="blue" (
                    kubectl apply -f k8s\\deploy-blue.yaml
                    kubectl set image deployment/web-blue web=%IMAGE_NAME%:blue-%BUILD_NUMBER%
                    kubectl patch svc web-svc -p "{\\"spec\\":{\\"selector\\":{\\"version\\":\\"blue\\"}}}"
                ) ELSE IF "%DEPLOYMENT%"=="green" (
                    kubectl apply -f k8s\\deploy-green.yaml
                    kubectl set image deployment/web-green web=%IMAGE_NAME%:green-%BUILD_NUMBER%
                    kubectl patch svc web-svc -p "{\\"spec\\":{\\"selector\\":{\\"version\\":\\"green\\"}}}"
                ) ELSE (
                    kubectl patch svc web-svc -p "{\\"spec\\":{\\"selector\\":{\\"version\\":\\"blue\\"}}}"
                )
                """
                }
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
