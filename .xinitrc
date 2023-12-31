#!/bin/sh

xset r rate 300 50 &
xrandr -s 2560x1440 -r 360 &
xrandr --dpi 96 &
xrdb ~/.Xresources &
dunst &
unclutter &

exec i3 > /dev/null 2>&1
