#!/bin/bash

HOST_NAME="STANDARD-SETTING"

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

# end

