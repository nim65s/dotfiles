#!/bin/sh
# ~/.xinitrc
urxvtd -q -f -o
setxkbmap fr bepo
xbindkeys
numlockx on
#. /etc/X11/xinit/xinitrc.d/*
[[ "$(hostname)" != "totoro" ]] && xscreensaver -nosplash &
xrdb ~/.Xresources &
[[ -f ~/.password ]] && . ~/.password
case $1 in
        kde)
            startkde
            ;;
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
