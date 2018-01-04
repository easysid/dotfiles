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
#__set_ps1 (){
#    local err="\[\033[1;31m\]" # error -- red
#    local nor="\[\033[1;30m\]" # normal -- white
#    local por="\[\033[1;30m\]" # prompt char
#    local dirty="\[\033[0;33m\]" # dirty git
#    local rst="\[\033[0m\]"    # Text Reset
#    # random color
#    # local color="\[\033[$(( $RANDOM%2 ));$(( 31+$RANDOM%7 ))m\]"
#    #
#    # git info
#    local gitinfo=
#    local branch=$(git symbolic-ref HEAD --short 2> /dev/null)
#    if [[ $branch ]]; then
#        local x=$(git status --porcelain)
#        if [[ $x ]]; then
#            gitinfo="${nor}(${dirty}${branch}${nor}) "
#        else
#            gitinfo="${nor}(${branch}) "
#        fi
#    fi
#    #
#    # generate prompt
#    PS1="\n \$([[ \$? != 0 ]] && echo \"$err\" || echo \"$nor\")\W ${gitinfo}${por}$ $rst"
#}

# powerline style PS1
__powerline_ps1 () {
    local status=$?
    # define colors
    local text='\[[1;30m\]' # text color black
    local nor_bg='\[[44m\]'   # normal bg blue
    local nor_fg='\[[34m\]'   # normal fg blue
    local err_bg='\[[41m\]'   # error bg red
    local err_fg='\[[31m\]'   # error fg red
    local git_bg='\[[42m\]'   # clean git bg green
    local git_fg='\[[32m\]'   # clean git fg green
    local dir_bg='\[[43m\]'   # dirty git bg yellow
    local dir_fg='\[[33m\]'   # dirty git fg yellow
    local rst_bg='\[[49m\]'   # reset bg color
    local rst='\[[0m\]'       # reset all
    local bld='\[[1m\]'       # bold colors
    local git_symbol=''
    local arrow=''
    local gitc="$rst_bg"

    # check last command status
    if [[ $status != 0 ]]; then
        nor_bg="$err_bg"
        nor_fg="$err_fg"
    fi
    # git info
    local gitinfo=
    local branch=$(git symbolic-ref HEAD --short 2> /dev/null)
    if [[ $branch ]]; then
        local x=$(git status --porcelain)
        if [[ $x ]]; then
            gitc="$dir_bg"
            gitinfo="${text} ${git_symbol} ${branch} ${rst_bg}${dir_fg}${arrow}"
        else
            gitc="$git_bg"
            gitinfo="${text} ${git_symbol} ${branch} ${rst_bg}${git_fg}${arrow}"
        fi
    fi
    # cwd
    local cwd="${text}${nor_bg} \W ${gitc}${nor_fg}${arrow}"
    PS1="\n${bld}${cwd}${gitinfo}${rst} "
}

# set PS1
case "$TERM" in
    xterm*|rxvt*)
        # PROMPT_COMMAND="__set_ps1"
        PROMPT_COMMAND="__powerline_ps1"
        ;;
    *)
        PS1='\[\e[1;37m\]┌─$([ $? -eq 0 ] || echo "(\[\e[1;31m\]fail\[\e[1;37m)─")(\t)─(\u@\h)─(\w)\n└─> '
        ;;
esac

# history settings
export HISTSIZE=2000
export HISTFILESIZE=2000
export HISTCONTROL=ignoreboth
export HISTIGNORE="cd *:ls:ls *:history*:cat *:clear:pwd:..:..."

# disable flow control
stty -ixon

