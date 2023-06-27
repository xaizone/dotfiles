#!/bin/sh

xset m 0 0 &
xrandr --output DP-0 --mode 1920x1080 --refresh 240 &

exec i3 > /dev/null 2>&1
