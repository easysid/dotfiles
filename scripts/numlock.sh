#!/bin/sh
# Turn on numlock. Requires xdotool

status=$(xset q | awk '/: Num Lock:/{print $8}')
[ "$status" = "on" ] || xdotool key Num_Lock

