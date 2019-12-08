#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# set custom PATH
export PATH="${PATH}:${HOME}/.local/bin"

# editor
export EDITOR=vim

# bspwm FIFO
export PANEL_FIFO="/tmp/panel_fifo"

# fix accesibility DBus errors
# export NO_AT_BRIDGE=1

# start X
# if [[ -z $DISPLAY && $XDG_VTNR -eq 1 && $(tty) == '/dev/tty1' ]]; then
#     exec startx &> /dev/null
# else
#     echo "Not starting GUI on $(tty)"
# fi
