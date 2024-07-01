pipeline{
    agent{
        node{
            label 'Build-server'
        }
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('Akash_Access_ID')
        AWS_SECRET_ACCESS_KEY = credentials('Akash_Secret_Access_ID')
        AWS_DEFAULT_REGION = 'us-east-1'
        Dev_Cluster_Name   = 'Staging-dev-eks'
    }
    stages{
        stage('Checkout SCM'){
            steps{
                script{
                    sh 'rm -rf stage_prometheus_values.yaml'
                    checkout scmGit(branches: [[name: '*/prometheus']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/AkashRawat01/applications.git']]) //Generate  using pipeline syntax
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
        stage('Deploy Monitoring and Auditing on EKS cluster'){
            when{
                environment name:'Deploy Monitoring and Auditing Helm',value: 'true'
            }
            steps{
                script{
                    sh '''
                    helm repo add stable https://charts.helm.sh/stable
                    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
                    kubectl create namespace prometheus
                    helm install stable prometheus-community/kube-prometheus-stack -n prometheus -f stage_prometheus_values.yaml
                    '''
                }
            }
        }
        stage('Remove Monitoring and Auditing on EKS cluster'){
            when{
                environment name:'Remove Monitoring and Auditing Helm',value: 'true'
            }
            steps{
                script{
                    sh '''
                    helm uninstall stable -n prometheus
                    kubectl delete ns prometheus
                    '''
                }    
            }
        }
    }
}
