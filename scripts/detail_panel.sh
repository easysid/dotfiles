#! /bin/sh
#
# detail_panel.sh
# displays a lemonbar segment with more detailed sysinfo
#

[ $(pgrep -cx detail_panel.sh) -gt 1 ] && killall detail_panel.sh

trap "trap - TERM; kill 0" INT TERM QUIT EXIT

. theme_config
# bar geometry
# o=${IFS}
# IFS='x+'
# l=400
# read -r x y gx gy << EOF
# $geometry
# EOF
# IFS=${o}
# geometry="${l}x${y}+$((x+gx-l))+${gy}"
geometry='400x25+960+738'
BAR_BG="#FF${background}"

sysinfo -f "%{r}" -l | lemonbar -p -d \
        -g "$geometry" \
        -f "$ICON_FONT" -f "$FONT1"\
        -B "$BAR_BG" \
        -F "$BAR_FG" \
        | sh &
wait

