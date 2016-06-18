#! /bin/sh

. "$(dirname $0)/theme_config"

if [ $(pgrep -cx panel.sh) -gt 1 ] ; then
    printf "%s\n" "The panel is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

bspc subscribe > "$PANEL_FIFO" &

## create the toggle file before running this conky
echo -n 0 > /tmp/bartoggle
conky -c ~/Conky/lemonbar_conkyrc > "$PANEL_FIFO" &

lemonbar_panel.sh < "$PANEL_FIFO" \
     | lemonbar -p \
           -g "$geometry" \
           -f "$ICON_FONT" -f "$FONT1"\
           -B "$BAR_BG" \
           -F "$BAR_FG" \
           -a 20 \
           | sh
wait

