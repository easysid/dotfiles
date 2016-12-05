#! /bin/sh

. theme_config

if [ $(pgrep -cx panel.sh) -gt 1 ] ; then
    printf "%s\n" "The panel is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

bspc subscribe > "$PANEL_FIFO" &
~/Workspace/c/a.out > "$PANEL_FIFO" &

dzen_panel.sh < "$PANEL_FIFO" \
     | ocelot-dzen -p -x 0 -y 100 -w 28 -l 27 -h 20 \
                   -bg ${BG} -fg ${FG} -sa 'c' \
                   -fn "monospace:size=10" -e "onstart=uncollapse"

