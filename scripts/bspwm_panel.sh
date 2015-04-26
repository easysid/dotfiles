#! /bin/sh

source $(dirname $0)/panel_config

if [ $(pgrep -cx bspwm_panel.sh) -gt 1 ] ; then
    printf "%s\n" "The panel is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

bspc control --subscribe > "$PANEL_FIFO" &

#clock -sf 'C%a %d-%b %H:%M' > "$PANEL_FIFO" &
xtitle -sf 'T%s' > "$PANEL_FIFO" &
#xprop -spy -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/A\1/p' > "$PANEL_FIFO" &
# create the toggle file before running this conky
echo -n 1 > /tmp/bartoggle
conky -c ~/Conky/bspwm_toggle_conkyrc > "$PANEL_FIFO" &

bspwm_panel_bar.sh < "$PANEL_FIFO" \
     | lemonbar -p \
           -g "$geometry" \
           -f "$FONT1","$FONT2"\
           -B "$BAR_BG" \
           -F "$BAR_FG" \
           | while read line; do eval "$line"; done &
wait

