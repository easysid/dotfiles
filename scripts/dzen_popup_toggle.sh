#!/bin/bash

POPUP="popup_$1"
COMMAND="dzen_$POPUP.sh"

if [[ $# -ne 1 ]]; then
    echo -e "Usage:\ndzen_popup_toggle.sh <popup_name>" 1>&2
    exit 1
fi
pid=$(pgrep -f "$POPUP")
if [[ -z $pid ]]; then # if popup does not exit
    $COMMAND &
else
    kill $pid
fi

