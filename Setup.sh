#!/bin/bash

#Check if root
if [ "$EUID" -ne 0 ]
  then echo "Run as root user: sudo su"
  exit
fi

#Clean home folder crontab mount shared host drive 
rmdir ~/Music ~/Public ~/Videos ~/Templates ~/Desktop &>/dev/null
mkdir ~/Shared/
echo "@reboot /usr/bin/vmhgfs-fuse .host:/ ~/Shared/ -o subtype=vmhgfs-fuse,allow_other" >> /var/spool/cron/crontabs/root

#Sudo with no password
echo "kali ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#Turn off sleeps and locks (hopefully)
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-ac -s 0 --create --type int
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-off -s 0 --create --type int
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-sleep -s 0 --create --type int
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-on-ac -s 14 --create --type int

#Change the fucking terrible background
wget -O /usr/share/backgrounds/kali/Kali.jpg https://raw.githubusercontent.com/Scrogga/KaliSetup/main/Kali.jpg
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s /usr/share/backgrounds/kali/Kali.jpg
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s /usr/share/backgrounds/kali/Kali.jpg

#Remove qterminal transperancy
sed -i 's/ApplicationTransparency=5/ApplicationTransparency=0/' ~/.config/qterminal.org/qterminal.ini

#Disable LLMNR
echo '[Match]
name=*
[Network]
LLMNR=no' > /etc/systemd/network/90-disable-llmnr.network

#Set alias
echo '\n#Alias
alias cme="crackmapexec"
alias ll="ls -lah"' >> ~/.zshrc

#Install some shit
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
apt update -y
apt install -y \
    realtek-rtl88xxau-dkms \
    htop \
    sublime-text
pip3 install venv
pip3 install certipy-ad
pip3 install mitm6
apt full-upgrade -y

#Random inits
msfdb init
updatedb

#Clean reboot
reboot now