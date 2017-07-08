#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# set custom PATH
export PATH="${PATH}:${HOME}/.scripts:${HOME}/.bin"

# baspwm FIFO
export PANEL_FIFO="/tmp/panel_fifo"

# fix accesibility DBus errors
export NO_AT_BRIDGE=1

# start X
#[[ -z $DISPLAY && $XDG_VTNR -eq 1 && $(tty) == '/dev/tty1' ]] && exec startx
if [[ -z $DISPLAY && $XDG_VTNR -eq 1 && $(tty) == '/dev/tty1' ]]; then
    echo 'Starting GUI'
    #	exec startx &> /dev/null
    exec startx
fi
