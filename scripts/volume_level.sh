#!/bin/bash


VOL=$(amixer -M get Master | grep -oE '[0-9]+%' | sed 's/%//')
ICON=
FUNC=${1:-"dzen_icon"}

bar_font() {
    if amixer get Master | grep '\[on\]' > /dev/null; then
       if [ "$VOL" -lt "50" ]; then
           ICON='%{F\#888888}%{F-}'
       else
           ICON='%{F\#888888}%{F-}'
       fi
    else
           ICON='%{F\#b45a5a}%{F-}'
    fi
}

dzen_icon() {
    if amixer get Master | grep '\[on\]' > /dev/null; then
       if [ "$VOL" -lt "50" ]; then
           ICON='  ^fg(\#888888)^i(/home/siddharth/.icons/dzen/volume25.xbm)^fg()'
       else
           ICON='  ^fg(\#888888)^i(/home/siddharth/.icons/dzen/volume75.xbm)^fg()'
       fi
    else
           ICON='  ^fg(\#b45a5a)^i(/home/siddharth/.icons/dzen/volume0.xbm)^fg()'
    fi
}

"$FUNC"
echo "$ICON $VOL%"
