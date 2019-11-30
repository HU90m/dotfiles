#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# the size of the bash history
HISTSIZE=10000

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
alias la="ls -ha"
alias lla="ls -hla"
alias du="du -h"
alias df="df -h"
alias d="dirs -v"
alias pd="pushd"
alias sls="screen -ls"
alias tls="tmux ls"

# safety
alias rm="rm -i"
alias cp="cp -i"

# because I can never remember
alias yt-dl-music="youtube-dl -f bestaudio[ext=m4a] -o \"%(title)s.%(ext)s\""
alias sotonvpn="sudo openconnect --protocol=gp -u hm6g17 globalprotect.soton.ac.uk"

# Change GNU Readlines to vi
# I have changed this universally in ~/.inputrc
#set -o vi

# functions
function za {
    zathura $1 &
    disown zathura
}
