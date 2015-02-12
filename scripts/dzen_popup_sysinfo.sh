#!/bin/bash

LINES=5
WIDTH=220
#XPOS=800

source $(dirname $0)/dzen_popup_config

source $(dirname $0)/mouselocation.sh

KERNEL=$(uname -r)
UPTIME=$( uptime | sed 's/.* up *//;s/[0-9]* us.*//;s/ day, /d /;s/ days, /d /;s/:/h /;s/ min//;s/,/m/;s/  / /')
PACKAGES=$(pacman -Q | wc -l)
UPDATE=$(awk '/upgraded/ {line=$0;} END { $0=line; gsub(/[\[\]]/,"",$0); \
              printf "%s %s",$1,$2;}' /var/log/pacman.log)

(
echo "Sysinfo"
echo "$PAD ^fg("$label")Uptime:^fg() $UPTIME"
echo "$PAD ^fg("$label")Kernel:^fg() $KERNEL"
echo "$PAD ^fg("$label")Pacman:^fg() $PACKAGES packages"
echo "$PAD ^fg("$label")Last updated on:^fg() $UPDATE $PAD"
) | dzen2 -p "$TIME" -x "$XPOS" -w "$WIDTH" -l "$LINES" -sa 'l' \
          -title-name 'popup_sysinfo' -fn "$FONT" ${OPTIONS}

