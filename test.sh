pipeline {
    agent any

    stages {
        stage('Code Clone') {
            steps {
                echo 'Coding Phase'
				git url:"https://github.com/LondheShubham153/django-notes-app.git", branch: "main"
            }
        }
        
        stage('Build') {
            steps {
                echo 'Build Phase'
                sh "docker build -t notes-app ."
            }
        }

        
        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Phase'
				withCredentials([usernamePassword(credentialsId:"DockerHub",passwordVariable:"DockerHubPass",usernameVariable:"DockerHubUser")]){
				sh "docker tag notes-app ${env.DockerHubUser}/notes-app:latest"
				sh "docker login -u ${env.DockerHubUser} -p ${env.DockerHubPass}"
				sh "docker push ${env.DockerHubUser}/notes-app:latest"
				}
            }
        }
                
        stage('Deploy') {
            steps {
                echo 'Deploy Phase'
                sh "docker-compose down && docker-compose up -d"
            }
        }
    }
}
