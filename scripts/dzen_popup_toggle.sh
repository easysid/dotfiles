#!/bin/bash

REGEX="dzen2 .*popup_$1"
COMMAND="dzen_popup_$1.sh"

if [[ $# -ne 1 ]]; then
    echo -e "Usage:\ndzen_popup_toggle.sh <popup_name>" 1>&2
    exit 1
fi
pid=$(pgrep -f "$REGEX")
if [[ -z $pid ]]; then # if popup does not exit
    $COMMAND &
else
    kill $pid
fi

