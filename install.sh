#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}Install Xfce packages${reset}"
sudo pacman -S - < xfce_pkgs.txt --noconfirm
