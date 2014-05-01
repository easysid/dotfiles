#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
alias ls='ls --color=auto'
eval $(dircolors -b)

alias grep='grep --color=auto'

#PS1='[\u@\h \W]\$ '

set_ps1 () {
    #local blk="\[\033[0;30m\]" # Black - Regular
    #local red="\[\033[0;31m\]" # Red
    #local grn="\[\033[0;32m\]" # Green
    #local ylw="\[\033[0;33m\]" # Yellow
    #local blu="\[\033[0;34m\]" # Blue
    #local pur="\[\033[0;35m\]" # Purple
    #local cyn="\[\033[0;36m\]" # Cyan
    #local wht="\[\033[0;37m\]" # White
    #local bblk="\[\033[1;30m\]" # Black - Bold
    local bred="\[\033[1;31m\]" # Red
    local bgrn="\[\033[1;31m\]" # Green
    #local bylw="\[\033[1;33m\]" # Yellow
    local bblu="\[\033[1;34m\]" # Blue
    #local bpur="\[\033[1;35m\]" # Purple
    #local bcyn="\[\033[1;36m\]" # Cyan
    local bwht="\[\033[1;37m\]" # White
    local rst="\[\033[0m\]"    # Text Reset

    PS1="\n$bwht\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"($bred\342\234\227$bwht)\342\224\200\")($bblu\u@\h$bwht)\342\224\200($bgrn\w$bwht)\n$bwht\342\224\224\342\224\200\342\224\200\342\225\274 $rst"
}

set_ps1

# urxvt dynamic title

case "$TERM" in
    xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;urxvt :: ${PWD/~/~}\007"'

        # Show the currently running command in the terminal title:
        # http://www.davidpashley.com/articles/xterm-titles-with-bash.html
        show_command_in_title_bar()
        {
            case "$BASH_COMMAND" in
                *\033]0*)
                    # The command is trying to set the title bar as well;
                    # this is most likely the execution of $PROMPT_COMMAND.
                    # In any case nested escapes confuse the terminal, so don't output them.
                    ;;
                *)
                    echo -ne "\033]0;urxvt :: ${BASH_COMMAND}\007"
                    ;;
            esac
        }
        trap show_command_in_title_bar DEBUG
        ;;
    *)
        ;;
esac

# set custom PATH
export PATH="${PATH}:~/.scripts"

# create command not found hook
source /usr/share/doc/pkgfile/command-not-found.bash

# history settings
export HISTSIZE=2000
export HISTFILESIZE=2000
export HISTCONTROL=ignoreboth
export HISTIGNORE="cd *:ls:ls *:history*:cat *:clear"

# disable flow control
stty -ixon
