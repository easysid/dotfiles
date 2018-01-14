#!/bin/bash

bar="██████"

declare -A colors
while read -r num hex; do
    colors[$num]="$hex"
done < <(awk '/^color[0-9]+/{gsub("color","",$1);gsub("#","",$3); print $1,$3}' ~/.config/termite/config)
# done < <( xrdb -query | grep -E color[0-9]+ | sed -re 's/.*color([0-9]+):/\1/g;s/#//g')

echo -e "\n\n\n\n"
for i in {0..7}; do echo -en "\e[$((30+$i))m ${colors[$i]} \e[0m"; done
echo
for i in {0..7}; do echo -en "\e[$((30+$i))m ${bar} \e[0m"; done
echo
for i in {8..15}; do echo -en "\e[1;$((22+$i))m ${bar} \e[0m"; done
echo
for i in {8..15}; do echo -en "\e[1;$((22+$i))m ${colors[$i]} \e[0m"; done
echo -e "\n\n\n\n"
