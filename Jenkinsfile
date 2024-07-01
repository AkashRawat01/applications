pipeline {
    agent any
    environment {
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
    }
    stages {
        stage('Checkout SCM'){
            steps{
                script{
                    sh 'rm -rf mydb-helm-chart*'
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/AkashRawat01/applications.git']]) //Generate  using pipeline syntax
                }
            }
        }
        stage('Select EKS Cluster') {
            steps {
                sh 'echo "Selected EKS Cluster is ${EKS_Cluster}"'
                sh 'kubectl config use-context ${EKS_Cluster}'
                sh 'kubectl config current-context'
            }
        }
        stage('Check Kubernetes Nodes') {
            steps {
                sh 'kubectl get nodes'
            }
        }
        stage('Installing Monitoring and Auditing on EKS cluster'){
            when{
                environment name:'Deploy_Database_and_DBeaver',value: 'true'
            }
            steps{
                script{
                    sh 'helm install -n application database ./mydb-helm-chart'
                }
            }
        }
        stage('Uninstalling Monitoring and Auditing on EKS cluster'){
            when{
                environment name:'Uninstall_Database_and_DBeaver',value: 'true'
            }
            steps{
                script{
                    sh 'helm uninstall database -n application'
                }    
            }
        }
    }
}
