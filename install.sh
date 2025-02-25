#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}Install Xfce packages${reset}"
sudo pacman -S - < xfce_pkgs.txt --noconfirm
sudo sed -i -e 's|Exec=geany %F|Exec=geany -i %F|g' /usr/share/applications/geany.desktop
sudo cp -R /files/userconfig/.config /home/${USER}
sudo cp -R /files/backgrounds/packarch /usr/share/backgrounds/packarch
echo "${USER}"
