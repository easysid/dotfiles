#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# source my own .dircolors file
if [ -f $HOME/.dircolors ]; then
    eval $(dircolors -b $HOME/.dircolors)
fi

# aliases
alias ls='ls --color=auto --group-directories-first -h'
alias la='ls -a'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

# PS1 with error, and git info
__set_ps1 (){
    local err="\[\033[1;31m\]" # error -- red
    local nor="\[\033[1;30m\]" # normal -- white
    local por="\[\033[1;30m\]" # prompt char
    local dirty="\[\033[0;33m\]" # dirty git
    local rst="\[\033[0m\]"    # Text Reset
    # random color
    # local color="\[\033[$(( $RANDOM%2 ));$(( 31+$RANDOM%7 ))m\]"
    #
    # git info
    local gitinfo=
    local branch=$(git symbolic-ref HEAD --short 2> /dev/null)
    if [[ $branch ]]; then
        local x=$(git status --porcelain)
        if [[ $x ]]; then
            gitinfo="${nor}(${dirty}${branch}${nor}) "
        else
            gitinfo="${nor}(${branch}) "
        fi
    fi
    #
    # generate prompt
    PS1="\n \$([[ \$? != 0 ]] && echo \"$err\" || echo \"$nor\")\W ${gitinfo}${por}$ $rst"
}
# set PS1
PROMPT_COMMAND="__set_ps1"

# create command not found hook
source /usr/share/doc/pkgfile/command-not-found.bash

# history settings
export HISTSIZE=2000
export HISTFILESIZE=2000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="cd *:ls:ls *:history*:cat *:clear:pwd:..:..."

# disable flow control
stty -ixon

