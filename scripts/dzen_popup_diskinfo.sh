#!/bin/bash

LINES=5
WIDTH=350
#XPOS=900

source $(dirname $0)/dzen_popup_config

(
echo "^fg($label)Diskinfo^fg()"
echo " "
df -h | grep -E 'sda[567]' | while read -r F TOTAL USED AVAIL P M; do
    MOUNT=${M/\/*\//\/}
    USE=${P%\%}
    if [ "$USE" -gt 75 ]; then
        BAR=$(echo "$USE" | gdbar -bg $bar_bg -fg $bar_warn -h 2 -w 130)
    else
        BAR=$(echo "$USE" | gdbar -bg $bar_bg -fg $bar_fg -h $bar_h -w $bar_w)
    fi
    echo -e "$PAD ^fg("$highlight")$(printf '%-6s' $MOUNT)^fg() $BAR  $USED / $TOTAL ($AVAIL free)$PAD"
    done
) | dzen2 -title-name "popup_diskinfo" -p "$TIME" -l "$LINES" -sa 'l' \
          -fn "$FONT" ${OPTIONS}

