#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}Install Xfce packages${reset}"
sudo rm /etc/sudoers.d/10-installer
sudo cp /home/${USER}/myconfig/files/02_g_wheel /etc//etc/sudoers.d/

sudo pacman -S - < xfce_pkgs.txt --noconfirm
sudo sed -i -e 's|Exec=geany %F|Exec=geany -i %F|g' /usr/share/applications/geany.desktop
sudo systemctl enable lightdm.service

sudo cp -r /home/${USER}/myconfig/files/backgrounds/packarch /usr/share/backgrounds/packarch
cp -r /home/${USER}/myconfig/files/userconfig/.config /home/${USER}/
cp -r /home/${USER}/myconfig/files/packarch-icon.png /home/${USER}/.face
sudo cp -r /home/${USER}/myconfig/files/packarch-icon.png /usr/share/pixmaps/packarch.png



eos-wallpaper-set /usr/share/backgrounds/packarch/default.jpg
