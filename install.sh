#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}Allow all wheel without password${reset}"
sudo sed -i -e 's|%wheel ALL=(ALL:ALL) ALL|%wheel  ALL=(ALL) NOPASSWD: ALL|g' /etc/sudoers.d/10-installer 2>log.txt
sudo cp /home/antidote/myconfig/files/02_g_wheel /etc/sudoers.d/ 2>log.txt
sudo rm /etc/sudoers.d/10-installer 2>log.txt

echo "${green}Install Xfce packages${reset}"
sudo pacman -Sy - < xfce_pkgs.txt --noconfirm 2>log.txt

echo "${green}Geany in new instances${reset}"
sudo sed -i -e 's|Exec=geany %F|Exec=geany -i %F|g' /usr/share/applications/geany.desktop 2>log.txt

echo "${green}Enable lightdm${reset}"
sudo systemctl enable lightdm.service 2>log.txt

echo "${green}Copy cofigs files${reset}"
sudo cp -r /home/antidote/myconfig/files/userconfig/.config /home/antidote/ 2>log.txt
sudo cp -r /home/antidote/myconfig/files/packarch-icon.png /home/antidote/.face 2>log.txt
sudo cp -r /home/antidote/myconfig/files/environment /etc/environment 2>log.txt
sudo cp -r /home/antidote/myconfig/files/userconfig/.profile /home/antidote/.profile 2>log.txt
sudo cp -r /home/antidote/myconfig/files/packarch-icon.png /usr/share/pixmaps/packarch.png 2>log.txt
sudo cp -r /home/antidote/myconfig/files/backgrounds/packarch /usr/share/backgrounds/packarch 2>log.txt

echo "${green}Change owner${reset}"
sudo chown -R antidote:antidote /home/antidote 2>log.txt

echo "${green}Set wallpaper${reset}"
xfce4-set-wallpaper /usr/share/backgrounds/packarch/test.jpg 2>log.txt

rustup toolchain install stable 2>log.txt
yay -Sy --noconfirm filebot rustrover autofs 2>log.txt
## -------------------------------------------------------------- ##
## Add syno nfs share to autofs
sudo cp -r /home/antidote/myconfig/files/auto.nfs /etc/auto.nfs 2>log.txt
sudo sed -i -e 's|/misc.*|/mnt /etc/auto.nfs --ghost,--timeout=60|g' /etc/autofs/auto.master 2>log.txt
sudo systemctl enable autofs.service 2>log.txt
