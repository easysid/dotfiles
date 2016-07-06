#!/bin/bash

LINES=5
WIDTH=240
#XPOS=1000

. dzen_popup_config

shopt -s expand_aliases
alias vnstat='vnstat -i wlp2s0+enp4s0'
(
echo "^fg($titlecol)Netinfo^fg()"
QUAL=$(iwconfig wlp2s0 | sed -n 's@.*Quality=\([0-9]*/[0-9]*\).*@100\*\1@p' | bc)
BAR=$(echo $QUAL | gdbar -bg $bar_bg -fg $bar_fg -h $bar_h -w $bar_w)
MONTH=$(vnstat --short | grep "\<$(date +%b)\>" |\
    awk '{ gsub("iB",""); printf "%s%-4s %s%-3s %s%-3s",$3,$4,$6,$7,$9,$10}')
TODAY=$(vnstat --short |\
    awk '/today/{ gsub("iB",""); printf "%s%-3s %s%-2s %s%-2s",$2,$3,$5,$6,$8,$9}')
echo -e "$PAD ^fg("$highlight")Qual: ^fg()  $BAR  $QUAL%"
echo -e "$PAD ^fg("$highlight")Usage:  Down       Up     Total"
echo -e "$PAD ^fg("$highlight")Month: ^fg() $MONTH"
echo -e "$PAD ^fg("$highlight")Today: ^fg() $TODAY"
) | dzen2 -title-name "popup_netinfo" -p "$TIME" -l "$LINES" -sa 'l'\
          -fn "$FONT" ${OPTIONS}
unalias vnstat

