pipeline {
    agent any
    
    environment {
        // Docker image name
        DOCKER_IMAGE = 'name-display-app'
        // Container name
        CONTAINER_NAME = 'name-display-app-container'
        // Port to run the app
        APP_PORT = '3000'
    }
    
    stages {
        stage('Checkout') {
            steps {
                // This stage automatically checks out code from Git
                echo 'Checking out code from Git repository...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    // Build the Docker image
                    sh "docker build -t ${DOCKER_IMAGE}:latest ."
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                }
            }
        }
        
        stage('Stop Old Container') {
            steps {
                echo 'Stopping and removing old container if exists...'
                script {
                    // Stop and remove old container (ignore errors if not exists)
                    sh """
                        docker stop ${CONTAINER_NAME} || true
                        docker rm ${CONTAINER_NAME} || true
                    """
                }
            }
        }
        
        stage('Run New Container') {
            steps {
                echo 'Running new Docker container...'
                script {
                    // Run the new container
                    sh """
                        docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${APP_PORT}:${APP_PORT} \
                        --restart unless-stopped \
                        ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment...'
                script {
                    // Wait a bit for container to start
                    sh 'sleep 5'
                    // Check if container is running
                    sh "docker ps | grep ${CONTAINER_NAME}"
                    // Check container logs
                    sh "docker logs ${CONTAINER_NAME}"
                }
            }
        }
        
        stage('Cleanup Old Images') {
            steps {
                echo 'Cleaning up old Docker images...'
                script {
                    // Remove dangling images to save space
                    sh 'docker image prune -f'
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline completed successfully!'
            echo "🚀 Application is running on port ${APP_PORT}"
            echo "🌐 Access it at: http://YOUR_EC2_IP:${APP_PORT}"
        }
        failure {
            echo '❌ Pipeline failed! Check the logs above.'
        }
        always {
            echo 'Pipeline execution finished.'
        }
    }
}