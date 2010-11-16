#!/bin/sh
# ~/.xinitrc
urxvtd -q -f -o
setxkbmap fr
numlockx on
xbindkeys
exec awesome
