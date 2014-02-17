#!/bin/bash

# pop-up calendar for dzen
#
# based on (c) 2007, by Robert Manea
# http://dzen.geekmode.org/dwiki/doku.php?id=dzen:calendar
# modified by urukrama
# modified by senft
# modified by easysid

source $(dirname $0)/dzen_popup_config.sh

WIDTH=150
LINES=8
XPOS=1194
YPOS=30

# define pipe
PIPE=/tmp/calendar_pipe

TODAY=$(expr `date +'%d'` + 0)
MONTH=$(date +'%m')
YEAR=$(date +'%Y')

MM=${1:-"$MONTH"}
YY=${2:-"$YEAR"}
NEXT=$((MM+1))
PREV=$((MM-1))
let Y_NEXT=Y_PREV=YY

if [[ $NEXT -eq 13 ]]; then
    NEXT=1
    Y_NEXT=$((YY+1))
fi

if [[ $PREV -eq 0 ]]; then
    PREV=12
    Y_PREV=$((YY-1))
fi

# generate calender
if [[ "$MM" -eq "$MONTH" ]] && [[ "$YY" -eq "$YEAR" ]]; then  # current month, highlight header and date
    CAL=$(cal | sed -re "s/^(.*[A-Za-z][A-Za-z]*.*)$/^fg($highlight)\1^fg()/;s/(^|[ ])($TODAY)($|[ ])/\1^bg($highlight2)^fg($highlight)\2^fg()^bg()\3/")
else  # another month, just highlight header
    CAL=$(cal "$MM" "$YY" | sed -re "s/^(.*[A-Za-z][A-Za-z]*.*)$/^fg($highlight)\1^fg()/")
fi

# read from pipe
if [ ! -e "$PIPE" ]; then
  mkfifo "$PIPE"
  ( dzen2 -u -bg $BG -fg $FG -fn "${FONT}:pixelsize=${FONTSIZE}" -x $XPOS -y $YPOS -w $WIDTH -l $LINES -sa 'c' -e "$ACT" -title-name 'popup_calendar' < "$PIPE"
   rm -f "$PIPE") &
fi

# feed the pipe
(
echo "$CAL"
echo "^fg($highlight)^ca(1, $0 $PREV $Y_PREV)<< Prev^ca()        ^ca(1, $0 $NEXT $Y_NEXT)Next >>^ca()^fg()"
sleep 8s
) > "$PIPE"

