#
# ~/.bashrc
#

PATH=$PATH:~/.local/bin/

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# the size of the bash history
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Change GNU Readlines to vi
# I have changed this universally in ~/.inputrc
#set -o vi

# Start up the gpg-agent and set ssh to point to it.
#export GPG_TTY="$(tty)"
#export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
#gpgconf --launch gpg-agent

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

# setup completion (works in fedora)
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

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
alias rm="rm -ir"
alias cp="cp -vir"
alias mv="mv -iv"

# preferences
alias yt-dl-music="youtube-dl -f bestaudio[ext=m4a] -o \"%(title)s.%(ext)s\""
alias flite="flite -voice ~/.config/flite/voices/cmu_us_awb.flitevox"

# because I can never remember
alias vpnsoton="sudo openconnect --protocol=gp -u hm6g17 globalprotect.soton.ac.uk"

# functions
function za {
    for pdffile in "$@"
    do
        zathura "$pdffile" 2>/dev/null 1>/dev/null &
        disown zathura
    done
}

function g {
    for file in "$@"
    do
        name="$(basename "$file")"
        ext="${name##*.}"
        case $ext in
            "jpg"|"png")
                echo "sxiv $file"
                sxiv "$file";;
            "pdf")
                echo "za $file"
                za "$file";;
            *)
                echo "cd $file"
                cd "$file";;
        esac
    done
}

# use GPG Key for SSH
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# Sharship prompt
eval "$(starship init bash)"
