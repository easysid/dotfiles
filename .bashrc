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
alias ls='ls --color=auto'
alias la='ls -a'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

# set_ps1 () {
#     local red="\[\033[1;31m\]" # Red -- error symbol
#     local col1="\[\033[0;31m\]" # Red - color for username@host
#     local col2="\[\033[0;36m\]" # Green - color for directory
#     local wht="\[\033[0;37m\]" # White
#     local rst="\[\033[0m\]"    # Text Reset

#     PS1="\n$wht\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"($red\342\234\227$wht)\342\224\200\")($col1\u@\h$wht)\342\224\200($col2\w$wht)\n$wht\342\224\224\342\224\200\342\224\200\342\225\274 $rst"
# }

# set_ps1

# random coloured PS1
# from arch forum post by falconidy
random_color (){
    local err="\[\033[1;31m\]" # error -- red
    local nor="\[\033[0;37m\]" # normal -- white
    local rst="\[\033[0m\]"    # Text Reset
    # random colour
    local color="\[\033[$(( $RANDOM%2 ));$(( 31+$RANDOM%7 ))m\]"
    # generate prompt
    PS1="\n\$([[ \$? != 0 ]] && echo \"$err\" || echo \"$nor\")\W $color❱❱ $rst"
}

# set PS1
PROMPT_COMMAND="random_color"

# create command not found hook
source /usr/share/doc/pkgfile/command-not-found.bash

# history settings
export HISTSIZE=2000
export HISTFILESIZE=2000
export HISTCONTROL=ignoreboth
export HISTIGNORE="cd *:ls:ls *:history*:cat *:clear:pwd:..:..."

# disable flow control
stty -ixon

# urxvt dynamic title
# from https://mg.pov.lt/blog/bash-prompt.html
case "$TERM" in
    xterm*|rxvt*)
        PROMPT_COMMAND=${PROMPT_COMMAND}';printf "\033]0;❭❭  %s\007" "${PWD}"'

        show_command_in_title_bar()
        {
            case "$BASH_COMMAND" in
                *\033]0*|*\\e]0*)
                    # nested escapes confuse the terminal, so don't output them.
                    ;;
                *\033*|*\007*|*\\e*)
                    ;;
                *)
                    printf "\e]0;❭❭ %s\a" "${BASH_COMMAND}"
                    ;;
            esac
        }
        trap show_command_in_title_bar DEBUG
        ;;
    *)
        ;;
esac

