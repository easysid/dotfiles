#! /bin/bash

# playlist popup for dzen2
# Friday, 04 March 2016 14:50 IST

songs=5
format="%position% [[%artist% - ]%title%]|[%file%]"
pattern=$(mpc current -f %position%)
LINES=$(( $songs*2 + 1 ))
WIDTH=280
. dzen_popup_config

# expand list if there aren't sufficient songs before current one
[[ $pattern -lt $songs ]] && songs=$(( $songs*2 - $pattern ))
(
echo "^fg($titlecol)Playlist^fg()"
mpc playlist -f "$format" | grep -$songs "\<$pattern\>" | while read -r position song; do
    if [[ $position -eq $pattern ]]; then
        echo "^fg($highlight)$PAD^ca(1, mpc play $position)$song^ca()$PAD"
        continue
    fi
    echo "$PAD^ca(1, mpc play $position)$song^ca()$PAD"
done
) | dzen2 -title-name "popup_playlist" -p "$TIME" -l "$LINES" -sa 'l' -m \
          -fn "$FONT" ${OPTIONS}

