#!/bin/sh

xset r rate 300 50 &
xrandr --dpi 96 &
lxpolkit &
dunst &
unclutter &
xsetroot -solid "#111111" &
sbar &
xrdb ~/.Xresources

exec dwm > /dev/null 2>&1
