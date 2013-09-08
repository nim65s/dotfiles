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
    if [ (acpi -a 2> /dev/null | grep off) ]
        echo -n '─['
        set_color -o red
        echo -n (acpi -b|cut -d' ' -f 4-)
        set_color -o green
        echo -n ']'
    end
    set_color normal
    echo -n (__fish_git_prompt)
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

# Lancer des programmes dans des Tmux
function ncmpcpp
    tmux has-session -t mpc
    and tmux attach -t mpc
    or tmux new -s mpc -n client ". ~/.password; ncmpcpp" $argv
end

function teardrop
    tmux has-session -t TearDrop
    and tmux attach -t TearDrop
    or tmux new -s TearDrop $argv
end

function fairytail
    tail -n 100 -F $argv | ccze -A
end

function fs
    printf '\33]50;%s%d%s\007' "xft:DejaVuSansMono-Oblique:pixelsize=" $1 ",xft:Code2000:antialias=false"
end

function wol
    for host in $argv
        wakeonlan -f ~/dotfiles/wol/$host
    end
end

function df
    dfc -Tdsq name
    or df
end

function dvd
    sudo mount /dev/sr0 /mnt/dvd
    and cvlc -f dvd:///mnt/dvd/
    and sudo umount /dev/sr0
    and eject
end


function guignols
    set f (ls -r --file-type --sort=time ~/Guignols/guignol_*|head -n 1|cut -d" " -f9)
    if test -f "$f"
        echo $f
        mplayer -fs $f
        rm $f
    else
        echo "Pas de nouveaux épisodes"
    end
end

function teardrop
    tmux has-session -t TearDrop
    and tmux attach -t TearDrop
    or tmux new -s TearDrop
end

function virus_show
    sed '/OK$/d;/^$/d;/Empty file$/d;/Symbolic link$/d" /donnees/nim/scan.log'
end

function bd
    cd (python $HOME/scripts/bd.py $argv)
end

. ~/dotfiles/portable-aliases.sh

# exports

if test -d "/usr/share/vim/vim74"
    set -x VIMRUNTIME /usr/share/vim/vim74
else if test -d "/usr/share/vim/vim73"
    set -x VIMRUNTIME /usr/share/vim/vim73
else
    set -x VIMRUNTIME /usr/share/vim/vim72
end

set -x EDITOR vim
set -x BROWSER chromium
set -x JAVA_HOME /opt/java
set -x PAGER ~/scripts/vimpager/vimpager

set -x LS_COLORS 'rs=0:di=01;33:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'

set -x MYSQL_PS1 "(\u@\h) [\d]> "

set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch green


# vim: set filetype=fish:
