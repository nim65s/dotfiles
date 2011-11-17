if [[ "$SHLVL" = 1 ]]
then
    [[ -x /usr/bin/clear_console ]] && /usr/bin/clear_console -q
fi

#### TODO
## mcabber auto-away
## TODO : pas besoin de passer par /proc, le screen devrait toujours s'appeller xmpp
#if [[ -p $HOME/.mcabber/mcabber.fifo ]]
#then
#    MCABBER_PID=$(pgrep -u $USER mcabber)
#    if [[ -n $MCABBER_PID ]]
#    then
#        MCABBER_STY=$(cat /proc/$MCABBER_PID/environ | tr '\0' '\n' | grep '^STY=' | cut -d'=' -f2)
#        if [[ -n $MCABBER_STY ]]
#        then
#            if [[ -z "$(screen -list | grep $MCABBER_STY.*\(Attached\))" ]]
#            then
#                echo /status notavail > $HOME/.mcabber/mcabber.fifo
#            fi
#        fi
#    fi
#fi
