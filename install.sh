#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}Install Xfce packages${reset}"
rm /etc/sudoers.d/10-installer
cp /home/antidote/myconfig/files/02_g_wheel /etc/sudoers.d/
useradd -m -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/bash antidote

pacman -S - < xfce_pkgs.txt --noconfirm
sed -i -e 's|Exec=geany %F|Exec=geany -i %F|g' /usr/share/applications/geany.desktop
systemctl enable lightdm.service

cp -r /home/antidote/myconfig/files/backgrounds/packarch /usr/share/backgrounds/packarch
cp -r /home/antidote/myconfig/files/userconfig/.config /home/antidote/
cp -r /home/antidote/myconfig/files/packarch-icon.png /home/antidote/.face
cp -r /home/antidote/myconfig/files/packarch-icon.png /usr/share/pixmaps/packarch.png
chown antidote:group directory /home/antidote

eos-wallpaper-set /usr/share/backgrounds/packarch/default.jpg
