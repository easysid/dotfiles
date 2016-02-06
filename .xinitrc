#!/bin/sh


if [[ -f ~/.Xresources ]]; then
    xrdb -merge ~/.Xresources
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# extra ctrl key
setxkbmap -option ctrl:nocaps

# get bitmap fonts
for i in ~/.fonts/bitmap/*; do
    xset +fp "$i"
done

# start programs
sxhkd &
exec bspwm
