#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# the size of the bash history
HISTSIZE=1500

# prompt
export PS1="\[\e[1m\] \u@\h:\[\e[35m\]\w\[\e[0m\e[2m\]\n \[\e[0m\]\$ "

# colour
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

# set vim as default
export EDITOR="vim"
export VISUAL="vim"

# time savers
alias q="exit"
alias h="history"
alias ll="ls -hl"
alias du="du -h"
alias df="df -h"
alias sls="screen -ls"
alias tls="tmux ls"

# safety
alias rm="rm -i"
alias cp="cp -i"

# Change GNU Readlines to vi
# better to change this universally in ~/.inputrc
#set -o vi
