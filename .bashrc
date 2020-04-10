#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# the size of the bash history
HISTSIZE=100000

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
alias l="ls -A"
alias ll="ls -hl"
alias la="ls -hlA"
alias du="du -h"
alias df="df -h"
alias d="dirs -v"
alias pd="pushd"
alias sls="screen -ls"
alias tls="tmux ls"

# safety
alias rm="rm -ir"
alias cp="cp -vir"
alias mv="mv -v"

# preferences
alias yt-dl-music="youtube-dl -f bestaudio[ext=m4a] -o \"%(title)s.%(ext)s\""
alias flite="flite -voice ~/.config/flite/voices/cmu_us_awb.flitevox"

# because I can never remember
alias sotonvpn="sudo openconnect --protocol=gp -u hm6g17 globalprotect.soton.ac.uk"
alias sshsoton="ssh hm6g17@ssh.soton.ac.uk"
alias sshiridis5="ssh -J hm6g17@ssh.soton.ac.uk hm6g17@iridis5_a.soton.ac.uk"
alias sshjustiridis5="ssh hm6g17@iridis5_a.soton.ac.uk"
alias sshpi="ssh pi@192.168.0.10"
alias MountSD="sudo mount /dev/sdb /mnt/one/ -o uid=1000,gid=1000"



# Change GNU Readlines to vi
# I have changed this universally in ~/.inputrc
#set -o vi

# functions
function za {
    zathura "$1" &
    disown zathura
}
