if status --is-login
    if not set -q LANG >/dev/null
        set -gx LANG fr_FR.UTF-8
    end
    if expr "$LANG" : ".*\.[Uu][Tt][Ff].*" >/dev/null
        if test "$TERM" = linux
            if which unicode_start >/dev/null
                unicode_start
            end
        end
    end
end

function fish_prompt
    and set retc green; or set retc red
    tty|grep -q tty; and set tty tty; or set tty pts
    #set tty tty

    set_color $retc
    if [ $tty = tty ]
        echo -n .-
    else
        echo -n '┬─'
    end
    set_color -o green
    echo -n [
    if [ $USER = root ]
        set_color -o red
    else
        set_color -o yellow
    end
    echo -n $USER
    set_color -o white
    echo -n @
    if [ -z "$SSH_CLIENT" ]
        set_color -o blue
    else
        set_color -o cyan
    end
    echo -n (hostname)
    set_color -o white
    #echo -n :(prompt_pwd)
    echo -n :(pwd|sed "s=$HOME=~=")
    set_color -o green
    echo -n ']'
    set_color normal
    set_color $retc
    if [ $tty = tty ]
        echo -n '-'
    else
        echo -n '─'
    end
    set_color -o green
    echo -n '['
    set_color normal
    set_color $retc
    echo -n (date +%X)
    set_color -o green
    echo -n ]
    #set vcs none
    #if [ -d .git ] # Là, j’ai honte…
        #set vcs git
    #else
        #if [ -d .hg ]
            #set vcs hg
        #else
            #if git symbolic-ref HEAD > /dev/null ^&1
                #set vcs git
            #else
                #if hg root > /dev/null ^&1
                    #set vcs hg
                #end
            #end
        #end
    #end
    #echo -n $vcs
    if [ (acpi -a 2> /dev/null | grep off) ]
        echo -n '─['
        set_color -o red
        echo -n (acpi -b|cut -d' ' -f 4-)
        set_color -o green
        echo -n ']'
    end
    echo
    set_color normal
    for job in (jobs)
        set_color $retc
        if [ $tty = tty ]
            echo -n '; '
        else
            echo -n '│ '
        end
        set_color brown
        echo $job
    end
    set_color normal
    set_color $retc
    if [ $tty = tty ]
        echo -n "'->"
    else
        echo -n '╰─>'
    end
    set_color -o red
    echo -n '$ '
    set_color normal
end

# Options par défaut
function ls
    command ls -F --color=auto --time-style=+"%d.%m.%Y %H:%M" $argv
end;

function grep
    command grep --color=auto $argv
end;

function fgrep
    command fgrep --color=auto $argv
end;

function egrep
    command egrep --color=auto $argv
end;

function df
    dfc -Tdsq name $argv
end;

function mv
    command mv -v $argv
end;

function cp
    command cp -r $argv
end;

function tree
    command tree -aC $argv
end;

function tmux
    command tmux -2 -u $argv
end;

function vi
    vim $argv
end;

function vd
    vimdiff $argv
end;

function rm
    command rm -Iv $argv
end;

function mysql
    command mysql --auto-rehash -u root -p $argv
end;

function mplayer
    command mplayer -fs $argv
end;

function matlab
    command matlab -nodisplay -nojvm $argv
end;

function treel
    tree -aphugDC $argv
end;

# Fautes de frappes courantes
function dc
    cd $argv
end;

function CD
    cd $argv
end;

function cd..
    cd ../
end;

function ..
    cd ../
    ls
end;

function ...
    cd ../../
    ls
end;

function ....
    cd ../../../
    ls
end;

function sl
    ls $argv
end;

function mr
    rm $argv
end;

function vmi
    vim $argv
end;

# Quand on code trop ...
function :q
    exit $argv
end;

function :x
    exit $argv
end;

function :e
    vim $argv
end;

# Quelques sudos
function kdm
    sudo kdm $argv
end;

function halt
    sudo halt $argv
end;

function reboot
    sudo reboot $argv
end;

function poweroff
    sudo poweroff $argv
end;

function rc.d
    sudo rc.d $argv
end;

function updatedb
    sudo updatedb $argv
end;

# Lancer des programmes dans des Tmux
function mcabber
    tmux has-session -t mcabber
    and tmux attach -d -t mcabber
    or tmux new -s mcabber -n client mcabber $argv
end;

function ncmpcpp
    tmux has-session -t mpc
    and tmux attach -t mpc
    or tmux new -s mpc -n client ". ~/.password; ncmpcpp" $argv
end;

function teardrop
    tmux has-session -t TearDrop
    and tmux attach -t TearDrop
    or tmux new -s TearDrop $argv
end;

function rtorrent
    tmux has-session -t rtorrent
    and tmux attach -t rtorrent
    or tmux new -s rtorrent -n client "cd ~/Downdloads/; rtorrent" $argv
