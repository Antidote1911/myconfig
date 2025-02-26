#!/bin/bash

sudo sed -i -e 's|%wheel ALL=(ALL:ALL) ALL|%wheel  ALL=(ALL) NOPASSWD: ALL|g' /etc/sudoers.d/10-installer 2>log.txt
sudo cp /home/antidote/myconfig/files/02_g_wheel /etc/sudoers.d/ 2>log.txt
sudo rm /etc/sudoers.d/10-installer 2>log.txt

sudo pacman -Sy - < xfce_pkgs.txt --noconfirm 2>log.txt

sudo sed -i -e 's|Exec=geany %F|Exec=geany -i %F|g' /usr/share/applications/geany.desktop 2>log.txt

sudo systemctl enable lightdm.service 2>log.txt

sudo cp -r /home/antidote/myconfig/files/userconfig/.config /home/antidote/ 2>log.txt
sudo cp -r /home/antidote/myconfig/files/userconfig/.config /root/ 2>log.txt
sudo cp -r /home/antidote/myconfig/files/packarch-icon.png /home/antidote/.face 2>log.txt
sudo cp -r /home/antidote/myconfig/files/environment /etc/environment 2>log.txt
sudo cp -r /home/antidote/myconfig/files/userconfig/.profile /home/antidote/.profile 2>log.txt
sudo cp -r /home/antidote/myconfig/files/packarch-icon.png /usr/share/pixmaps/packarch.png 2>log.txt
sudo cp -r /home/antidote/myconfig/files/backgrounds/packarch /usr/share/backgrounds/packarch 2>log.txt

#sudo sed -i -e 's|Exec=geany %F|Exec=geany -i %F|g' /etc/lightdm/slick-greeter.conf 2>log.txt
sudo sed -i -e 's|color_scheme=nordic.conf|color_scheme=dark-colors.conf|g' /root/.config/geany/geany.conf 2>log.txt

sudo chown -R antidote:antidote /home/antidote 2>log.txt

xfce4-set-wallpaper /usr/share/backgrounds/packarch/test.jpg 2>log.txt

rustup toolchain install stable 2>log.txt
yay -Sy --noconfirm filebot rustrover autofs 2>log.txt
## -------------------------------------------------------------- ##
## Add syno nfs share to autofs
sudo cp -r /home/antidote/myconfig/files/auto.nfs /etc/auto.nfs 2>log.txt
sudo sed -i -e 's|/misc.*|/mnt /etc/auto.nfs --ghost,--timeout=60|g' /etc/autofs/auto.master 2>log.txt
sudo systemctl enable autofs.service 2>log.txt
