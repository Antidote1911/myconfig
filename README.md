# myconfig

Personal script for install Xfce and my configs on EndeavourOS.

git clone https://github.com/Antidote1911/myconfig
cd myconfig
sudo ./install.sh
sudo systemctl enable lightdm.service
sudo cp -r /config/backgrounds/packarch /usr/share/backgrounds/
sudo cp -r /config/packarch-icon.png /usr/share/pixmaps/packarch-icon.png
tar -xf /packarch_installer/config/config_xfce.tar.xz -C /home/$username/
