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

echo "Creating .env file..." >> /var/log/cloud-init-output.log

cat <<EOF > /env.txt
DATABASE_HOST=${DB_HOST}
DATABASE_USER=${DB_USER}
DATABASE_PASSWORD=${DB_PASS}
DATABASE_NAME=${DB_NAME}
EOF

docker run -d -p 80:3000 \
  -e MYSQL_HOST=${DB_HOST} \
  -e MYSQL_USER=${DB_USER} \
  -e MYSQL_PASSWORD=${DB_PASS} \
  -e MYSQL_DATABASE=${DB_NAME} \
  -e MYSQL_PORT=3306 \
  -e DB_INIT_SYNC=true \
  --name my-app \
  iksm69/ft_iac_app:latest

echo "Application launched." >> /var/log/cloud-init-output.log

echo "User-data script finished successfully." >> /var/log/cloud-init-output.log