#! bin/bash
sudo yum update -y
sudo yum install httpd -y 
sudo systemctl start httpd
sudo systemctl enable httpd
echo " <h1> Welcome to My App <h2> " > /var/www/html/index.html