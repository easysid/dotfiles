#! /bin/sh
#
# vertical dzen input parser for bspwm
# uses ocelot-dzen https://github.com/poinck/ocelot-dzen
# Monday, 28 November 2016 22:36 IST


#screen_width=$(sres -W)

NORMIFS=$IFS
FIELDIFS=':'

. theme_config


while read -r line ; do
    case $line in
        B*)
            # battery
            bat="${line#?}"
            ;;
        N*)
            # network
            net="${line#?}"
            ;;
        C*)
            #clock
            clk="${line#?}"
            read -r h m p << EOF
            $clk
EOF
            clk="$h\n$m\n$p"
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
                                desk="^fg($F_O_FG)${name}^fg()"
                                ;;
                            F*)
                                # focused free desktop
                                desk="^fg($F_F_FG)${name}^fg()"
                                ;;
                            U*)
                                # focused urgent desktop
                                desk="^fg($F_U_FG)${name}^fg()"
                                ;;
                            o*)
                                # occupied desktop
                                desk="^fg($O_FG)${name}^fg()"
                                ;;
                            f*)
                                # free desktop
                                desk="^fg($F_FG)${name}^fg()"
                                ;;
                            u*)
                                # urgent desktop
                                desk="^fg($U_FG)${name}^fg()"
                                ;;
                        esac
                        wm_infos="${wm_infos}^ca(1, bspc desktop -f ${name})^fn($ICN)${desk}^fn()^ca()\n\n\n"
                        ;;
                esac
                shift
            done
            IFS=$NORMIFS
            ;;
    esac
    printf "\n^p1()\n${wm_infos}\n\n\n\n${net}\n\n${bat}\n\n${clk}\n\n"
done

