[ -z "$PS1" ] && return

export KDEWM=awesome
export HISTCONTROL=ignoreboth

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

[[ "$UID" != 0 ]] && . $HOME/dotfiles/bash-it/base.theme.bash

#SCM_THEME_PROMPT_PREFIX=""
#SCM_THEME_PROMPT_SUFFIX=""

#SCM_THEME_PROMPT_DIRTY=" ${ROUGE}✗${nc}"
#SCM_THEME_PROMPT_CLEAN=" ${VERT}✓${nc}"
#SCM_GIT_CHAR="${VERT}±${nc}"
#SCM_SVN_CHAR="${CYAN}⑆${nc}"
#SCM_HG_CHAR="${ROUGE}☿${nc}"

#modern_scm_prompt() {
    #CHAR=$(scm_char)
    #[[ $CHAR != $SCM_NONE_CHAR ]] && echo "−[${CHAR} $(scm_prompt_info)${VERT}]"
#}

battery_prompt() {
    acpi -a 2> /dev/null | grep -q off && echo "−[${ROUGE}$(acpi -b|cut -d: -f 2-|sed 's/ Discharging, //')${VERT}]"
}

jobs_prompt() {
    [[ "$(jobs)" ]] && echo ${VERT}−[${nc}$(jobs -r|wc -l)r/$(jobs -s|wc -l)s${VERT}]
}

function ps1
{
RETC="$([[ $? == 0 ]] && echo $vert || echo $rouge)"
USERC="$([[ $UID == 0 ]] && echo $ROUGE || echo $JAUNE)"
SSHC="$([[ $SSH_CLIENT ]] && echo $CYAN || echo $BLEU)"

PS1="${RETC}┌─${VERT}[${USERC}\u${BLANC}@${SSHC}\h${BLANC}:\w${VERT}]-[${RETC}\t${VERT}]$(jobs_prompt)$(battery_prompt)
${RETC}└─>${ROUGE}\$ ${nc}"
}

PROMPT_COMMAND=ps1
PS2='\[\033[1;32m\]└──>\[\033[m\] '
PS3='└─?> '

shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s globstar
shopt -s histappend
shopt -s histreedit
shopt -s hostcomplete
shopt -s lithist

if [[ -x /usr/bin/fortune ]]
then
    /usr/bin/fortune
fi
echo
users
echo
tmux ls 2> /dev/null || true
echo
function _exit() {
    echo -e "\033[0;31mHasta la vista, baby\033[0m"
}

trap _exit EXIT

# TODO : une "launch" fonction, qui fait un tmux,
#   si un argument : cmd
#   si deux : session-name & cmd
#   si trois : session-name, window-name & cmd

[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local

[[ "$UID" != 0 ]] && . $HOME/dotfiles/bash-it/git.completion.bash

. $HOME/dotfiles/aliases-exports.sh
[[ -f "$HOME/.cargo/env"]] && source "$HOME/.cargo/env"
