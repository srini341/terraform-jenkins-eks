pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage('Checkout SCM'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/feature/060825']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/srini341/terraform-jenkins-eks.git']])

                }
            }
        }
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Formatting Terraform Code'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform fmt'
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform validate'
                    }
                }
            }
        }
        stage('Previewing the Infra using Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform plan'
                    }
                    input(message: "Are you sure to proceed?", ok: "Proceed")
                }
            }
        }
        stage('Creating/Destroying an EKS Cluster'){
            steps{
                script{
                    dir('EKS') {
                        sh 'terraform $action --auto-approve'
                    }
                }
            }
        }
        stage('Deploying Nginx Application') {
            steps {
                script {
                    dir('EKS/ConfigurationFiles') {
                        // Ensure kubeconfig is set
                        sh 'aws eks update-kubeconfig --name my-eks-cluster'
        
                        // Preflight checks
                        sh 'echo "Current context: $(kubectl config current-context)"'
                        sh '''
                            if ! kubectl auth can-i list pods --all-namespaces; then
                              echo "ERROR: Insufficient RBAC permissions to list pods"
                              exit 1
                            fi
                        '''
        
                        // Apply manifests
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f service.yaml'
                    }
                }
            }
        }
  }
