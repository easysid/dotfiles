#! /bin/sh
#
# bar input parser for bspwm

#screen_width=$(sres -W)

NORMIFS=$IFS
FIELDIFS=':'
PAD='  '
LPAD='                     '
#
#------Colors definition-------#
#
F_O_FG='#FFC5A854'
F_O_BG='#FF383A3B'
F_F_FG='#FFc9c9c9'
F_F_BG='#FF383A3B'
F_U_FG='#FF9D3535'
F_U_BG='#FF383A3B'
O_FG='#FFc9c9c9'
O_BG='#FF383A3B'
F_FG='#FF696969'
F_BG='#FF383A3B'
U_FG='#FF9D3535'
U_BG='#FF383A3B'
#LAYOUT_FG='#FFAAAAAA'
#LAYOUT_BG='#FF505050'
TITLE_FG='#FFb0b0b0'
TITLE_BG='#FF383A3B'
#STATUS_FG='#FFA3A6AB'
#STATUS_BG='#FF383A3B'
#
#-----------------------------#
#

while read -r line ; do
    case $line in
        S*)
            # conky
            sys_infos="${line#?}"
            ;;
        #A*)
            ## custom window title using xprop xwinfo
            #title="%{F$TITLE_FG B-}${PAD}$(xwinfo -c ${line#?} | sed 's@N/A@@')${PAD}%{F- B-}"
            #;;
        T*)
            # window title
            title=$(echo ${line#?} | sed 's^\(.\{40\}\).*^\1...^')
            title="%{F$TITLE_FG} ${title} ${LPAD} %{F-}"
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
                                FG=$F_O_FG
                                BG=$F_O_BG
                                ;;
                            F*)
                                # focused free desktop
                                FG=$F_F_FG
                                BG=$F_F_BG
                                ;;
                            U*)
                                # focused urgent desktop
                                FG=$F_U_FG
                                BG=$F_U_BG
                                ;;
                            o*)
                                # occupied desktop
                                FG=$O_FG
                                BG=$O_BG
                                ;;
                            f*)
                                # free desktop
                                FG=$F_FG
                                BG=$F_BG
                                ;;
                            u*)
                                # urgent desktop
                                FG=$U_FG
                                BG=$U_BG
                                ;;
                        esac
                        wm_infos="${wm_infos}%{F$FG B$BG A:bspc desktop -f ${name}:}${PAD}${name}${PAD}%{A B- F-}"
                        ;;
                    #L*)
                        ## layout
                        #layout=$(printf "[%s]" $( echo "${item#?}" | sed 's/^\(.\).*/\U\1/'))
                        #wm_infos="${wm_infos}%{F$BG B$LAYOUT_BG}%{F$LAYOUT_FG A:bspc desktop -l next:} $layout %{A F$LAYOUT_BG B-}"
                        #;;
                esac
                shift
            done
            IFS=$NORMIFS
            ;;
    esac
    printf "%s\n" "%{l}$wm_infos %{c}$title %{r}$sys_infos "
done
