#!/bin/bash
apt-get update -y

apt-get install -y docker.io docker-compose

systemctl start docker
systemctl enable docker

docker run -d -p 80:80 --name test-app nginxdemos/hello