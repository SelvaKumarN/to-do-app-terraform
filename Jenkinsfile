pipeline {
    agent any

    parameters {
        choice(name: 'Action', choices: ['plan', 'apply', 'destroy'],  description: 'Choose terraform actions')
    }
    
    stages {
                
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/SelvaKumarN/to-do-app-terraform.git']]])     
            }
        }

        stage('Plan') {
            when {
                equals expected: "plan", actual: params.Action
            }
            steps {
                sh 'terraform init -input=false'
                sh 'terraform validate'
                sh "terraform plan -input=false -out tfplan"
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'tfplan.txt', onlyIfSuccessful: true
                }
            }
        }      
   
        stage('Apply') {
            when {
                equals expected: "apply", actual: params.Action
            }
            steps {
                sh "terraform apply -input=false tfplan"
            }
        }
        stage('Destroy') {
            when {
                equals expected: "destroy", actual: params.Action
            }
            steps {
                sh "terraform destroy -auto-approve"
            }
        }
    }
}