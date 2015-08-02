#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# set custom PATH
export PATH="${PATH}:/home/siddharth/.scripts"

# enable HW Accleration in FF
export MOZ_USE_OMTC=1

# start X
#[[ -z $DISPLAY && $XDG_VTNR -eq 1 && $(tty) == '/dev/tty1' ]] && exec startx
if [[ -z $DISPLAY && $XDG_VTNR -eq 1 && $(tty) == '/dev/tty1' ]]; then
	echo 'Starting GUI'
#	exec startx &> /dev/null
	exec startx
fi
