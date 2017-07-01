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

sysinfo_material > "$PANEL_FIFO" &

NORMIFS=$IFS
FIELDIFS=':'

while read -r line ; do
    case $line in
        S*)
            # sysinfo
            sys_infos="${line#?}"
            ;;
        C*)
            # clock
            clock="${line#?}"
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
                                desk="%{F$F_O_FG B$F_O_BG} $DFO %{F- B-}"
                                ;;
                            F*)
                                # focused free desktop
                                desk="%{F$F_F_FG B$F_F_BG} $DFO %{F- B-}"
                                ;;
                            U*)
                                # focused urgent desktop
                                desk="%{F$F_U_FG B$F_U_BG} $DFO %{F- B-}"
                                ;;
                            o*)
                                # occupied desktop
                                desk="%{F$O_FG B$O_BG} $DO %{F- B-}"
                                ;;
                            f*)
                                # free desktop
                                desk="%{F$F_FG B$F_BG} $DF %{F- B-}"
                                ;;
                            u*)
                                # urgent desktop
                                desk="%{F$U_FG B$U_BG} $DO %{F- B-}"
                                ;;
                        esac
                        wm_infos="${wm_infos}%{A:bspc desktop -f ${name}:}${desk}%{A}    "
                        ;;
                esac
                shift
            done
            IFS=$NORMIFS
            ;;
    esac
    printf "%s\n" "%{l}   %{T3}$wm_infos%{T-} %{c} $clock %{r} $sys_infos  "
done < "$PANEL_FIFO" \
     | xft-lemonbar -p -d \
           -g "$geometry" \
           -B "$BAR_BG" \
           -F "$BAR_FG" \
           -o  -1 -f "$TEXT_FONT1" \
           -o   0 -f "$ICON_FONT1" -o -1 -f "$ICON_FONT2" \
           -n 'bspwm_panel' \
           -a 20 \
           | sh

