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
sysinfo > "$PANEL_FIFO" &

lemonbar_panel.sh < "$PANEL_FIFO" \
     | lemonbar -p -d \
           -g "$geometry" \
           -f "$ICON_FONT" -f "$FONT1"\
           -B "$BAR_BG" \
           -F "$BAR_FG" \
           -n 'bspwm_panel' \
           -a 20 \
           -u 2 \
           | sh

