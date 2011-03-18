[ -z "$PS1" ] && return

export KDEWM=awesome

export EDITOR=vim
export XDG_DATA_HOME=~/.uzbl/data/
export XDG_CONFIG_HOME=~/.config
export XDG_CONFIG_DIRS=/etc/xdg
export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}

export N7=saurelg@ssh.inpt.fr
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

PS1="${RETC}┌─${VERT}[${JAUNE}\u${BLANC}@${CYAN}\h${BLANC}:\w${VERT}]-[${RETC}\t${VERT}]
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

alias kdm='sudo kdm'
alias halt='sudo halt'
alias reboot='sudo reboot'

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

alias fah='sudo $HOME/scripts/fah.sh'

alias wow='wine /media/T/Jeux/World\ of\ Warcraft/Wow.exe -opengl'
alias windirstat='wine $HOME/.wine/drive_c/Program\ Files/WinDirStat/windirstat.exe'

alias hist='cat $HOME/.bash_history | cut -f 1 -d" " | sed "s/[[:space:]]//g;/^$/d" | sort | uniq'
alias fer='OLDIFS=$IFS ; IFS=$'\n' && for DOS in * ; do feh -FrSname $DOS ; done ; IFS=$OLDIFS'
alias virerdossiersvides='find . -name .directory -print0 | xargs -0 /bin/rm -fv ; find . -name Thumbs.db -print0 | xargs -0 /bin/rm -fv ; find . -type d -empty -print0 | xargs -0 /bin/rmdir -pv --ignore-fail-on-non-empty'
alias ka='vim $XDG_CONFIG_HOME/awesome/rc.lua; awesome -k'
alias trouvelesfichierslourds='for I in `find / -mount -type d`; do cd $I ; echo `ls -lAh | grep total | cut --delimiter=" " -f 2` $I; done | sort -h'
alias scan='scanimage --resolution 300 > image.pnm; gimp image.pnm; rm image.pnm'

alias fixchromium='rm $HOME/.config/chromium/SingletonLock'
alias x='startx 1>> ~/.X.log 2>> ~/.X.err'
alias xwow='cd /etc/X11/ ; sudo cp xorg.conf.24seul xorg.conf ; cd ; sudo cp .xinitrc.wow .xinitrc ; startx'
alias xaw='cd /etc/X11/ ; sudo cp xorg.conf.awesome xorg.conf ; cd ; sudo cp .xinitrc.awesome .xinitrc ; startx'
alias xkd='sudo cp /etc/X11/xorg.conf.tv /etc/X11/xorg.conf ; sudo kdm'
alias xxm='sudo cp /etc/X11/xorg.conf.xmonad /etc/X11/xorg.conf ; startx'
alias arsync='cd;for dos in latex;do echo -e "\t\t$dos"; rsync -avP $dos saurelg@ssh.inpt.fr:~/$dos;done'

 _mpdadd_complete_func ()
{
	cur="${COMP_WORDS[COMP_CWORD]}"
	first=${COMP_WORDS[1]}
	hold="";
	
	# add more escape stuff as needed:
	scrub='s/\([\\\>\\\<\\\(\\\)\\\";]\)/\\\1/g';
	
	case "$first" in
		add) 
		hold=`mpc tab ${cur}`;
		COMPREPLY=($(compgen -W "${hold}" | sed "$scrub"))
		return 0
		;;
		play|del|move)
		hold=`mpc playlist | sed 's/\#\([[:digit:]]\+\).*/\1/g'` # | grep "^${cur}"`
		COMPREPLY=($(compgen -W "${hold}" "${cur}"))
		return 0
		;;
		# TODO add trailing 's' for seconds in seek (total song time needed)
		seek|volume)
		COMPREPLY=($(compgen -W "`awk 'BEGIN{for(x=0;x<=100;x++){print x;print"-"x;print"+"x}}'`" "${cur}"))
		return 0
		;;
		# TODO get total song time and use that as a limit
		crossfade)
		COMPREPLY=($(compgen -W "`awk 'BEGIN{for(x=0;x<99;x++){print x}}'`" "${cur}"))
		return 0
		;;
		ls)
		if [ "x$cur" = "x" ]; then
			hold=`mpc ls`;
		else
			hold=`mpc lstab ${cur}`;
		fi
		COMPREPLY=($(compgen -W "${hold}" | sed "$scrub"))
		return 0
		;;
		search)
		COMPREPLY=($(compgen -W "album artist title filename" "${cur}"))
		return 0
		;;
		load|save|rm)
                if [ "x$cur" = "x" ]; then
                        hold=`mpc lsplaylists`;
                else
		        hold=`mpc loadtab ${cur}`;
                fi
		COMPREPLY=($(compgen -W "${hold}" | sed "$scrub"))
		return 0
		;;
		repeat|random)
		COMPREPLY=($(compgen -W "0 1 true false yes no on off" "${cur}"))
		return 0
		;;
		*)
		hold=`mpc help 2>&1 | awk '/^mpc [a-z]+ /{print $2}'`;
		COMPREPLY=($(compgen -W "${hold} status" ${cur}))
		return 0
		;;
	esac
}
complete -F _mpdadd_complete_func mpc

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
	tail -f $* | ccze -A
}
