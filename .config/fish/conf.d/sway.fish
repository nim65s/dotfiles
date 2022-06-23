[ (tty) = "/dev/tty1" -a -x "/usr/bin/sway" ] && exec sway > .sway.log 2> .sway.err
#[ (tty) = "/dev/tty1" -a -x "/usr/bin/startxfce4" ] && exec startxfce4 > .startxfce4.log 2> .startxfce4.err
