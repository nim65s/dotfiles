#!/bin/sh
# ~/.xinitrc

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xsetroot -cursor_name left_ptr
setxkbmap fr bepo
hostname | grep -qi ashitaka || numlockx on
wmname LG3D

. /etc/profile

[[ -f ~/.Xresources ]] && xrdb ~/.Xresources &
[[ -f ~/dotfiles/.xinitrc.local.$(hostname) ]] && . ~/dotfiles/.xinitrc.local.$(hostname)
[[ -f ~/.password ]] && . ~/.password

xsetroot -cursor_name left_ptr

export TERMINAL=terminator
export SSH_ASKPASS=/usr/lib/ssh/x11-ssh-askpass

case $1 in
    kde) exec startkde ;;
    e17) exec enlightenment_start ;;
    gnome) exec ck-launch-session gnome-session ;;
    awesome)
        export WM=awesome
        exec ssh-agent awesome > .X.log 2> .X.err
        ;;
    xmonad)
        if [[ $HOSTNAME == "ashitaka" ]]
        then
            nitrogen --head=1 --set-zoom-fill images/hostname/$HOSTNAME.jpg
        else
            nitrogen --set-zoom-fill images/hostname/$HOSTNAME.jpg
        fi
        trayer --edge noe --align center --SetDockType true --SetPartialStrut true --expand true --width 4 --transparent true --tint 0x191970 --height 15 &
        xcompmgr &
        exec ssh-agent xmonad > .X.log 2> .X.err ;;
    *)
        #nitrogen --restore
        nitrogen --set-zoom-fill images/hostname/$HOSTNAME.jpg
        exec i3 -V > ~/.i3/log 2> ~/.i3/err;;
esac
