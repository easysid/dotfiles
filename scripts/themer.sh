#!/bin/bash
#
# script to change theme by creating links from themes dir to proper palces.
#
# Monday, 14 December 2015 21:30 IST
#

createlinks () {
    themedir="$HOME/.config/themes/$1"
    err="\033[1;31m"
    rst="\033[0m"
    declare -a filelist=(
        "panel.sh"
        "lemonbar_panel.sh"
        "termcolors"
        "theme_config"
    )
    if [[ -d $themedir ]]; then
        cd ${themedir}
        for i in "${filelist[@]}"; do
            if [[ -f $i ]]; then
                echo -e "$i exists"
            else
                echo -e "${err}Error:${rst} $i not found"
                echo -e "${err}Error:${rst} $1 is not a valid theme."
                exit 101
            fi
        done
        # Now create links
        echo
        ln -svf "$themedir/panel.sh" "$HOME/.scripts/"
        ln -svf "$themedir/lemonbar_panel.sh" "$HOME/.scripts/"
        ln -svf "$themedir/theme_config" "$HOME/.scripts/"
        # if conkyrc files exist, link them to ~/Conky
        find ${themedir} -type f -name '*conkyrc' -exec ln -svf {} "$HOME/Conky/" \;
        # change xcolors and update xrdb
        sed -i "s%^#include.*%#include \"${themedir}/termcolors\"%" ~/.Xresources
        xrdb merge ~/.Xresources
    else
        echo -e "${err}Error:${rst} $themedir does not exist."
        exit 101
    fi
}

if [[ $# -eq 0 ]]; then
    ls $HOME/.config/themes
    read -rp 'Enter the theme name: ' theme
    createlinks $theme
else
   createlinks $1
fi

