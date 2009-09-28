# Check for an interactive session
[ -z "$PS1" ] && return

export EDITOR=kate
export VISUAL=kate
export XDG_DATA_HOME=~/.uzbl/data/
export XDG_CONFIG_HOME=~/.config/
export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}

PS1='\[\033[1;37m\][\
\[\033[1;33m\]\u\
\[\033[1;37m\]@\
\[\033[1;36m\]\h\
\[\033[1;37m\]:\
\[\033[1;37m\]\w\
\[\033[1;37m\]]\
\[\033[1;31m\]$\
\[\033[0;32m\] '


# ALIAS

alias ls='ls --color=auto --time-style=+"%d.%m.%Y %H:%M"'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cp='cp -r'
alias ll='ls -lArth'
alias le='ls --sort=extension'
alias df='df -h'

alias leecher='/home/nim/scripts/leecher.sh'
alias seeder='/home/nim/scripts/seeder.sh'
alias wow='wine /media/320/World\ of\ Warcraft/Wow.exe -opengl'
alias carto='wine /home/nim/.wine/drive_c/Program\ Files/WowCartographe/WowCartographe.exe'
alias fah='cd /media/60/nim/FAH ; ./fah6 -smp'
alias urter='/media/70/home/nim/down/UrbanTerror/ioUrbanTerror.x86_64'
alias wa='cd /home/nim/Desktop/logs/weekalarm ; ./weekalarm.py'
alias psef='ps -ef | grep -v grep | grep'
alias tag='mpc stop'
alias hist='cat /home/nim/.bash_history | sort | cut -f 1 --delimiter=" " | uniq'
alias halt='sudo halt'
alias reboot='sudo reboot'
alias cn='fortune chucknorris'
alias sql='mysql -uroot -pfdsjkl65'
alias ka='/media/60/nim/scripts/ka.sh'
alias kaok='/media/60/nim/scripts/kaok.sh'
alias fer='ILS=$"\n" && for DOS in `ls` ; do feh -FrSname $DOS ; done'
alias ext='/home/nim/60/scripts/extracteur.sh'
alias xwow='cd /etc/X11/ ; sudo cp xorg.conf.nimono xorg.conf ; cd ; sudo cp .xinitrc.wow .xinitrc ; startx'
alias xaw='cd /etc/X11/ ; sudo cp xorg.conf.awesome xorg.conf ; cd ; sudo cp .xinitrc.awesome .xinitrc ; startx'
alias xkd='sudo cp /etc/X11/xorg.conf.tv /etc/X11/xorg.conf ; sudo kdm'
alias virerdossiersvides='find . -name .directory -print0 | xargs -0 /bin/rm -f ; find . -type d -empty -print0 | xargs -0 /bin/rmdir'
alias tor='mv /home/nim/T*/*.torrent /home/nim/Desktop/'
alias keni='/home/nim/60/scripts/keni.sh'








# put this in your bashrc for bash tab completion with mpc
# $ cat mpc-bashrc >> ~/.bashrc


#export MPD_HOST="127.0.0.1"
#export MPD_PORT="6600"

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
