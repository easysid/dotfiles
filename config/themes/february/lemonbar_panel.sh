#! /bin/sh
#
# bar input parser for bspwm  Sunday, 01 November 2015 11:42 IST

#screen_width=$(sres -W)

NORMIFS=$IFS
FIELDIFS=':'

source $(dirname $0)/theme_config

while read -r line ; do
    case $line in
        S*)
            # conky
            sys_infos="${line#?}"
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
                        wm_infos="${wm_infos}%{A:bspc desktop -f ${name}:}${desk} %{A}"
                        ;;
                esac
                shift
            done
            IFS=$NORMIFS
            ;;
    esac
    printf "%s\n" "%{c}$wm_infos $sys_infos"
done

