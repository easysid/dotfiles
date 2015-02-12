#!/bin/bash

LINES=5
WIDTH=240
#XPOS=1000

source $(dirname $0)/dzen_popup_config

source $(dirname $0)/mouselocation.sh

(
echo "Netinfo"
QUAL=$(iwconfig wlan0 | sed -n 's@.*Quality=\([0-9]*/[0-9]*\).*@100\*\1@p' | bc)
BAR=$(echo $QUAL | gdbar -bg $bar_bg -fg $bar_fg -h 2 -w 130)
MONTH=$(vnstat --short | grep $(date +%b) |\
    awk '{ gsub("iB",""); printf "%s%-4s %s%-3s %s%-3s",$3,$4,$6,$7,$9,$10}')
TODAY=$(vnstat --short |\
    awk '/today/{ gsub("iB",""); printf "%s%-3s %s%-2s %s%-2s",$2,$3,$5,$6,$8,$9}')
echo -e "$PAD ^fg("")Qual: ^fg()  $BAR  $QUAL%"
echo -e "$PAD ^fg("")Usage:  Down       Up     Total"
echo -e "$PAD ^fg("")Month: ^fg() $MONTH"
echo -e "$PAD ^fg("")Today: ^fg() $TODAY"
) | dzen2 -p "$TIME" -x "$XPOS" -w "$WIDTH" -l "$LINES" -sa 'l'\
    -title-name "popup_netinfo" -fn "$FONT" ${OPTIONS}
