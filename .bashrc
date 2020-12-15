#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# the size of the bash history
HISTSIZE=100000

# prompt
function return_value() {
    RETURN_VAL=$?
    [ $RETURN_VAL -ne 0 ] && echo " $RETURN_VAL |"
}
export PS1="\[\e[1;31m\]\$(return_value)\[\e[97m\] \u@\h:\[\e[35m\]\w\[\e[0m\]\n\$ "

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
alias nterm="nvim +term +startinsert"

# safety
alias rm="rm -ir"
alias cp="cp -vir"
alias mv="mv -iv"

# preferences
alias yt-dl-music="youtube-dl -f bestaudio[ext=m4a] -o \"%(title)s.%(ext)s\""
alias flite="flite -voice ~/.config/flite/voices/cmu_us_awb.flitevox"

# because I can never remember
alias vpnsoton="sudo openconnect --protocol=gp -u hm6g17 globalprotect.soton.ac.uk"
alias sshsoton="ssh hm6g17@ssh.soton.ac.uk"
alias sshiridis5="ssh -J hm6g17@ssh.soton.ac.uk hm6g17@iridis5_a.soton.ac.uk -Y"
alias sshjustiridis5="ssh hm6g17@iridis5_a.soton.ac.uk"
alias sshiridis4="ssh -J hm6g17@ssh.soton.ac.uk hm6g17@iridis4_b.soton.ac.uk -Y"
alias sshjustiridis4="ssh hm6g17@iridis4_b.soton.ac.uk"
alias sshheadless="ssh -Y pi@hms-headless.fritz.box"

alias mntsd="sudo mount /dev/sdb -o uid=1000,gid=1000"
alias mntheadless="sudo mount hms-headless.fritz.box:/mnt/one/"
alias umnt="sudo umount"

alias changewallpaper="find ~/.wallpapers -type f | sort -R | head -1 | xargs feh --bg-fill"


# Change GNU Readlines to vi
# I have changed this universally in ~/.inputrc
#set -o vi

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
