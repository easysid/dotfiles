#!/bin/sh
# shutdown dialog. Uses lemonbar-xft

[ $(pgrep -cx turnoff.sh) -gt 1 ] && exit 101

pad='                                   '

echo "%{c}%{A:systemctl poweroff:} Shutdown %{A} ${pad} %{A:kill -- -${$}:} Cancel %{A}" |
        xft-lemonbar -d -p -g 'x200+0+280' -B '#9997544d' -F '#ffffffff' \
         -f 'sans:size=20' \
         | sh

