#!/bin/sh
# ~/.xinitrc
urxvtd -q -f -o
setxkbmap fr
numlockx on
xbindkeys
. /etc/X11/xinit/xinitrc.d/*
export WM=awesome
exec awesome
