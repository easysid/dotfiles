#! /bin/sh
#
# bar input parser for bspwm  Sunday, 01 November 2015 11:42 IST

#screen_width=$(sres -W)

NORMIFS=$IFS
FIELDIFS=':'

. theme_config

while read -r line ; do
    case $line in
        S*)
            # sysinfos
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
                        wm_infos="${wm_infos}%{A:bspc desktop -f ${name}:}${desk} %{A}"
                        ;;
                esac
                shift
            done
            IFS=$NORMIFS
            ;;
    esac
    printf "%s\n" "%{l}$wm_infos %{r}$sys_infos"
done

