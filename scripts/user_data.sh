#!/bin/bash

wait_for_apt() {
  TIMEOUT=120
  START_TIME=$(date +%s)
  while ! apt-get update >/dev/null 2>&1 && [ $(( $(date +%s) - $START_TIME )) -lt $TIMEOUT ]; do
    echo "Waiting for apt lock to clear..."
    sleep 5
  done
}

echo "Starting user-data script execution..." >> /var/log/cloud-init-output.log

wait_for_apt
apt-get update -y
echo "APT update finished." >> /var/log/cloud-init-output.log

apt-get install -y docker.io docker-compose -qqy 
echo "Docker installed." >> /var/log/cloud-init-output.log
r
systemctl start docker
systemctl enable docker
echo "Docker service started and enabled." >> /var/log/cloud-init-output.log

sleep 10 
echo "Checking docker status..." >> /var/log/cloud-init-output.log

docker run -d -p 80:80 --name test-app nginxdemos/hello
echo "Test application launched." >> /var/log/cloud-init-output.log

echo "User-data script finished successfully." >> /var/log/cloud-init-output.log