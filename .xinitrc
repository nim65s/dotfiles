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
wmname LG3D

. /etc/profile

[[ -f ~/.Xresources ]] && xrdb ~/.Xresources &
[[ -f ~/dotfiles/.xinitrc.local.$(hostname) ]] && . ~/dotfiles/.xinitrc.local.$(hostname)
[[ -f ~/.password ]] && . ~/.password

xsetroot -cursor_name left_ptr

export TERMINAL=terminology

grep -q saurel /etc/resolv.conf && synergyc ashitaka

case $1 in
    kde) exec startkde ;;
    e17) exec enlightenment_start ;;
    gnome) exec ck-launch-session gnome-session ;;
    awesome)
        export WM=awesome
        exec ssh-agent awesome > .X.log 2> .X.err
        ;;
    *)
        if [[ $HOSTNAME == "ashitaka" ]]
        then
            nitrogen --head=1 --set-zoom-fill images/hostname/$HOSTNAME.jpg
        else
            nitrogen --set-zoom-fill images/hostname/$HOSTNAME.jpg
        fi
        trayer --edge noe --align center --SetDockType true --SetPartialStrut true --expand true --width 4 --transparent true --tint 0x191970 --height 15 &
        xcompmgr &
        exec ssh-agent xmonad > .X.log 2> .X.err ;;
esac
