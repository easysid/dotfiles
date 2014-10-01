#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# source my own .dir_colors file
if [ -f $HOME/.dir_colors ]; then
    eval $(dircolors -b $HOME/.dir_colors)
fi

# aliases

alias ls='ls --color=auto'
alias grep='grep --color=auto'

#PS1='[\u@\h \W]\$ '

set_ps1 () {
    local bred="\[\033[1;31m\]" # Red -- error symbol
    local col1="\[\033[1;31m\]" # Red - color for username@host
    local col2="\[\033[1;32m\]" # Green - color for directory
    local wht="\[\033[1;37m\]" # White
    local rst="\[\033[0m\]"    # Text Reset

    PS1="\n$wht\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"($red\342\234\227$wht)\342\224\200\")($col1\u@\h$wht)\342\224\200($col2\w$wht)\n$wht\342\224\224\342\224\200\342\224\200\342\225\274 $rst"
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
