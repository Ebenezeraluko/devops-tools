pipeline {
    agent { 
        node {
        label 'accessol-agent'
       }
    }
    tools {
        maven 'maven3'
        jdk 'jdk21'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'jenkins_bitbucket', url: 'https://Ebenezeri@bitbucket.org/blackcoders2019/stavigo-admin-serverside.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Package') {
            steps {
                sh 'docker rm stavigoportalive -f || true'
                sh 'docker build -t stavigoportal:live .'
            }
        }
        stage('Deploy to Production') {
            when {
                branch 'production'
            }
            steps {
                // Add your production deployment steps here
                sh 'echo "Deploying to Production environment"'
                sh 'docker run -d --name stavigoportalive -p 9091:8080 stavigoportal:live && sudo docker logs -f stavigoportalive'
            }
        }
    }
}