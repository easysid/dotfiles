#! /bin/bash

# playlist popup for dzen2
# using the code by /u/Mr_asdf
# Thursday, 06 August 2015 13:33 IST

LINES=10
WIDTH=300
source $(dirname $0)/dzen_popup_config

lines=5
pos=$(mpc -f "%position%" | head -n 1)
first=$(( $pos - $lines ))
[[ $first -lt 1 ]] && first=1
(
echo "Playlist"
mpc playlist | grep -$lines "$(mpc current)" | while read -r song; do
echo "$PAD^ca(1, mpc play $first)$song^ca()$PAD"
(( first++ ))
done
) | dzen2 -title-name "popup_playlist" -p "$TIME" -l "$LINES" -sa 'l' -m \
          -fn "$FONT" ${OPTIONS}
