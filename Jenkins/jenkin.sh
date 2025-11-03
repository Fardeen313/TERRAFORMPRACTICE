#!/bin/bash

# Install Git
yum install git -y

# Install required dependencies for Terraform
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# Install Java 21 Amazon Corretto
sudo yum install -y java-21-amazon-corretto.x86_64


# Add Jenkins repository and install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install -y jenkins

# Start and enable Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Display Jenkins initial admin password
echo "Jenkins Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Ensure the password is displayed on login
echo 'echo "Jenkins Initial Admin Password:"' >> ~/.bashrc
echo 'sudo cat /var/lib/jenkins/secrets/initialAdminPassword' >> ~/.bashrc
