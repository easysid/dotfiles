#! /bin/bash

# playlist popup for dzen2
# Thursday, 06 August 2015 13:33 IST

lines=5
format="%position% [[%artist% - ]%title%]|[%file%]"
pattern=$(mpc current -f %position%)
LINES=$(( $lines*2 + 1 ))
WIDTH=280

source $(dirname $0)/dzen_popup_config
(
echo "^fg($titlecol)Playlist^fg()"
mpc playlist -f "$format" | grep -$lines "$pattern" | while read -r position song; do
    if [[ $position -eq $pattern ]]; then
        echo "^fg($highlight)$PAD^ca(1, mpc play $position)$song^ca()$PAD"
        continue
    fi
    echo "$PAD^ca(1, mpc play $position)$song^ca()$PAD"
done
) | dzen2 -title-name "popup_playlist" -p "$TIME" -l "$LINES" -sa 'l' -m \
          -fn "$FONT" ${OPTIONS}

