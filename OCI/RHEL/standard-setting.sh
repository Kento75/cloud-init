#!/bin/bash

HOST_NAME="standard-setting"

##### Oracle Linux 7 ↓

# firewall is disable
echo "Settings firewall is disable"
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# SELinux is disable
sudo sed -i -e 's/SELINUX=/#SELINUX=/g' /etc/selinux/config
sudo echo 'SELINUX=Disabled' >>  /etc/selinux/config

# Package Update
sudo yum update -y

# timezon
echo "Set TimeZone"
timedatectl set-timezone Asia/Tokyo

# hostname
echo "Set HostName : $HOST_NAME"
hostnamectl set-hostname --static "$HOST_NAME"
echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg

# locale
echo "default lunguage is ja_JP.utf8"
localectl set-locale LANG=ja_JP.utf8
