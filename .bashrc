[ -z "$PS1" ] && return

export KDEWM=awesome
export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth

export EDITOR=vim
export XDG_DATA_HOME=~/.uzbl/data/
export XDG_CONFIG_HOME=~/.config
export XDG_CONFIG_DIRS=/etc/xdg
export HISTSIZE=100000
export HISTFILESIZE=${HISTSIZE}
export JAVA_HOME=/opt/java

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
export VIMRUNTIME=/usr/share/vim/vim73/

nc="\[\033[m\]"
noir="\[\033[0;30m\]"
rouge="\[\033[0;31m\]"
vert="\[\033[0;32m\]"
jaune="\[\033[0;33m\]"
bleu="\[\033[0;34m\]"
magenta="\[\033[0;35m\]"
cyan="\[\033[0;36m\]"
blanc="\[\033[0;37m\]"
NOIR="\[\033[1;30m\]"
ROUGE="\[\033[1;31m\]"
VERT="\[\033[1;32m\]"
JAUNE="\[\033[1;33m\]"
BLEU="\[\033[1;34m\]"
MAGENTA="\[\033[1;35m\]"
CYAN="\[\033[1;36m\]"
BLANC="\[\033[1;37m\]"

function ps1
{
RETC="$([[ $? == 0 ]] && echo $vert || echo $rouge)"
USERC="$([[ $UID == 0 ]] && echo $ROUGE || echo $JAUNE)"

PS1="${RETC}┌─${VERT}[${USERC}\u${BLANC}@${CYAN}\h${BLANC}:\w${VERT}]-[${RETC}\t${VERT}]
${RETC}└─>${ROUGE}\$ ${nc}"
}

PROMPT_COMMAND=ps1
PS2='\[\033[1;32m\]└──>\[\033[m\] '
PS3='└─?> '

alias ls='ls --color=auto --time-style=+"%d.%m.%Y %H:%M"'
alias sl='ls --color=auto --time-style=+"%d.%m.%Y %H:%M"'
alias vmi='vim'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias df='df -Th'
alias mv='mv -v'
alias cp='cp -r'
alias dc='cd'
alias tree='tree -aC'
alias treel='tree -aphugDC'
alias cd..='cd ..'
alias mr='rm'

alias :q='exit'
alias :x='exit'
alias :e='vim'

alias kdm='sudo kdm'
alias halt='sudo halt'
alias reboot='sudo reboot'
alias rc.d='sudo rc.d'

alias y='yaourt'
alias ll='ls -lArth'
alias le='ls -X'
alias lle='ls -lArXh'
alias la='ls -A'
alias lla='ls -lArAh'
alias lq='ls -S'
alias llq='ls -lArSh'
alias psef='ps -ef | grep -v grep | grep'
alias psj='ps j | grep -v grep | grep'
alias cn='fortune chucknorris'

alias meurs='$HOME/scripts/meurs.sh'
alias ext='$HOME/scripts/extracteur.sh'
alias dl='$HOME/scripts/dl.sh'
alias adl='$HOME/scripts/autodl.sh'
alias dlbot='$HOME/scripts/dlbot.sh'
alias generateTexMakefile='$HOME/scripts/generateTexMakefile.sh'
alias newCproject='$HOME/scripts/newCproject.sh'
alias majgit='ssh-add; $HOME/scripts/majgit.sh'

alias hist='cat $HOME/.bash_history | cut -f 1 -d" " | sed "s/[[:space:]]//g;/^$/d" | sort | uniq'
alias fer='OLDIFS=$IFS ; IFS=$'\n' && for DOS in * ; do feh -FrSname $DOS ; done ; IFS=$OLDIFS'
alias virerdossiersvides='find . -name .directory -print0 | xargs -0 /bin/rm -fv ; find . -name Thumbs.db -print0 | xargs -0 /bin/rm -fv ; find . -type d -empty -print0 | xargs -0 /bin/rmdir -pv --ignore-fail-on-non-empty'
alias ka='vim $XDG_CONFIG_HOME/awesome/rc.lua; awesome -k'
alias scan='scanimage --resolution 300 > image.pnm; gimp image.pnm; rm image.pnm'

alias fixchromium='rm $HOME/.config/chromium/SingletonLock'
alias x='startx 1>> ~/.X.log 2>> ~/.X.err'
alias dodo='mpc crop; sleep 300; xset dpms force standby; $HOME/scripts/audio.sh um; $HOME/scripts/audio.sh m'
alias testc='a="a" ; while [[ a != "q" ]] ; do read -n 1 a; [[ a == "c" ]] && make clean ; make && ../bin/* ; done'

alias gobby_tunnel='ssh -L 6522:localhost:6522 n7 ssh -L 6522:localhost:6522 discover & gobby'

export XDG_CONFIG_HOME="$HOME/.config"

shopt -s cdspell
shopt -s checkwinsize
shopt -s dirspell
shopt -s histappend
shopt -s histreedit
shopt -s hostcomplete
shopt -s lithist

if [[ -x /usr/bin/fortune ]]
	then
		/usr/bin/fortune
	fi
users
function _exit()
{
	echo -e "\033[0;31mHasta la vista, baby\033[0m"
}
trap _exit EXIT

lsd()
{
	cd $* && ls
}
fairytail()
{
	tail -n 100 -f $* | ccze -A
}
