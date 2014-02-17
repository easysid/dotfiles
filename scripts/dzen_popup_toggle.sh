#!/bin/bash

POPUP="popup_$1"
COMMAND="dzen_$POPUP.sh"

pid=$(pgrep -f "$POPUP")
if [[ -z $pid ]]; then # if popup does not exit
    $COMMAND &
else
    kill $pid
fi

