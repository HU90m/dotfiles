#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# the size of the bash history
HISTSIZE=10000
HISTFILESIZE=20000

# Add user directories to PATH
for directory in ~/.local/bin/ ~/.cargo/bin/; do
  if [ -d $directory ]; then
    PATH=$PATH:$directory
  fi
done

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# prompt
function return_value() {
    RETURN_VAL=$?
    [ $RETURN_VAL -ne 0 ] && echo " $RETURN_VAL |"
}
export PS1="\[\e[1;31m\]\$(return_value)\[\e[0m\]\[\e[1m\] \u@\h:\[\e[35m\]\w\[\e[0m\]\n\$ "

# colour
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

# set vim as default
export EDITOR="nvr -o"
export GIT_EDITOR="nvr --remote-wait-silent"
export VISUAL="nvr --remote-wait-silent"

# time savers
alias q="exit"
alias h="history"
alias l="ls -A"
alias ll="ls -hl"
alias la="ls -hlA"
alias du="du -h"
alias df="df -h"
alias d="dirs -v"
alias pd="pushd"
alias sls="screen -ls"
alias tls="tmux ls"
alias nterm="nvim +term +startinsert"
alias nterm2="nvim +term +term '+args # %' +startinsert"
alias vi="nvr -o"

# safety
alias rm="rm -I"
alias cp="cp -ivr"
alias mv="mv -iv"

# use GPG Key for SSH
USE_GPG_SSH_AGENT=true
if $USE_GPG_SSH_AGENT; then
  unset SSH_AGENT_PID
  if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    export SSH_AUTH_SOCK
  fi
  GPG_TTY="$(tty)"
  export GPG_TTY
  gpg-connect-agent updatestartuptty /bye >/dev/null
fi

# Carcinisation
if command -v starship &> /dev/null; then
  eval "$(starship init bash)"
fi
