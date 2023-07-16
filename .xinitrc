#!/bin/sh

xset r rate 300 50 &
dunst &
unclutter &

exec i3 > /dev/null 2>&1
