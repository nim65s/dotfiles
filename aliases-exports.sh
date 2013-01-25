# Options par défaut
alias ls='ls --file-type --color=auto --time-style=+"%d.%m.%Y-%H:%M"'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias df='dfc -Tdsq name || df'
alias mv='mv -v'
alias cp='cp -r'
alias tree='tree -aC'
alias tmux='tmux -2 -u'
alias vi='vim'
alias vd='vimdiff'
alias rm='rm -Iv'
alias mysql='mysql --auto-rehash -u root -p'
alias mplayer='mplayer -fs'
alias matlab='matlab -nodisplay -nojvm'
alias treel='tree -aphugDC'

# Fautes de frappes courantes
alias dc='cd'
alias CD='cd'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias sl='ls --file-type --color=auto --time-style=+"%d.%m.%Y-%H:%M"'
alias mr='rm -Iv'
alias vmi='vim'

# Quand on code trop ...
alias :q='exit'
alias :x='exit'
alias :e='vim'

# Quelques sudos
alias kdm='sudo kdm'
alias halt='sudo halt'
alias reboot='sudo reboot'
alias poweroff='sudo poweroff'
alias rc.d='sudo rc.d'
alias updatedb='sudo updatedb'
alias wifi-menu='sudo wifi-menu'
alias netcfg='sudo netcfg'

# Lancer des programmes dans des Tmux
alias mcabber='ssh totoro'
alias ncmpcpp='tmux has-session -t mpc && tmux attach -t mpc || tmux new -s mpc -n client ". ~/.password; ncmpcpp"'
alias teardrop='tmux has-session -t TearDrop && tmux attach -t TearDrop || tmux new -s TearDrop'
alias rtorrent='tmux has-session -t rtorrent && tmux attach -t rtorrent || tmux new -s rtorrent -n client "cd ~/Downdloads/; rtorrent"'
alias nmux='tmux new -s'
alias amux='tmux a'

# Raccourcis
alias y='yaourt'
alias ll='ls -lArth --file-type'
alias psef='ps -ef | grep -v grep | grep'
alias psj='ps j | grep -v grep | grep'
alias cn='fortune chucknorris'
alias za='zathura'
alias m='mplayer -fs'
alias bépo='setxkbmap fr'
alias azer='setxkbmap fr bepo'
alias qwer='setxkbmap fr bepo'
alias ipynb='ipython2 notebook --profile=sci'
alias gc='git commit -m'

# Scripts perso http://github.com/nim65s/scripts
alias a='$HOME/scripts/audio.sh'
alias demonte='$HOME/scripts/demonter.sh'
alias ext='$HOME/scripts/extracteur.sh'
alias generateTexMakefile='$HOME/scripts/generateTexMakefile.sh'
alias meurs='$HOME/scripts/meurs.sh'
alias monte='$HOME/scripts/monter.sh'
alias newCproject='$HOME/scripts/newCproject.sh'

alias hist='cat $HOME/.bash_history | cut -f 1 -d" " | sed "s/[[:space:]]//g;/^$/d" | sort | uniq'
alias virerdossiersvides='find . -name .directory -print0 | xargs -0 /bin/rm -fv ; find . -name Thumbs.db -print0 | xargs -0 /bin/rm -fv ; find . -type d -empty -print0 | xargs -0 /bin/rmdir -pv --ignore-fail-on-non-empty'
alias ka='vim $XDG_CONFIG_HOME/awesome/rc.lua; awesome -k'
alias scan='scanimage --resolution 300 > image.pnm; gimp image.pnm; rm image.pnm'
alias fixchromium='rm $HOME/.config/chromium/SingletonLock'
alias fixpa='ssh mi "/etc/init.d/pulseaudio stop;/etc/init.d/pulseaudio start"'
alias fixx='killall mplayer'
alias x='startx 1>> ~/.X.log 2>> ~/.X.err;exit'
alias dodo='mpc crop; sleep 300; xset dpms force standby; $HOME/scripts/audio.sh um; $HOME/scripts/audio.sh m'
alias clean="find . -name '*.orig' -print0 | xargs -0 /bin/rm -fv"
alias td='vim ~/todo'
alias tdd='[[ $(hostname) == "ashitaka" ]] && vimdiff ~/todo scp://n7/todo || vimdiff ~/todo scp://ashitaka/todo'
alias dvd='sudo mount /dev/sr0 /mnt/dvd && cvlc -f dvd:///mnt/dvd/ && sudo umount /dev/sr0 && eject'
alias guignols='f=$(ls -r --file-type --sort=time ~/Guignols/guignol_*|head -n 1|cut -d" " -f9); [[ -f $f ]] && mplayer -fs $f && rm $f || echo "Pas de nouveaux épisodes"'

alias virus_detect='sudo clamscan -r > /donnees/nim/scan.log 2> /donnees/nim/scan.err; echo "EOS" >> /donnees/nim/scan.log'
alias virus_show='sed "/OK$/d;/^$/d;/Empty file$/d;/Symbolic link$/d" /donnees/nim/scan.log'

alias usb='sudo dhcpcd usb0'
alias eth='sudo dhcpcd eth0'

if [[ -d "/usr/share/vim/vim73" ]]
then export VIMRUNTIME=/usr/share/vim/vim73/
else export VIMRUNTIME=/usr/share/vim/vim72/
fi

export EDITOR=vim
export BROWSER=chromium
export XDG_DATA_HOME=~/.local/
export XDG_CONFIG_HOME=~/.config
export XDG_CONFIG_DIRS=/etc/xdg
export HISTSIZE=100000
export HISTFILESIZE=${HISTSIZE}
export JAVA_HOME=/opt/java
export PAGER=~/scripts/vimpager/vimpager
alias less=$PAGER
alias zless=$PAGER

lsd() {
    cd $* && ls
}

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

nam() {
    echo -e "\033]0;$1\007\c"
    man $1
    echo -e "\033]0;${HOSTNAME}\007\c"
}

cmd_clients() {
    ssh mi "./cmd_clients.sh $@"
}

wol() {
    for host in $@
    do
        wakeonlan -f ~/dotfiles/wol/$host
    done
}

syn() {
    synergys
    if [[ $# -eq 0 ]]
    then
        ssh ashitaka "DISPLAY=:0 synergyc nausicaa"
    else
        ssh $1 "DISPLAY=:0 synergyc nausicaa"
    fi
}

LS_COLORS='rs=0:di=01;33:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

export MYSQL_PS1="(\u@\h) [\d]> "

[[ -x ~/dotfiles/aliases-exports.$(hostname).sh ]] && . ~/dotfiles/aliases-exports.$(hostname).sh
[[ -x ~/aliases-exports.local.sh ]] && . ~//aliases-exports.local.sh
