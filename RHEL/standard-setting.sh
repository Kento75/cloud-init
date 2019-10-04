#!/bin/sh -ex

$HOST_NAME="standard-setting"

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
