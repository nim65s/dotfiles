#!/bin/sh
# ~/.xinitrc

cd

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

setxkbmap fr bepo
hostname | grep -qi ashitaka || numlockx on
wmname LG3D

. /etc/profile

sleep 2
[[ -f dotfiles/.xinitrc.local.$(hostname) ]] && source ./dotfiles/.xinitrc.local.$(hostname)

case $1 in
    kde) exec startkde ;;
    e17) exec enlightenment_start ;;
    gnome) exec ck-launch-session gnome-session ;;
    awesome)
        export WM=awesome
        exec awesome > .X.log 2> .X.err ;;
    xmonad)
        trayer --edge noe --align center --SetDockType true --SetPartialStrut true --expand true --width 4 --transparent true --tint 0x191970 --height 15 &
        xcompmgr &
        exec xmonad > .X.log 2> .X.err ;;
    *)
        # thanks obama -_- https://github.com/i3/i3/issues/2599
        cat ~/.config/i3/top $([[ -f ~/.config/i3/$(hostname) ]] && echo ~/.config/i3/$(hostname)) ~/.config/i3/bot > ~/.config/i3/config
        exec i3 > ~/.xlog 2> ~/.xerr;;
esac
