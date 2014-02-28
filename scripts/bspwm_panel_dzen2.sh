#! /bin/sh
#
# dzen2 input parser for bspwm

#screen_width=$(sres -W)

NORMIFS=$IFS
FIELDIFS=':'
PADDING='  '
#
#------Colors definition-------#
#
COLOR_FOCUSED_OCCUPIED_FG='#F6F9FF'
COLOR_FOCUSED_OCCUPIED_BG='#5C5955'
COLOR_FOCUSED_FREE_FG='#F6F9FF'
COLOR_FOCUSED_FREE_BG='#6D561C'
COLOR_FOCUSED_URGENT_FG='#34322E'
COLOR_FOCUSED_URGENT_BG='#F9A299'
COLOR_OCCUPIED_FG='#A3A6AB'
COLOR_OCCUPIED_BG='#34322E'
COLOR_FREE_FG='#6F7277'
COLOR_FREE_BG='#34322E'
COLOR_URGENT_FG='#F9A299'
COLOR_URGENT_BG='#34322E'
COLOR_LAYOUT_FG='#A3A6AB'
COLOR_LAYOUT_BG='#34322E'
COLOR_TITLE_FG='#A3A6AB'
COLOR_TITLE_BG='#34322E'
COLOR_STATUS_FG='#A3A6AB'
COLOR_STATUS_BG='#34322E'
#
#-----------------------------#
#

while read -r line ; do
    case $line in
        S*)
            # clock output
            sys_infos="^fg($COLOR_STATUS_FG)^bg($COLOR_STATUS_BG)${PADDING}${line#?}${PADDING}^fg()^bg()${PADDING}"
            ;;
        A*)
            # custom window title using xprop xwinfo
            title="^fg($COLOR_TITLE_FG)^bg($COLOR_TITLE_BG)${PADDING}$(xwinfo -c ${line#?} | sed 's@N/A@@')${PADDING}^fg()^bg()"
            ;;
        W*)
            # bspwm internal state
            wm_infos="$PADDING"
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
                                FG=$COLOR_FOCUSED_OCCUPIED_FG
                                BG=$COLOR_FOCUSED_OCCUPIED_BG
                                ;;
                            F*)
                                # focused free desktop
                                FG=$COLOR_FOCUSED_FREE_FG
                                BG=$COLOR_FOCUSED_FREE_BG
                                ;;
                            U*)
                                # focused urgent desktop
                                FG=$COLOR_FOCUSED_URGENT_FG
                                BG=$COLOR_FOCUSED_URGENT_BG
                                ;;
                            o*)
                                # occupied desktop
                                FG=$COLOR_OCUPPIED_FG
                                BG=$COLOR_OCUPPIED_BG
                                ;;
                            f*)
                                # free desktop
                                FG=$COLOR_FREE_FG
                                BG=$COLOR_FREE_BG
                                ;;
                            u*)
                                # urgent desktop
                                FG=$COLOR_URGENT_FG
                                BG=$COLOR_URGENT_BG
                                ;;
                        esac
                        wm_infos="${wm_infos}^fg(${FG})^bg(${BG})^ca(1, bspc desktop -f ${name})^ca(2, bspc window -d ${name})${PADDING}${name}${PADDING}^ca()^ca()"
                        ;;
                    L*)
                        # layout
                        layout=$(printf "[%s]" $( echo "${item#?}" | sed 's/^\(.\).*/\U\1/'))
                        wm_infos="${wm_infos}^fg()^bg()${PADDING}${PADDING}^fg($COLOR_LAYOUT_FG)^bg($COLOR_LAYOUT_BG)^ca(1, bspc desktop -l next)${PADDING}$layout${PADDING}^ca()"
                        ;;
                esac
                shift
            done
            IFS=$NORMIFS
            ;;
    esac
    printf "%s\n" "$wm_infos $PADDING $title"
done
