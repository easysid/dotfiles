#!/bin/sh
# shutdown dialog. Uses lemonbar

[ $(pgrep -cx turnoff.sh) -gt 1 ] && exit 101

pad='                 '

echo "%{c}%{A:systemctl poweroff:} Shutdown %{A} ${pad} %{A:kill -- -${$}:} Cancel %{A}" |
        lemonbar -d -p -g 'x200+0+280' -B '#9997544d' -F '#ffffffff' \
         -f '-xos4-terminus-bold-r-normal--24-240-72-72-c-120-iso10646-1' \
         | sh

