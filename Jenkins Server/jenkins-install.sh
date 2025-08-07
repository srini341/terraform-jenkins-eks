#!/bin/bash
sudo yum update -y
# Add the Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
# Import the Jenkins repository key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum update -y
sudo yum install java-17-amazon-corretto -y
# Install Jenkins
sudo yum install jenkins -y
# Start the Jenkins service
sudo systemctl start jenkins
# Enable the service to start on boot
sudo systemctl enable jenkins
# Check the status to ensure it's running
sudo systemctl status jenkins
# then install git
sudo yum install git -y
#then install terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
#finally install kubectl
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin