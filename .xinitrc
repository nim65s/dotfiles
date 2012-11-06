#!/bin/sh
# ~/.xinitrc

# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]
then
    for f in /etc/X11/xinit/xinitrc.d/*
    do [ -x "$f" ] && . "$f"
    done
    unset f
fi

urxvtd -q -f -o
setxkbmap fr bepo
xbindkeys
numlockx on
xrdb ~/.Xresources &

. /etc/profile

[[ -f ~/dotfiles/.xinitrc.local.$(hostname) ]] && . ~/dotfiles/.xinitrc.local.$(hostname)
[[ -f ~/.password ]] && . ~/.password
case $1 in
    kde) startkde ;;
    xmonad) exec xmonad ;;
    gnome) exec ck-launch-session gnome-session ;;
    *)
        export WM=awesome
        exec ssh-agent awesome > .X.log 2> .X.err
        ;;
esac