end;

# Raccourcis
function nmux
    tmux new -s $argv
end;

function amux
    tmux a $argv
end;

function y
    yaourt $argv
end;

function ll
    ls -lArth $argv
end;

function le
    ls -X $argv
end;

function lle
    ls -lArXh $argv
end;

function la
    ls -A $argv
end;

function lla
    ls -lArAh $argv
end;

function lq
    ls -S $argv
end;

function llq
    ls -lArSh $argv
end;

function psef
    ps -ef | grep -v grep | grep $argv
end;

function psj
    ps j | grep -v grep | grep $argv
end;

function cn
    fortune chucknorris $argv
end;

function za
    zathura $argv
end;

function m
    mplayer -fs $argv
end;

function bépo
    setxkbmap fr $argv
end;

function azer
    setxkbmap fr bepo $argv
end;

function qwer
    setxkbmap fr bepo $argv
end;

# Scripts perso http://github.com/nim65s/scripts
function a
    eval $HOME/scripts/audio.sh $argv
end;

function adl
    eval $HOME/scripts/autodl.sh $argv
end;

function dl
    eval $HOME/scripts/dl.sh $argv
end;

function commit
    eval $HOME/scripts/dvcs.py commit $argv
end;

function demonte
    eval $HOME/scripts/demonter.sh $argv
end;

function dlbot
    eval $HOME/scripts/dlbot.sh $argv
end;

function ext
    eval $HOME/scripts/extracteur.sh $argv
end;

function generateTexMakefile
    eval $HOME/scripts/generateTexMakefile.sh $argv
end;

function meurs
    eval $HOME/scripts/meurs.sh $argv
end;

function monte
    eval $HOME/scripts/monter.sh $argv
end;

function newCproject
    eval $HOME/scripts/newCproject.sh $argv
end;

function pull
    eval $HOME/scripts/dvcs.py pull $argv
end;

function push
    eval $HOME/scripts/dvcs.py push $argv
end;

#function status
    #eval $HOME/scripts/dvcs.py status $argv
#end;

function 9
    while true
        eval $HOME/scripts/9gag.py
        sleep 540
    end
end;

function hist
    cat $HOME/.bash_history | cut -f 1 -d" " | sed 's/[[:space:]]//g;/^$/d' | sort | uniq $argv
end;

function virerdossiersvides
    find . -name .directory -print0 | xargs -0 /bin/rm -fv
    find . -name Thumbs.db -print0 | xargs -0 /bin/rm -fv
    find . -type d -empty -print0 | xargs -0 /bin/rmdir -pv --ignore-fail-on-non-empty $argv
end;

function ka
    vim $XDG_CONFIG_HOME/awesome/rc.lua
    awesome -k $argv
end;

function scan
    scanimage --resolution 300 > image.pnm
    gimp image.pnm
    rm image.pnm $argv
end;

function fixchromium
    rm $HOME/.config/chromium/SingletonLock $argv
end;

function fixpa
    ssh mi "/etc/init.d/pulseaudio stop; /etc/init.d/pulseaudio start" $argv
end;

function fixx
    killall mplayer $argv
end;

function x
    startx 1>> ~/.X.log 2>> ~/.X.err
    exit $argv
end;

function dodo
    mpc crop
    sleep 300
    xset dpms force standby
    eval $HOME/scripts/audio.sh um
    eval $HOME/scripts/audio.sh m $argv
end;

function clean
    find . -name '*.orig' -print0 | xargs -0 /bin/rm -fv $argv
end;

function td
    vim ~/todo $argv
end;

function tdd
    [ (hostname) == "totoro" ]
    and vimdiff ~/todo scp://n7/todo
    or vimdiff ~/todo scp://totoro/todo $argv
end;

function dvd
    sudo mount /dev/sr0 /mnt/dvd
    and cvlc -f dvd:///mnt/dvd/
    and sudo umount /dev/sr0
    and eject $argv
end;

function guignols
    set f (ls -lrth --sort=time ~/guignol_*|head -n 1|cut -d" " -f8)
    mplayer -fs $f
    and rm $f $argv
end;

function virus_detect
    sudo clamscan -r > /donnees/nim/scan.log 2> /donnees/nim/scan.err
    echo "EOS" >> /donnees/nim/scan.log $argv
end;

function lsd
    cd $argv
    ls
end

function fairytail
    tail -n 100 -F $argv | ccze -A
end

function fs
    printf '\33]50;%s%d%s\007' "xft:DejaVuSansMono-Oblique:pixelsize=" $1 ",xft:Code2000:antialias=false"
end

function cmd_clients
    ssh mi "./cmd_clients.sh $argv"
end

function wol
    for host in $argv
        wakeonlan -f ~/dotfiles/wol/$host
    end
end

#
# Init file for fish
#

#
# Some things should only be done for login terminals
#
# vim: set filetype=fish:
