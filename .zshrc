ZSH=$HOME/dotfiles/oh-my-zsh
ZSH_THEME="nim"
CASE_SENSITIVE="true"
GIT_PS1_SHOWDIRTYSTATE="true"
GIT_PS1_SHOWSTASHSTATE="true"
GIT_PS1_SHOWUNTRACKEDFILES="true"
GIT_PS1_SHOWUPSTREAM="verbose"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git django gitfast systemd)

source $ZSH/oh-my-zsh.sh
source $ZSH/../aliases-exports.sh
source $(which virtualenvwrapper.sh)

# Customize to your needs...

function check_for_virtual_env {
    local GIT_REPO=$(git rev-parse --show-toplevel 2> /dev/null)

    if [[ $? == 0 && -f $GIT_REPO/.venv ]]; then
        local ENV_NAME=$(cat $GIT_REPO/.venv)

        if [ "${VIRTUAL_ENV##*/}" != $ENV_NAME ] && [ -e $WORKON_HOME/$ENV_NAME/bin/activate ]; then
            workon $ENV_NAME && export CD_VIRTUAL_ENV=$ENV_NAME
        fi
    elif [ $CD_VIRTUAL_ENV ]; then
        deactivate && unset CD_VIRTUAL_ENV
    fi
}

function cd {
    builtin cd "$@" && check_for_virtual_env
}

check_for_virtual_env
