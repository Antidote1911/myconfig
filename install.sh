#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}Install Xfce packages${reset}"
rm /etc/sudoers.d/10-installer
cp /home/${USER}/myconfig/files/02_g_wheel /etc/sudoers.d/
#sudo useradd -m -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/bash $username

pacman -S - < xfce_pkgs.txt --noconfirm
sed -i -e 's|Exec=geany %F|Exec=geany -i %F|g' /usr/share/applications/geany.desktop
systemctl enable lightdm.service

cp -r /home/${USER}/myconfig/files/backgrounds/packarch /usr/share/backgrounds/packarch
cp -r /home/${USER}/myconfig/files/userconfig/.config /home/${USER}/
cp -r /home/${USER}/myconfig/files/packarch-icon.png /home/${USER}/.face
cp -r /home/${USER}/myconfig/files/packarch-icon.png /usr/share/pixmaps/packarch.png

eos-wallpaper-set /usr/share/backgrounds/packarch/default.jpg
