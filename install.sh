#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

USER=$(whoami)
echo "${green} Utilisateur ${whoami} ${reset}"

echo "${green}Install full desktop or minimal ?${reset}"
read -p "1 - Full, 0 - Minimal: " vm_setting

sudo sed -i -e 's|%wheel ALL=(ALL:ALL) ALL|%wheel  ALL=(ALL) NOPASSWD: ALL|g' /etc/sudoers.d/10-installer 2>>log.txt
sudo cp /home/antidote/myconfig/files/02_g_wheel /etc/sudoers.d/ 2>>log.txt
sudo rm /etc/sudoers.d/10-installer 2>>log.txt

sudo pacman -S - < base_pkgs.txt --noconfirm 2>>log.txt

########## Only for full install ###########################
if [[ $vm_setting == 1 ]]; then
  echo "${green}Install full desktop and applications${reset}"
  yay -S - < extra_pkgs.txt --noconfirm 2>>log.txt
  rustup toolchain install stable 2>>log.txt
  ## Add syno nfs share to autofs
  sudo cp -r /home/antidote/myconfig/files/auto.nfs /etc/auto.nfs 2>>log.txt
  sudo sed -i -e 's|/misc.*|/mnt /etc/auto.nfs --ghost,--timeout=60|g' /etc/autofs/auto.master 2>>log.txt
  sudo systemctl enable autofs.service 2>>log.txt
fi
####################################################

sudo cp -r /home/antidote/myconfig/files/userconfig/.config /home/antidote/ 2>>log.txt
sudo cp -r /home/antidote/myconfig/files/userconfig/.config /root/ 2>>log.txt
sudo cp -r /home/antidote/myconfig/files/packarch-icon.png /home/antidote/.face 2>>log.txt
sudo cp -r /home/antidote/myconfig/files/environment /etc/environment 2>>log.txt
sudo cp -r /home/antidote/myconfig/files/userconfig/.profile /home/antidote/.profile 2>>log.txt
sudo cp -r /home/antidote/myconfig/files/packarch-icon.png /usr/share/pixmaps/packarch.png 2>>log.txt
sudo cp -r /home/antidote/myconfig/files/backgrounds/packarch /usr/share/backgrounds/packarch 2>>log.txt

sudo sed -i -e 's|background=/usr/share/endeavouros/backgrounds/endeavouros-wallpaper.png|background=/usr/share/backgrounds/packarch/default.jpg|g' /etc/lightdm/slick-greeter.conf 2>>log.txt
sudo sed -i -e 's|color_scheme=nordic.conf|color_scheme=dark-colors.conf|g' /root/.config/geany/geany.conf 2>>log.txt
sudo sed -i -e 's|Exec=geany %F|Exec=geany -i %F|g' /usr/share/applications/geany.desktop 2>>log.txt
sudo chown -R antidote:antidote /home/antidote 2>>log.txt

xfce4-set-wallpaper /usr/share/backgrounds/packarch/default.jpg 2>>log.txt
sudo systemctl enable lightdm.service 2>>log.txt

## Hide Unnecessary Apps
adir="/usr/share/applications"
apps=(avahi-discover.desktop bssh.desktop bvnc.desktop xfce4-about.desktop \
	org.pulseaudio.pavucontrol.desktop java-java-openjdk.desktop xfce4-mail-reader.desktop \
	hdajackretask.desktop hdspconf.desktop hdspmixer.desktop jconsole-java-openjdk.desktop jshell-java-openjdk.desktop \
	libfm-pref-apps.desktop lxshortcut.desktop lstopo.desktop \
	uxterm.desktop nm-connection-editor.desktop xterm.desktop \
	qvidcap.desktop stoken-gui.desktop stoken-gui-small.desktop assistant.desktop \
	qv4l2.desktop qdbusviewer.desktop mpv.desktop)

for app in "${apps[@]}"; do
	if [[ -e "$adir/$app" ]]; then
		sudo sed -i '$s/$/\nNoDisplay=true/' "$adir/$app" 2>>log.txt
	fi
done
