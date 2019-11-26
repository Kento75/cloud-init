#!/bin/bash

HOST_NAME="CODEDEPLOY-FOR-JAVA"

### Amazon Linux 2

# Package Update
sudo yum update -y

# timezon
echo "Set TimeZone"
sudo timedatectl set-timezone Asia/Tokyo

# hostname
echo "Set HostName : $HOST_NAME"
sudo hostnamectl set-hostname --static "$HOST_NAME"
sudo echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg

# locale
echo "default lunguage is ja_JP.utf8"
sudo localectl set-locale LANG=ja_JP.utf8

# time sync
echo "Settings chrony"
sudo yum erase -y 'ntp*'
sudo yum install -y chrony
sudo echo '#Add TimeSync' >> /etc/chrony.conf
sudo echo 'server 169.254.169.123 prefer iburst' >> /etc/chrony.conf
sudo systemctl start chrony
sudo systemctl enable chrony

# java & tomcat setup
sudo yum install -y erase java-1.7.0-openjdk.x86_64
sudo yum install -y java-11-openjdk
sudo yum install -y java-11-openjdk-devel
# 本当はTomcat9 使いたいけど妥協
sudo amazon-linux-extras install tomcat8.5

# codedeploy agent setup
# documents -> https://docs.aws.amazon.com/ja_jp/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html
sudo yum install -y ruby
sudo yum install -y wget
cd /home/ec2-user
wget https://bucket-name.s3.region-identifier.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# end

