#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

## Environtment
export PATH="${PATH}:$HOME/.config/bspwm/bin"

## Get colors from .Xresources -------------------------------#
xrdb ~/.Xresources
getcolors () {
	FOREGROUND=$(xrdb -query | grep 'foreground:'| awk '{print $NF}')
	BACKGROUND=$(xrdb -query | grep 'background:'| awk '{print $NF}')
	BLACK=$(xrdb -query | grep 'color0:'| awk '{print $NF}')
	RED=$(xrdb -query | grep 'color1:'| awk '{print $NF}')
	GREEN=$(xrdb -query | grep 'color2:'| awk '{print $NF}')
	YELLOW=$(xrdb -query | grep 'color3:'| awk '{print $NF}')
	BLUE=$(xrdb -query | grep 'color4:'| awk '{print $NF}')
	MAGENTA=$(xrdb -query | grep 'color5:'| awk '{print $NF}')
	CYAN=$(xrdb -query | grep 'color6:'| awk '{print $NF}')
	WHITE=$(xrdb -query | grep 'color7:'| awk '{print $NF}')
}
getcolors

bspc config focused_border_color "$FOREGROUND" 
bspc config normal_border_color "$BACKGROUND"
bspc config active_border_color "$MAGENTA"
bspc config presel_feedback_color "$GREEN"

#change your keyboard if you need it
#setxkbmap -layout be
# conky -c $HOME/.config/bspwm/system-overview &
# run nm-applet &
# numlockx on &
# run volumeicon &

xsetroot -cursor_name left_ptr &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
run sxhkd &
nitrogen --restore &
run xfsettingsd &
run xfce4-power-manager &
run pamac-tray &
run spotify-listener &

# Lauch notification daemon
dunst \
-geom "250x50-10+34" -frame_width "1" -font "Noto Sans 10" \
-lb "$BACKGROUND" -lf "$FOREGROUND" -lfr "$BLUE" \
-nb "$BACKGROUND" -nf "$FOREGROUND" -nfr "$BLUE" \
-cb "$BACKGROUND" -cf "$RED" -cfr "$RED" &

bspcolors
bspcomp
sh ~/.config/polybar/launch_for_bspwm.sh

