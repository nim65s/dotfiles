set -x PYENV_ROOT /root/dotfiles/pyenv
set -x PATH $PATH $PYENV_ROOT/bin
status --is-interactive; and source (pyenv init -|psub)
