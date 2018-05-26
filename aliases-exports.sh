alias df='dfc -Tdsq name || df'
alias dvd='sudo mount /dev/sr0 /mnt/dvd && cvlc -f dvd:///mnt/dvd/ && sudo umount /dev/sr0 && eject'
alias guignols='f=$(ls -r --file-type --sort=time ~/Guignols/guignol_*|head -n 1|cut -d" " -f9); [[ -f $f ]] && mplayer -fs $f && rm $f || echo "Pas de nouveaux épisodes"'
alias teardrop='tmux has-session -t TearDrop && tmux attach -t TearDrop || tmux new -s TearDrop'
alias virus_show='sed "/OK$/d;/^$/d;/Empty file$/d;/Symbolic link$/d" /donnees/nim/scan.log'

#if [[ -d "/usr/share/vim/vim80" ]]
#then export VIMRUNTIME=/usr/share/vim/vim80/
#elif [[ -d "/usr/share/vim/vim74" ]]
#then export VIMRUNTIME=/usr/share/vim/vim74/
#elif [[ -d "/usr/share/vim/vim73" ]]
#then export VIMRUNTIME=/usr/share/vim/vim73/
#else export VIMRUNTIME=/usr/share/vim/vim72/
#fi

export EDITOR=vim
export BROWSER=firefox
export XDG_CONFIG_HOME=~/.config
export XDG_CONFIG_DIRS=/etc/xdg
export PYTHONDOCS=/usr/share/doc/python2/html/
export XDG_DATA_DIR=~/.local
export XDG_CACHE_DIR=~/.cache
export HISTSIZE=100000
export HISTFILESIZE=${HISTSIZE}
export JAVA_HOME=/opt/java
export PAGER=vimpager
alias less=$PAGER
alias zless=$PAGER

fairytail() {
    if [[ -n "$(which $1 2> /dev/null)" ]]
    then
        $1 | tail -n 100 -f | ccze -A
    else
        tail -n 100 -F $* | ccze -A
    fi
}

fs() {
    printf '\33]50;%s%d%s\007' "xft:DejaVuSansMono-Oblique:pixelsize=" $1 ",xft:Code2000:antialias=false"
}

bd() {
    cd $($HOME/scripts/bd.py $1)
}

export LS_COLORS='rs=0:di=01;33:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';

export MYSQL_PS1="(\u@\h) [\d]> "

[[ -x ~/dotfiles/portable-aliases.sh ]] && . ~/dotfiles/portable-aliases.sh
[[ -x ~/dotfiles/aliases-exports.$(hostname -s).sh ]] && . ~/dotfiles/aliases-exports.$(hostname -s).sh
[[ -x ~/aliases-exports.local.sh ]] && . ~//aliases-exports.local.sh

