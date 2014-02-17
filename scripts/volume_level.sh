#!/bin/bash


VOL=$(amixer -M get Master | grep -oE '[0-9]+%' | sed 's/%//')
if amixer get Master | grep '\[on\]' > /dev/null; then
   if [ "$VOL" -lt "33" ]; then
       ICON='  ^fg(\#888888)^i(/home/siddharth/.icons/dzen/volume25.xbm)^fg()'
   elif [ "$VOL" -lt "66" ]; then
       ICON='  ^fg(\#888888)^i(/home/siddharth/.icons/dzen/volume50.xbm)^fg()'
   else
       ICON='  ^fg(\#888888)^i(/home/siddharth/.icons/dzen/volume75.xbm)^fg()'
   fi
else
       ICON='  ^fg(\#b45a5a)^i(/home/siddharth/.icons/dzen/volume0.xbm)^fg()'
fi

echo "$ICON $VOL%"
