#!/bin/bash
#
# dzen2 popup for album art and music osd
# Tuesday, 26 April 2016 22:34 IST
#

WIDTH=300
HEIGHT=82
TIME=8

. dzen_popup_config

# define pipe
PIPE=/tmp/musicinfo_pipe

# if terminated by TERM
trap "rm -f $PIPE" SIGTERM

if mpc status | grep '\[playing\]' > /dev/null; then
    play="$HOME/.icons/dzen/pause.xbm"
else
    play="$HOME/.icons/dzen/play.xbm"
fi
next="$HOME/.icons/dzen/next.xbm"
prev="$HOME/.icons/dzen/prev.xbm"
title=$(mpc current -f '%title%')
artist=$(mpc current -f '%artist%')
album=$(mpc current -f '%album%')
file=$(mpc current -f '%file%')
perc=$(mpc | awk 'NR == 2 {gsub(/[()%]/,""); print $4}')
bar=$(echo $perc | gdbar -bg $bar_bg -fg $bar_fg -h 3 -w 200)
temp=${file%/*}
temp="${temp##*/}.xpm"
albumart="$HOME/.config/covers/$temp"
if [[ ! -f $albumart ]]; then
    albumart="$HOME/.config/covers/notfound.xpm"
fi

# read from the pipe
if [[ ! -e $PIPE ]]; then
    mkfifo "$PIPE"
    ( dzen2 -u -title-name 'popup_musicinfo' -h "$HEIGHT" \
            -fn "$FONT" ${OPTIONS} -ta 'l' < "$PIPE"
    rm -f "$PIPE" ) &
fi

# feed the pipe
(
echo "^pa(5;5)^i($albumart)^ib(1) \
^pa(110;5)^ca(1, mpc prev;$0) ^i($prev) ^ca() \
^pa(180;5)^ca(1, mpc toggle;$0) ^i($play) ^ca() \
^pa(250;5)^ca(1, mpc next;$0) ^i($next) ^ca() \
^pa(90;25)^fg($titlecol)$title^fg() \
^pa(90;40)^fg($ylw)$artist^fg() \
^pa(90;55)^fg($ylw)$album^fg() \
^pa(90;73)$bar \
"
sleep 8s
) > "$PIPE"

