#! /bin/bash
sudo yum update -y
sudo yum install -y stress httpd
sudo systemctl start httpd 
sudo systemctl enable httpd
echo "<h1>Welcome to the autoscaling group</h1>" | sudo tee /var/www/html/index.html