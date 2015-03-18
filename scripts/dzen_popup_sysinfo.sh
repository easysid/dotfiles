#!/bin/bash

LINES=5
WIDTH=220
# XPOS=800

source $(dirname $0)/dzen_popup_config

KERNEL=$(uname -r)
UPTIME=$( uptime | sed 's/.* up *//;s/[0-9]* us.*//;s/ day, /d /;s/ days, /d /;s/:/h /;s/ min//;s/,/m/;s/  / /')
PACKAGES=$(pacman -Q | wc -l)
UPDATE=$(awk '/upgraded/ {line=$0;} END { $0=line; gsub(/[\[\]]/,"",$0); \
              printf "%s %s",$1,$2;}' /var/log/pacman.log)

(
echo "^fg($label)Sysinfo^fg()"
echo "$PAD ^fg("$highlight")Uptime:^fg() $UPTIME"
echo "$PAD ^fg("$highlight")Kernel:^fg() $KERNEL"
echo "$PAD ^fg("$highlight")Pacman:^fg() $PACKAGES packages"
echo "$PAD ^fg("$highlight")Last updated on:^fg() $UPDATE $PAD"
) | dzen2 -title-name 'popup_sysinfo' -p "$TIME" -l "$LINES" -sa 'l' \
          -fn "$FONT" ${OPTIONS}

