#! /bin/sh
# panel.sh - parse bspwm information and run lemonbar
# Monday, 11 December 2017 17:47 IST

. theme_config

if [ $(pgrep -cx panel.sh) -gt 1 ] ; then
    printf "%s\n" "The panel is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

bspc subscribe > "$PANEL_FIFO" &
bar_sysinfo > "$PANEL_FIFO" &
bar_netinfo > "$PANEL_FIFO" &

NORMIFS=$IFS
FIELDIFS=':'

while read -r line ; do
    case $line in
        C*)
            # clock
            clock="${line#?}"
            ;;
        S*)
            # sysinfos
            sys_infos="${line#?}"
            ;;
        N*)
            # netinfo
            netinfo="${line#?}"
            ;;
        B*)
            # battery and calendar
            batcal="${line#?}"
            ;;
        W*)
            # bspwm internal state
            wm_infos=""
            IFS=$FIELDIFS
            set -- ${line#?}
            while [ $# -gt 0 ] ; do
                item=$1
                case $item in
                    [OoFfUu]*)
                        # desktops
                        name=${item#?}
                        case $item in
                            O*)
                                # focused occupied desktop
                                desk="%{F- B- U$UN_1 +u} ${name} %{F- B- -u}"
                                ;;
                            F*)
                                # focused free desktop
                                desk="%{F- B- U$UN_2 +u} ${name} %{F- B- -u}"
                                ;;
                            U*)
                                # focused urgent desktop
                                desk="%{F$F_U_FG B$F_U_BG} ${name} %{F- B-}"
                                ;;
                            o*)
                                # occupied desktop
                                desk="%{F$O_FG B$O_BG} ${name} %{F- B-}"
                                ;;
                            f*)
                                # free desktop
                                desk="%{F$F_FG B$F_BG} ${name} %{F- B-}"
                                ;;
                            u*)
                                # urgent desktop
                                desk="%{F$U_FG B$U_BG} ${name} %{F- B-}"
                                ;;
                        esac
                        wm_infos="${wm_infos}%{A:bspc desktop -f ${name}:}${desk} %{A}$PAD"
                        ;;
                esac
                shift
            done
            IFS=$NORMIFS
            ;;
    esac
    printf "%s\n" "%{l}  $wm_infos %{r} ${sys_infos}   ${netinfo}${batcal}  "
done < "$PANEL_FIFO" \
     | xft-lemonbar -p -d \
           -g "$geometry" \
           -B "$BAR_BG" \
           -F "$BAR_FG" \
           -f "$TEXT_FONT" -f "$ICON_FONT" \
           -n 'bspwm_panel' \
           -a 20 \
           -u 2 \
           | sh


