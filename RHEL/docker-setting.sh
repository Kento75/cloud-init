#!/bin/sh -ex

HOST_NAME="standard-setting"

# timezon
echo "Set TimeZone"
timedatectl set-timezone  Asia/Tokyo

# hostname
echo "Set HostName : $HOST_NAME"
hostnamectl set-hostname --static "$HOST_NAME"
echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg

# time sync
echo "Settings chrony"
yum erase 'ntp*'
yum install chrony
echo '#Add TimeSync' >> /etc/chrony.conf
echo 'server 169.254.169.123 prefer iburst' >> /etc/chrony.conf
systemctl start chrony
systemctl enable chrony

# locale
echo "default lunguage is ja_JP.utf8"
localectl set-locale LANG=ja_JP.utf8

# docker install
echo "Docker Settings"
yum update
yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast
yum install -y docker-ce

systemctl start docker
groupadd docker
usermod -aG docker $USER
systemctl enable docker

# Docker-Compose Install
curl -L https://github.com/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
