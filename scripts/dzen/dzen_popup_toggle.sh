#!/bin/bash

POPUP="popup_$1"
COMMAND="/home/siddharth/.scripts/dzen/$POPUP.sh"

pid=$(pgrep -f "$POPUP")
if [[ -z $pid ]]; then # if popup does not exit
    $COMMAND &
else
    kill $pid
fi

