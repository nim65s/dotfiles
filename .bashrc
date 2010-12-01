[ -z "$PS1" ] && return

export MUUA=user:password
alias sql='/opt/lampp/bin/mysql -uuser -ppassword'

export KDEWM=awesome

export EDITOR=vim
export XDG_DATA_HOME=~/.uzbl/data/
export XDG_CONFIG_HOME=~/.config
export XDG_CONFIG_DIRS=/etc/xdg
export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}

export N7=saurelg@ssh.inpt.fr
export VIMRUNTIME=/usr/share/vim/vim73/

PS1='\[\033[0;32m\]┌─\
\[\033[1;32m\][\
\[\033[1;33m\]\u\
\[\033[1;37m\]@\
\[\033[1;36m\]\h\
\[\033[1;37m\]:\
\[\033[1;37m\]\w\
\[\033[1;32m\]]-[\
\[\033[0;32m\]\t\
\[\033[1;32m\]]
\[\033[0;32m\]└─>\
\[\033[1;31m\]$\
\[\033[0m\] '
PS2='\[\033[1;32m\]└──>\[\033[m\] '
PS3='└─?> '

# ALIAS

alias ls='ls --color=auto --time-style=+"%d.%m.%Y %H:%M"'
alias sl='ls --color=auto --time-style=+"%d.%m.%Y %H:%M"'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias df='df -h'
alias mv='mv -v'
alias cp='cp -r'

alias kdm='sudo kdm'
alias halt='sudo halt'
alias reboot='sudo reboot'

alias ll='ls -lArth'
alias le='ls --sort=extension'
alias la='ls -A'
alias psef='ps -ef | grep -v grep | grep'
alias psj='ps j | grep -v grep | grep'
alias cn='fortune chucknorris'

alias meurs='$HOME/scripts/meurs.sh'
alias ext='$HOME/scripts/extracteur.sh'
alias dl='$HOME/scripts/dl.sh'
alias adl='$HOME/scripts/autodl.sh'
alias dlbot='$HOME/scripts/dlbot.sh'

alias fah='sudo $HOME/scripts/fah.sh'

alias wow='wine /media/T/Jeux/World\ of\ Warcraft/Wow.exe -opengl'
alias windirstat='wine $HOME/.wine/drive_c/Program\ Files/WinDirStat/windirstat.exe'

alias hist='cat $HOME/.bash_history | sort | cut -f 1 --delimiter=" " | uniq'
alias fer='OLDIFS=$IFS ; IFS=$'\n' && for DOS in * ; do feh -FrSname $DOS ; done ; IFS=$OLDIFS'
alias virerdossiersvides='find . -name .directory -print0 | xargs -0 /bin/rm -fv ; find . -name Thumbs.db -print0 | xargs -0 /bin/rm -fv ; find . -type d -empty -print0 | xargs -0 /bin/rmdir -pv --ignore-fail-on-non-empty'
alias testrc='cp $HOME/dotfiles/rc.lua $HOME/.config/awesome/rc.lua ; cp $HOME/dotfiles/theme.lua /usr/share/awesome/themes/nim/theme.lua ;( awesome -k && echo -e "\033[1;32mmod4 + ctrl + r\033[0;32m" ) || echo -e "\033[1;31mFAIL\033[0;32m"'
alias trouvelesfichierslourds='for I in `find / -mount -type d`; do cd $I ; echo `ls -lAh | grep total | cut --delimiter=" " -f 2` $I; done | sort -h'

alias xwow='cd /etc/X11/ ; sudo cp xorg.conf.24seul xorg.conf ; cd ; sudo cp .xinitrc.wow .xinitrc ; startx'
alias xaw='cd /etc/X11/ ; sudo cp xorg.conf.awesome xorg.conf ; cd ; sudo cp .xinitrc.awesome .xinitrc ; startx'
alias xkd='sudo cp /etc/X11/xorg.conf.tv /etc/X11/xorg.conf ; sudo kdm'
alias xxm='sudo cp /etc/X11/xorg.conf.xmonad /etc/X11/xorg.conf ; startx'

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
