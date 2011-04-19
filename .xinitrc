#!/bin/sh
# ~/.xinitrc
urxvtd -q -f -o
setxkbmap fr
numlockx on
xbindkeys
#. /etc/X11/xinit/xinitrc.d/*
xscreensaver -nosplash &
case $1 in
        xmonad)
                exec xmonad
                # SOME OTHER STUFF TODO
                ;;
       	gnome)
                exec ck-launch-session gnome-session
                ;;
        *)
                export WM=awesome
                exec awesome > .X.log 2> .X.err
                ;;
esac
