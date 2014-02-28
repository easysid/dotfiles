#!/bin/bash

# pop-up calendar for dzen
#
# based on (c) 2007, by Robert Manea
# http://dzen.geekmode.org/dwiki/doku.php?id=dzen:calendar
# modified by urukrama
# modified by senft
# modified by easysid

source $(dirname $0)/dzen_popup_config


WIDTH=150
LINES=16

XPOS=1194
YPOS=30

TODAY=$(expr `date +'%d'` + 0)
MONTH=`date +'%m'`
YEAR=`date +'%Y'`

(echo
# current month, hilight header and today
cal | sed -re "s/^(.*[A-Za-z][A-Za-z]*.*)$/^fg($highlight)\1^fg()/;s/(^|[ ])($TODAY)($|[ ])/\1^bg($highlight2)^fg($highlight)\2^fg()^bg()\3/"

# next month, hilight header
[ $MONTH -eq 12 ] && YEAR=`expr $YEAR + 1`
cal `expr \( $MONTH + 1 \) % 12` $YEAR \
    | sed -e "s/^\(.*[A-Za-z][A-Za-z]*.*\)$/\1/"
) | dzen2 -p -bg $BG -fg $FG -fn "${FONT}:pixelsize=${FONTSIZE}" -x $XPOS -y $YPOS -w $WIDTH -l $LINES -sa c -e "$ACT" -title-name 'popup_calendar'
