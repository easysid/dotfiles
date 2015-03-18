#!/bin/bash
#
# dvolbar - OSD Volume utility
#

#Customize this stuff
IF="Master"         # audio channel: Master|PCM
SECS="1"            # sleep $SECS
XPOS="1000"         # horizontal positioning
HEIGHT="30"         # window height
WIDTH="230"         # window width
ICON='^i(/home/siddharth/.icons/dzen/volume50.xbm)'
MUTEICON='^i(/home/siddharth/.icons/dzen/volume0.xbm)'

source $(dirname $0)/dzen_popup_config

#Probably do not customize
PIPE="/tmp/dvolpipe"

err() {
    echo "$1"
    exit 1
}

usage() {
    echo "usage: dvol [option] [argument]"
    echo
    echo "Options:"
    echo "     -i, --increase - increase volume by \`argument'"
    echo "     -d, --decrease - decrease volume by \`argument'"
    echo "     -t, --toggle   - toggle mute on and off"
    echo "     -h, --help     - display this"
    exit
}

#Argument Parsing
case "$1" in
    '-i'|'--increase')
        [[ -z $2 ]] && err "No argument specified for increase."
        [[ -n $(tr -d [0-9] <<<$2) ]] && err "The argument needs to be an integer."
        AMIXARG="${2}%+"
        ;;
    '-d'|'--decrease')
        [[ -z $2 ]] && err "No argument specified for decrease."
        [[ -n $(tr -d [0-9] <<<$2) ]] && err "The argument needs to be an integer."
        AMIXARG="${2}%-"
        ;;
    '-t'|'--toggle')
        AMIXARG="toggle"
        ;;
    ''|'-h'|'--help')
        usage
        ;;
    *)
        err "Unrecognized option \`$1', see dvol --help"
        ;;
esac

#Actual volume changing (readability low)
AMIXOUT="$(amixer -M set "$IF" "$AMIXARG" | tail -n 1)"
MUTE="$(cut -d '[' -f 4 <<<"$AMIXOUT")"
if [[ $MUTE = "off]" ]]; then
    VOL="0"
    ICON="^fg($bar_warn)$MUTEICON"
else
    VOL="$(cut -d '[' -f 2 <<<"$AMIXOUT" | sed 's/%.*//g')"
fi

#Using named pipe to determine whether previous call still exists
#Also prevents multiple volume bar instances
if [[ ! -e $PIPE ]]; then
    mkfifo "$PIPE"
    (dzen2 -h "$HEIGHT" -fn "$FONT" ${OPTIONS} < "$PIPE"
    rm -f "$PIPE") &
fi

BAR=$(echo "$VOL" | gdbar -fg "$bar_fg" -bg "$bar_bg" -w "$bar_w" -h "$bar_h")

#Feed the pipe!
(echo "$ICON  $BAR  $VOL%"; sleep "$SECS") > "$PIPE"

