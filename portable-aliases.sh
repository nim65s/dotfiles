#!/bin/bash
# Options par défaut
alias ls='ls -F --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias mv='mv -v'
alias cp='cp -r'
alias tree='tree -aC -I .git'
alias tmux='tmux -2 -u'
alias v='vim'
alias vi='vim'
alias vc='vimcat'
alias vd='vimdiff'
alias rm='rm -Iv'
alias treel='tree -aphugDC -I .git'
alias watch='watch --color -d'
alias mpv='mpv --no-border'
alias pdfpc='pdfpc --persist-cache'

# Fautes de frappes courantes
alias dc='cd'
alias CD='cd'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias sl='ls -F --color=auto'
alias lss='ls -F --color=auto'
alias mr='rm -Iv'
alias vmi='vim'
alias vvim='vim'

# Quand on code trop ...
alias :q='exit'
alias :x='exit'
alias :e='vim'

# copier/coller trop rapides
alias +='echo'

# Quelques sudos
alias kdm='sudo kdm'
alias halt='sudo halt'
alias reboot='sudo reboot'
alias poweroff='sudo poweroff'
alias rc.d='sudo rc.d'
alias updatedb='sudo updatedb'
alias wifi-menu='sudo wifi-menu'
alias netcfg='sudo netcfg'
alias dhclient='sudo dhclient'
#alias journalctl='sudo journalctl'
alias netctl='sudo netctl'
alias netctl-auto='sudo netctl-auto'
alias dhcpcd='sudo dhcpcd'
#alias systemctl='sudo systemctl'
alias salt='sudo salt'
alias salt-key='sudo salt-key'
alias netdiscover='sudo netdiscover'

# Lancer des programmes dans des Tmux
alias nmux='tmux new -s'
alias amux='tmux a'

# Raccourcis
alias y='yay'
alias ll='ls -lArthF'
alias lll='ls -lArthF'
alias psef='ps -ef | grep -v grep | grep'
alias psj='ps j | grep -v grep | grep'
alias cn='fortune chucknorris'
alias za='zathura'
alias m='mplayer -fs'
alias bépo='setxkbmap fr'
alias azer='setxkbmap fr bepo'
alias qwer='setxkbmap fr bepo'
alias gc='git commit -am'
alias gd='git difftool'
alias gst='git status'
alias gp='git push'
alias gf='git fetch --all --prune'
alias gsub='git commit -am submodules; git push'
alias gcan='git commit -a --amend --no-edit'
alias gcr='git clone --recursive'
alias ipa='ip a'
alias ipr='ip r'
alias wi='sudo wifi-menu'

# Scripts perso http://github.com/nim65s/scripts
alias demonte='~/scripts/demonter.sh'
alias generateTexMakefile='~/scripts/generateTexMakefile.sh'
alias monte='~/scripts/monter.sh'
alias gitup='~/scripts/gitup.py'
alias optimg='~/scripts/optimg.sh'
alias max_brightness='sudo ~/scripts/max_brightness.sh'

alias virerdossiersvides='find . -name .directory -print0 | xargs -0 /bin/rm -fv ; find . -name Thumbs.db -print0 | xargs -0 /bin/rm -fv ; find . -type d -empty -print0 | xargs -0 /bin/rmdir -pv --ignore-fail-on-non-empty'
alias scan='scanimage --resolution 300 > image.pnm; gimp image.pnm; rm image.pnm'
alias fixpa='ssh mi "/etc/init.d/pulseaudio stop;/etc/init.d/pulseaudio start"'
alias dodo='mpc crop; sleep 300; xset dpms force standby; ~/scripts/audio.sh um; ~/scripts/audio.sh m'
alias clean="find -regextype posix-extended -regex '.*\.(orig|aux|nav|out|snm|toc|tmp|tns|pyg|vrb|fls|fdb_latexmk|blg|bbl)' -delete"
alias td='todo'
alias vdir='vdirsyncer sync'
alias proxynet7='ssh -D 6565 -p 443 n7'
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

alias virus_detect='sudo clamscan -r > /donnees/nim/scan.log 2> /donnees/nim/scan.err; echo "EOS" >> /donnees/nim/scan.log'

alias usb='sudo dhcpcd usb0'
alias eth='sudo dhcpcd eth0'

# quand y’en a marre
alias fu='ponysay -q'

# B00
alias boo='xrandr --output HDMI1 --mode 1920x1080i -r 50 --above eDP1'

# Bogofilter
alias bogup='rm -rf ~/.bogofilter; bogofilter -s -B ~/.mails/gandi/Junk.Spam;  bogofilter -n -B ~/.mails/gandi/Junk.Ham'

# reflector
alias refl="sudo reflector --verbose --latest 100 --sort rate --save /etc/pacman.d/mirrorlist -c France -c \
    'United Kingdom' -c Netherlands -c Germany -c Sweden -c Switzerland -c Spain -c Italy -c Ireland"

# catkin needs python2
alias catkin_make="catkin_make -DPYTHON_EXECUTABLE=/usr/bin/python2 -DPYTHON_INCLUDE_DIR=/usr/include/python2.7 -DPYTHON_LIBRARY=/usr/lib/libpython2.7.so"

alias im='mosh -- mononoke tmux a -d -t im'
alias civ='env LD_PRELOAD=/usr/lib32/libopenal.so.1 steam steam://rungameid/8930'

#CMake
alias bn='cmake -B build -G Ninja'
alias bb='cmake --build build'
alias bnb='bn && bb'
