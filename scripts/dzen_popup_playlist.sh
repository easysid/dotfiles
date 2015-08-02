#!/bin/bash

# ncmpcpp playlist popup using urxvt
# Sunday, 05 July 2015 22:04 IST
# name the file dzen_popup so that it can be toggled by the dzen toggle script.
#

size=7
lines=15
chars=70
YPOS=35
WIDTH=$((chars*size))
# XPOS=700

# function to get mouse x-coordinate
function mouselocation(){
    eval $(xdotool getmouselocation --shell 2> /dev/null)
    screen_width=$(sres -W)
    x_offset=$((WIDTH/2))
    R_edge=$((X+x_offset))
    XPOS=$((X-x_offset))
    if [[ $R_edge -gt $screen_width ]]; then
        XPOS=$((X-WIDTH))
    fi
}

[[ $XPOS ]] || mouselocation

pid=$(pgrep -f 'urxvt -name playlist')
if [[ -z $pid ]]; then
    urxvt -name 'playlist' -geometry "${chars}x${lines}+${XPOS}+${YPOS}" -e ncmpcpp &
else
    kill $pid
fi

