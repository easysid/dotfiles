#!/bin/bash

# Tuesday, 08 October 2013 19:42
# brightness script for openbox
# call brightness up/down in rc.xml

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
esac

notify-send -t 1500 "Brightness $CURR"
