#!/bin/bash

LINES=5
WIDTH=350
#XPOS=900

source $(dirname $0)/dzen_popup_config
source $(dirname $0)/mouselocation.sh

(
echo "Diskinfo"
echo " "
df -h | grep -E 'sda[567]' | while read -r F TOTAL USED AVAIL P M; do
    MOUNT=${M/\/*\//\/}
    USE=${P%\%}
    if [ "$USE" -gt 75 ]; then
        BAR=$(echo "$USE" | gdbar -bg $bar_bg -fg $warn -h 2 -w 130)
    else
        BAR=$(echo "$USE" | gdbar -bg $bar_bg -fg $bar_fg -h $bar_h -w $bar_w)
    fi
    echo -e "$PAD ^fg("$label")$(printf '%-6s' $MOUNT)^fg() $BAR  $USED / $TOTAL ($AVAIL free)$PAD"
    done
) | dzen2 -p "$TIME" -x "$XPOS" -w "$WIDTH" -l "$LINES" -sa 'l' \
          -title-name "popup_diskinfo" -fn "$FONT" ${OPTIONS}

