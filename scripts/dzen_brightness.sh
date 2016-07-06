#!/bin/bash
#
# dzen_brightness.sh : OSD brightness utility
# modified from dvol.sh
# Sunday, 16 February 2014 19:01 IST
#


#Customize this stuff
SECS="1"            # sleep $SECS
XPOS="1000"          # horizontal positioning
HEIGHT="30"         # window height
WIDTH="220"         # window width
icon='^i(/home/siddharth/.icons/dzen/brightness.xbm)'

. dzen_popup_config

#Probably do not customize
PIPE="/tmp/dbright_pipe"

err() {
    echo "$1"
    exit 1
}

usage() {
    echo "usage: dvol [option]"
    echo
    echo "Options:"
    echo "     up - increase brightness "
    echo "     down - decrease brightness"
    echo "     -h, --help     - display this"
    exit
}

CURR=$(< /sys/class/backlight/acpi_video0/brightness)
MAX=$(< /sys/class/backlight/acpi_video0/max_brightness)

case $1 in
    up)
        if [[ $CURR -lt $MAX ]]; then
            CURR=$((CURR+1))
            echo $CURR > /sys/class/backlight/acpi_video0/brightness
        fi
        ;;
    down)
        if [[ $CURR -gt 0 ]]; then
            CURR=$((CURR-1))
            echo $CURR > /sys/class/backlight/acpi_video0/brightness
        fi
        ;;
    ''|'-h'|'--help')
        usage
        ;;
    *)
        err "Unrecognized option \`$1', see --help"
        ;;
esac

PERC=$((CURR*100/MAX))

#Using named pipe to determine whether previous call still exists
#Also prevents multiple instances
if [[ ! -e $PIPE ]]; then
    mkfifo "$PIPE"
    (dzen2 -h "$HEIGHT" -fn "$FONT" ${OPTIONS} < "$PIPE"
    rm -f "$PIPE") &
fi

BAR=$(echo "$PERC" | gdbar -fg "$bar_fg" -bg "$bar_bg" -w "$bar_w" -h "$bar_h")

#Feed the pipe!
(echo "$icon  $BAR  $CURR"; sleep "$SECS"  ) > "$PIPE"

