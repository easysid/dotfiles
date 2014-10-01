#! /bin/sh
#
# bar input parser for bspwm  Tuesday, 01 July 2014 22:57

#screen_width=$(sres -W)

NORMIFS=$IFS
FIELDIFS=':'
PAD='  '


source $(dirname $0)/panel_config

while read -r line ; do
    case $line in
        S*)
            # conky
            sys_infos="${line#?}"
            ;;
        #A*)
        #    # custom window title using xprop xwinfo
        #    title="%{F$TITLE_FG B-}${PAD}$(xwinfo -c ${line#?} | sed 's@N/A@@')${PAD}%{F- B-}"
        #    ;;
        C*)
            #clock
            clock="${line#?}"
            clock="%{F$CLOCK_BG}⮂%{F- B$CLOCK_BG A:dzen_popup_toggle.sh calendar:} ${clock} %{A B- F$CLOCK_BG}⮀%{F-}"
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
                                desk="%{F$F_O_FG}■"
                                ;;
                            F*)
                                # focused free desktop
                                desk="%{F$F_F_FG}□"
                                ;;
                            U*)
                                # focused urgent desktop
                                desk="%{F$F_U_FG}■"
                                ;;
                            o*)
                                # occupied desktop
                                desk="%{F$O_FG}□"
                                ;;
                            f*)
                                # free desktop
                                desk="%{F$F_FG}-"
                                ;;
                            u*)
                                # urgent desktop
                                desk="%{F$U_FG B$U_BG}□"
                                ;;
                        esac
                        wm_infos="${wm_infos}%{A:bspc desktop -f ${name}:}${PAD}${desk}${PAD}%{A}"
                        ;;
                    #L*)
                        # layout
                        #layout=$(printf "[%s]" $( echo "${item#?}" | sed 's/^\(.\).*/\U\1/'))
                        #wm_infos="${wm_infos}%{F$BG B$LAYOUT_BG}%{F$LAYOUT_FG A:bspc desktop -l next:} $layout %{A F$LAYOUT_BG B-}"
                     #   ;;
                esac
                shift
            done
            IFS=$NORMIFS
            ;;
    esac
    printf "%s\n" "%{l B$F_O_BG}$wm_infos %{F$F_O_BG B-}⮀%{F-} %{c}${clock} %{r}$sys_infos %{B-}"
done
