#!/bin/bash
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>log.out 2>&1

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}Allow all wheel without password${reset}"
sudo sed -i -e 's|%wheel ALL=(ALL:ALL) ALL|%wheel  ALL=(ALL) NOPASSWD: ALL|g' /etc/sudoers.d/10-installer
sudo cp /home/antidote/myconfig/files/02_g_wheel /etc/sudoers.d/
sudo rm /etc/sudoers.d/10-installer

echo "${green}Install Xfce packages${reset}"
sudo pacman -Sy - < xfce_pkgs.txt --noconfirm

echo "${green}Geany in new instances${reset}"
sudo sed -i -e 's|Exec=geany %F|Exec=geany -i %F|g' /usr/share/applications/geany.desktop

echo "${green}Enable lightdm${reset}"
sudo systemctl enable lightdm.service

echo "${green}Copy cofigs files${reset}"
sudo cp -r /home/antidote/myconfig/files/userconfig/.config /home/antidote/
sudo cp -r /home/antidote/myconfig/files/packarch-icon.png /home/antidote/.face
sudo cp -r /home/antidote/myconfig/files/environment /etc/environment
sudo cp -r /home/antidote/myconfig/files/userconfig/.profile /home/antidote/.profile
sudo cp -r /home/antidote/myconfig/files/packarch-icon.png /usr/share/pixmaps/packarch.png
sudo cp -r /home/antidote/myconfig/files/backgrounds/packarch /usr/share/backgrounds/packarch

echo "${green}Change owner${reset}"
sudo chown -R antidote:antidote /home/antidote

echo "${green}Set wallpaper${reset}"
xfce4-set-wallpaper /usr/share/backgrounds/packarch/test.jpg

rustup toolchain install stable
yay -Sy --noconfirm filebot rustrover autofs
## -------------------------------------------------------------- ##
## Add syno nfs share to autofs
#sed -i -e 's|/misc.*|/mnt /etc/auto.nfs --ghost,--timeout=60|g' /etc/autofs/auto.master
#systemctl enable autofs.service
