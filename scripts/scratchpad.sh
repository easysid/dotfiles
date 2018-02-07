#!/bin/sh

SCRATCHPAD_ID="/tmp/ScratchPadWinId"

launch() {
    st -c 'scratchpad' -g '85x20-20+35' \
       -e $SHELL --rcfile ~/.config/scratchpad/bashrc &
    sleep 3
    bspc query -N -n .hidden > "$SCRATCHPAD_ID"
}

toggle() {
    id=$(cat $SCRATCHPAD_ID)
    case "$id" in
        0x*)
            bspc node $id --flag hidden; bspc node -f $id
            ;;
        *)
            notify-send "$0" "Wrong window Id"
            ;;
    esac
}

case "$1" in
    launch)
        launch
        ;;
    toggle)
        toggle
        ;;
    *)
        echo "Incorrect usage"
        ;;
esac
