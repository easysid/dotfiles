#!/bin/bash

# get mouse location
eval $(xdotool getmouselocation --shell 2> /dev/null)
screen_width=$(sres -W)
x_offset=$((WIDTH/2))
R_edge=$((X+x_offset))
XPOS=$((X-x_offset))
if [[ "$R_edge" -gt "$screen_width" ]]; then
    XPOS=$((X-WIDTH))
fi

