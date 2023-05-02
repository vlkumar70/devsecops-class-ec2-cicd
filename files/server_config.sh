#! /bin/bash

curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install fontconfig openjdk-11-jre -y
sudo apt-get install jenkins -y
sudo systemctl start jenkins 
sudo apt-get install apt-utils -y
sudo apt install docker.io -y
sudo snap install docker
sudo service docker restart
sudo chmod 777 /var/run/docker.sock
sudo chmod -R 777 /var/lib/jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
