#!/bin/sh

xset r rate 300 50 &
xrandr --output DP-0 --mode 1920x1080 --refresh 240 &
dunst &
unclutter &

exec i3 > /dev/null 2>&1
