#!/bin/sh

xset r rate 300 50 &
xrandr --dpi 96 &
lxpolkit &
dunst &
xsetroot -solid "#111111" &
sbar &
xss-lock slock &
xrdb ~/.Xresources

exec dwm > /dev/null 2>&1
