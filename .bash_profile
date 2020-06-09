#
# ~/.bash_profile
#
if [[ -z $DISPLAY ]]
then
    case $(tty) in
        /dev/tty2)
            xinit awesome
            ;;
        /dev/tty3)
            sleep 5
            xinit xfce -- :1 -layout twinview
            ;;
        /dev/tty4)
            sleep 10
            xinit gnome -- :2 -layout twinview
            ;;
        /dev/tty5)
            sleep 15
            xinit kde -- :3 -layout twinview
            ;;
    esac
fi
[[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH="$HOME/.cargo/bin:$PATH"
