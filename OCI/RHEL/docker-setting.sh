#!/bin/sh -ex

HOST_NAME="standard-setting"

# firewall is disable
echo "Settings firewall is disable"
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Package Update
sudo yum update -y

# timezon
echo "Set TimeZone"
timedatectl set-timezone Asia/Tokyo

# hostname
echo "Set HostName : $HOST_NAME"
hostnamectl set-hostname --static "$HOST_NAME"
echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg

# time sync
echo "Settings chrony"
yum erase -y 'ntp*'
sudo yum install -y chrony
echo '#Add TimeSync' >> /etc/chrony.conf
echo 'server 169.254.169.123 prefer iburst' >> /etc/chrony.conf
sudo systemctl start chrony
sudo systemctl enable chrony

# locale
echo "default lunguage is ja_JP.utf8"
localectl set-locale LANG=ja_JP.utf8

# docker install
echo "Docker Settings"
sudo yum update -y
sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y
sudo yum makecache fast -y
sudo yum install -y docker-ce

sudo systemctl start docker
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

# Docker-Compose Install
curl -L https://github.com/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
