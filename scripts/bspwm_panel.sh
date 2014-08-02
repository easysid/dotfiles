#! /bin/sh

if [ $(pgrep -cx bspwm_panel) -gt 1 ] ; then
    printf "%s\n" "The panel is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

flavor=${1:-bar}

bspc control --subscribe > "$PANEL_FIFO" &
#clock -sf 'C%a %d-%b %H:%M' > "$PANEL_FIFO" &
xtitle -sf 'T%s' > "$PANEL_FIFO" &
#xprop -spy -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/A\1/p' > "$PANEL_FIFO" &


case "$flavor" in
    bar)
        # start the bar conky
        #conky -c ~/Conky/bspwm_july_conkyrc > "$PANEL_FIFO" &
        conky -c ~/Conky/bspwm_bar_conkyrc > "$PANEL_FIFO" &

        # launch panel
        bspwm_panel_bar_pl.sh < "$PANEL_FIFO" | bar -p -g 1346x14+10 \
           -f "-benis-lemon-medium-r-normal--10-110-75-75-m-50-iso8859-1" \
           -B '#FF383A3B' -F '#FFBBBBBB' | while read line; do eval "$line"; done &
        ;;
    dzen2)
        # Launch right panel
        conky -c ~/Conky/bspwm_dzen_conkyrc | dzen2 -h '20' -w '756' -x "605" \
            -dock -ta 'r' -e 'button2=;' -title-name 'bspwm_panel' \
            -fn "tamsynmod:pixelsize=10" -fg "#a3a6ab" -bg "#34322e" &

        # Launch left panel
        bspwm_panel_dzen2.sh < "$PANEL_FIFO" | dzen2 -h '20' -w '600' -x "5" \
            -dock -ta 'l' -e 'button2=;' -title-name 'bspwm_panel' \
            -fn "tamsynmod:pixelsize=10" -fg "#a3a6ab" -bg "#34322e" &
        ;;
esac

wait
