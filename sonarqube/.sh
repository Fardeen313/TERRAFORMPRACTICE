#!/bin/bash

# Copy script to /opt directory (use correct file name)  
sudo cp "$0" /opt  

# Navigate to /opt directory  
cd /opt  

# Install Maven and Git  
sudo yum install -y maven git  

# Download SonarQube  
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.6.50800.zip  

# Unzip SonarQube package  
sudo unzip sonarqube-8.9.6.50800.zip  

# Create a Sonar user  
sudo useradd sonar  

# Set ownership and permissions for SonarQube  
sudo chown -R sonar:sonar sonarqube-8.9.6.50800  
sudo chmod -R 755 sonarqube-8.9.6.50800  

# Set password for Sonar user  
  
echo "admin" | sudo passwd --stdin sonar  

# Switch to Sonar user  
su - sonar 

cd /opt


 



