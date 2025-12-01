#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

USER=$(whoami)

echo "${green}Install full desktop or minimal ?${reset}"
read -p "1 - Full, 0 - Minimal: " vm_setting

sudo sed -i -e 's|%wheel ALL=(ALL:ALL) ALL|%wheel  ALL=(ALL) NOPASSWD: ALL|g' /etc/sudoers.d/10-installer 2>>log.txt
sudo cp /home/${USER}/myconfig/files/02_g_wheel /etc/sudoers.d/ 2>>log.txt
sudo rm /etc/sudoers.d/10-installer 2>>log.txt

sudo cp /home/${USER}/myconfig/files/pacman.conf /etc/pacman.conf 2>>log.txt
sudo cp /home/${USER}/myconfig/files/packarch-mirrorlist /etc/pacman.d/packarch-mirrorlist 2>>log.txt
sudo pacman -Syyu
sudo pacman -S - < base_pkgs.txt --noconfirm 2>>log.txt

########## Only for full install ###########################
if [[ $vm_setting == 1 ]]; then
  echo "${green}Enter password to decrypt personal archive:${reset}"
  read -p "Password: " password
  echo "${green}Install full desktop and applications${reset}"
  sudo pacman -S - < extra_pkgs.txt --noconfirm 2>>log.txt
  rustup toolchain install stable 2>>log.txt
  ## Add syno nfs share to autofs
  sudo mkdir /mnt/Partage /mnt/Photos
  
  sudo tee -a /etc/fstab << EOL
  
## Synology DS918
192.168.1.96:/volume1/Partage /mnt/Partage nfs _netdev,noauto,x-systemd.automount,x-systemd.mount-timeout=10,timeo=14,x-systemd.idle-timeout=1min 0 0
192.168.1.96:/volume1/Photos  /mnt/Photos  nfs _netdev,noauto,x-systemd.automount,x-systemd.mount-timeout=10,timeo=14,x-systemd.idle-timeout=1min 0 0
EOL

  sudo modprobe vboxdrv 2>>log.txt
  cryptyrust_cli -d /home/${USER}/myconfig/files/myEncryptedFile -p ${password} -o tmp.tar.gz
  tar -xf /home/${USER}/myconfig/tmp.tar.gz -C /home/${USER}/
  eval `ssh-agent -s`
  /home/${USER}/./gitconfig.sh
fi
####################################################

sudo cp -r /home/${USER}/myconfig/files/userconfig/.config /home/${USER}/ 2>>log.txt
sudo cp -r /home/${USER}/myconfig/files/userconfig/.config /root/ 2>>log.txt
sudo cp -r /home/${USER}/myconfig/files/packarch-icon.png /home/${USER}/.face 2>>log.txt
sudo cp -r /home/${USER}/myconfig/files/environment /etc/environment 2>>log.txt
sudo cp -r /home/${USER}/myconfig/files/userconfig/.profile /home/${USER}/.profile 2>>log.txt
sudo cp -r /home/${USER}/myconfig/files/packarch-icon.png /usr/share/pixmaps/packarch.png 2>>log.txt
sudo cp -r /home/${USER}/myconfig/files/backgrounds/packarch /usr/share/backgrounds/packarch 2>>log.txt
sudo cp -r /home/${USER}/myconfig/files/userconfig/.bash_logout /home/${USER}/.bash_logout 2>>log.txt
sudo cp -r /home/${USER}/myconfig/files/userconfig/.bash_profile /home/${USER}/.bash_profile 2>>log.txt
sudo cp -r /home/${USER}/myconfig/files/userconfig/.bashrc /home/${USER}/.bashrc 2>>log.txt
sudo cp -r /home/${USER}/myconfig/files/userconfig/.zshrc /home/${USER}/.zshrc 2>>log.txt
sudo cp -r /home/${USER}/myconfig/files/userconfig/.p10k.zsh /home/${USER}/.p10k.zsh 2>>log.txt

sudo sed -i -e 's|background=/usr/share/endeavouros/backgrounds/endeavouros-wallpaper.png|background=/usr/share/backgrounds/packarch/default.jpg|g' /etc/lightdm/slick-greeter.conf 2>>log.txt
sudo sed -i -e 's|color_scheme=nordic.conf|color_scheme=dark-colors.conf|g' /root/.config/geany/geany.conf 2>>log.txt
sudo sed -i -e 's|Exec=geany %F|Exec=geany -i %F|g' /usr/share/applications/geany.desktop 2>>log.txt
sudo chown -R ${USER}:${USER} /home/${USER} 2>>log.txt

xfce4-set-wallpaper /usr/share/backgrounds/packarch/default.jpg 2>>log.txt
sudo systemctl enable lightdm.service 2>>log.txt
xfconf-query --channel xsettings --property /Gtk/CursorThemeSize --set 24

## Set zsh shell for user
chsh -s /bin/zsh

## Hide Unnecessary Apps
adir="/usr/share/applications"
apps=(avahi-discover.desktop bssh.desktop bvnc.desktop xfce4-about.desktop \
	org.pulseaudio.pavucontrol.desktop java-java-openjdk.desktop xfce4-mail-reader.desktop \
	hdajackretask.desktop hdspconf.desktop hdspmixer.desktop jconsole-java-openjdk.desktop jshell-java-openjdk.desktop \
	libfm-pref-apps.desktop eos-quickstart.desktop lstopo.desktop \
	uxterm.desktop nm-connection-editor.desktop xterm.desktop \
	qvidcap.desktop stoken-gui.desktop stoken-gui-small.desktop assistant.desktop \
	qv4l2.desktop qdbusviewer.desktop mpv.desktop)

for app in "${apps[@]}"; do
	if [[ -e "$adir/$app" ]]; then
		sudo sed -i '$s/$/\nNoDisplay=true/' "$adir/$app" 2>>log.txt
	fi
done
