#!/bin/bash

# This script is to be used as User Data to instantiate the AWS EC2 instance this app will run on

# update machine
sudo yum update -y
# install git
sudo yum install git
# install docker
sudo yum install -y docker
# enable docker service and start docker
sudo systemctl enable --now docker
# add ec2-user to docker group
sudo usermod -a -G docker ec2-user

# install docker compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# verify docker compose installation
docker-compose --version