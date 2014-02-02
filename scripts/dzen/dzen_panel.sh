#!/bin/bash

#dzen panel script

FONT="tamsynmod"
FONTSIZE="10"
FG="#b0b0b0"
BG="#333333"

conky -c ~/Conky/dzen_conkyrc | dzen2 -h "20" -w "500" -x "860" -y '1'\
    -fn "$FONT:pixelsize=$FONTSIZE" -bg "$BG" -fg "$FG" -ta 'r' -e 'button2=;' &
