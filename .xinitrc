#!/bin/sh

xset r rate 300 50 &
xrandr --dpi 96 &
lxpolkit &
dunst &
unclutter &
xsetroot -solid "#111111" &
xrdb ~/.Xresources

exec i3 > /dev/null 2>&1
