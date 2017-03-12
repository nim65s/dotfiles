#!/bin/bash
# Options par défaut
alias ls='ls --file-type --color=auto --ignore=\*.pyc --ignore=__pycache__ --time-style=+"%d.%m.%Y-%H:%M"'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias mv='mv -v'
alias cp='cp -r'
alias tree='tree -aC'
alias tmux='tmux -2 -u'
alias vi='vim'
alias vd='vimdiff'
alias rm='rm -Iv'
alias mplayer='mplayer -fs'
alias treel='tree -aphugDC'

# Fautes de frappes courantes
alias dc='cd'
alias CD='cd'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias sl='ls --file-type --color=auto --time-style=+"%d.%m.%Y-%H:%M"'
alias lss='ls --file-type --color=auto --time-style=+"%d.%m.%Y-%H:%M"'
alias mr='rm -Iv'
alias vmi='vim'
alias vvim='vim'

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
alias dhclient='sudo dhclient'
alias vpn='sudo systemctl start openvpn@jiro.service'
alias journalctl='sudo journalctl'
alias netctl='sudo netctl'
alias netctl-auto='sudo netctl-auto'
alias dhcpcd='sudo dhcpcd'

# Lancer des programmes dans des Tmux
alias nmux='tmux new -s'
alias amux='tmux a'

# Raccourcis
alias y='yaourt'
alias ll='ls -lArth --file-type'
alias lll='ls -lArth --file-type'
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
alias gsub='git commit -am submodules; git push'
alias gcan='git commit -a --amend --no-edit'
alias ipa='ip a'
alias ipr='ip r'
alias wi='sudo wifi-menu'

# Scripts perso http://github.com/nim65s/scripts
alias demonte='~/scripts/demonter.sh'
alias generateTexMakefile='~/scripts/generateTexMakefile.sh'
alias monte='~/scripts/monter.sh'
alias gitup='~/scripts/gitup.sh'
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

alias virus_detect='sudo clamscan -r > /donnees/nim/scan.log 2> /donnees/nim/scan.err; echo "EOS" >> /donnees/nim/scan.log'

alias usb='sudo dhcpcd usb0'
alias eth='sudo dhcpcd eth0'

# quand y’en a marre
alias fu='ponysay -q'

# B00
alias boo='xrandr --output HDMI1 --mode 1920x1080i -r 50 --above eDP1'

# Bogofilter
alias bogup='rm -rf ~/.bogofilter; bogofilter -s -B ~/.mails/gandi/Junk.Spam;  bogofilter -n -B ~/.mails/gandi/Junk.Ham'
