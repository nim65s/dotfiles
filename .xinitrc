#!/bin/sh
# ~/.xinitrc
urxvtd -q -f -o
setxkbmap fr
numlockx on
xbindkeys
. /etc/X11/xinit/xinitrc.d/*
case $1 in
        xmonad)
                exec xmonad
                # SOME OTHER STUFF TODO
                ;;
        *)
                export WM=awesome
                exec awesome 2> .X.err
                ;;
esac
