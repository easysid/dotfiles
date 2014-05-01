#! /bin/sh
#
# bar input parser for bspwm

#screen_width=$(sres -W)

NORMIFS=$IFS
FIELDIFS=':'
PADDING='  '

#
#------Colors definition-------#
#
COLOR_FOCUSED_OCCUPIED_FG='#FF268bd2'
COLOR_FOCUSED_OCCUPIED_BG='#FF182434'
COLOR_FOCUSED_FREE_FG='#FFb58900'
COLOR_FOCUSED_FREE_BG='#FF182434'
COLOR_FOCUSED_URGENT_FG='#FFa55050'
COLOR_FOCUSED_URGENT_BG='#FF182434'
COLOR_OCCUPIED_FG='#FFBBBBBB'
COLOR_OCCUPIED_BG='#FF182434'
COLOR_FREE_FG='#FF808080'
COLOR_FREE_BG='#FF182434'
COLOR_URGENT_FG='#FFF9A299'
COLOR_URGENT_BG='#FF182434'
COLOR_LAYOUT_FG='#FFAAAAAA'
COLOR_LAYOUT_BG='#FF505050'
COLOR_TITLE_FG='#FFc7bda4'
COLOR_TITLE_BG='#FF182434'
COLOR_STATUS_FG='#FFA3A6AB'
COLOR_STATUS_BG='#FF182434'
#
#-----------------------------#
#

while read -r line ; do
    case $line in
        S*)
            # conky
            sys_infos="${line#?}"
            ;;
        A*)
            # custom window title using xprop xwinfo
            title="%{F$COLOR_TITLE_FG B-}${PADDING}$(xwinfo -c ${line#?} | sed 's@N/A@@')${PADDING}%{F- B-}"
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
                                FG=$COLOR_OCCUPIED_FG
                                BG=$COLOR_OCCUPIED_BG
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
                        wm_infos="${wm_infos}%{F$FG B$BG A:bspc desktop -f ${name}:}${PADDING}${name}${PADDING}%{A}"
                        ;;
                    L*)
                        # layout
                        layout=$(printf "[%s]" $( echo "${item#?}" | sed 's/^\(.\).*/\U\1/'))
                        wm_infos="${wm_infos}%{F$BG B$COLOR_LAYOUT_BG}%{F$COLOR_LAYOUT_FG A:bspc desktop -l next:} $layout %{A F$COLOR_LAYOUT_BG B-}"
                        ;;
                esac
                shift
            done
            IFS=$NORMIFS
            ;;
    esac
    printf "%s\n" "%{l}$wm_infos %{c}$title %{r}$sys_infos"
done
