#!/bin/sh
# ~/.xinitrc
urxvtd -q -f -o
setxkbmap fr oss && setxkbmap fr
xbindkeys
numlockx on
#. /etc/X11/xinit/xinitrc.d/*
#xscreensaver -nosplash &
xrdb ~/.Xresources &
. .password
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
                exec ssh-agent awesome > .X.log 2> .X.err
                ;;
esac
