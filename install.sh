#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}Install Xfce packages${reset}"

sudo sed -i -e 's|%wheel ALL=(ALL:ALL) ALL|%wheel  ALL=(ALL) NOPASSWD: ALL|g' /etc/sudoers.d/10-installer
sudo cp /home/antidote/myconfig/files/02_g_wheel /etc/sudoers.d/
sudo rm /etc/sudoers.d/10-installer

sudo pacman -Sy - < xfce_pkgs.txt --noconfirm
sudo sed -i -e 's|Exec=geany %F|Exec=geany -i %F|g' /usr/share/applications/geany.desktop
sudo systemctl enable lightdm.service

sudo cp -r /home/antidote/myconfig/files/userconfig/.config /home/antidote/
sudo cp -r /home/antidote/myconfig/files/packarch-icon.png /home/antidote/.face
sudo cp -r /home/antidote/myconfig/files/environment /etc/environment
sudo cp -r /home/antidote/myconfig/files/userconfig/.profile /home/antidote/.profile
sudo cp -r /home/antidote/myconfig/files/packarch-icon.png /usr/share/pixmaps/packarch.png
sudo cp -r /home/antidote/myconfig/files/backgrounds/packarch /usr/share/backgrounds/packarch
sudo chown -R antidote:antidote /home/antidote
xfce4-set-wallpaper /usr/share/backgrounds/packarch/test.jpg

rustup toolchain install stable
yay -Sy --noconfirm filebot rustrover autofs
## -------------------------------------------------------------- ##
## Add syno nfs share to autofs
#sed -i -e 's|/misc.*|/mnt /etc/auto.nfs --ghost,--timeout=60|g' /etc/autofs/auto.master
#systemctl enable autofs.service
