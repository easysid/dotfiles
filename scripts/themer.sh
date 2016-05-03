#!/bin/bash
#
# script to change theme by creating links from themes dir to proper palces.
#
# Monday, 14 December 2015 21:30 IST
#

export dotdir="$HOME/Workspace/dotfiles"
cd "$dotdir"

createlinks () {
    theme="config/themes/$1"
    themedir="$dotdir/$theme"
    err="\033[1;31m"
    rst="\033[0m"
    declare -a filelist=(
        "panel.sh"
        "lemonbar_panel.sh"
        "termcolors"
        "theme_config"
    )
    if [[ -d $theme ]]; then
        cd ${theme}
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
        cd "$dotdir/scripts"
        ln -svf "../$theme/panel.sh" .
        ln -svf "../$theme/lemonbar_panel.sh" .
        ln -svf "../$theme/theme_config" .
        ln -svf "../$theme/termcolors" .
        # if conkyrc files exist, link them to ~/Conky
        cd "$dotdir"
        find ${themedir} -type f -name '*conkyrc' -exec ln -svf {} "$HOME/Conky/" \;
        # change xcolors and update xrdb
        # sed -i "s%^#include.*%#include \"${themedir}/termcolors\"%" ~/.Xresources
        xrdb merge ~/.Xresources
    else
        echo -e "${err}Error:${rst} $theme does not exist."
        exit 101
    fi
}

if [[ $# -eq 0 ]]; then
    ls $dotdir/config/themes
    read -rp 'Enter the theme name: ' themename
    createlinks $themename
else
   createlinks $1
fi

