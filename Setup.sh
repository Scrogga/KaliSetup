#!/bin/bash

#Check if root
if [ "$EUID" -ne 0 ]
  then echo "Run as root user: sudo su"
  exit
fi

#Mount shared host drive
mkdir /home/kali/Shared/
echo "@reboot /usr/bin/vmhgfs-fuse .host:/ /home/kali/Shared/ -o subtype=vmhgfs-fuse,allow_other" >> /var/spool/cron/crontabs/root

#Sudo with no password
echo "kali ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#Full update
apt update
apt full-upgrade

#Change the fucking terrible background


#Clean reboot
reboot now