#! /bin/sh
# a script to pop up whatever is sent to it.
# taken from z3bra's blog
# Uses lemonbar fork with borders from github.com/dark-yux/bar
# Binary is ~/.local/bin/border-lemonbar
# Thursday, 04 January 2018 17:32 IST
#

bg='#E52c2c2c'
fg='#FFf0f0f0'
bo='#E5B1506A' # border color
font="sans:size=8"

X=1366
interval=3
h=30

text="${@}"
w=$(txtw -f "${font}" "$text")
x=$((X-w-20))
y=$h
g="${w}x${h}+${x}+${y}"

text="%{c}%{A:exit 0:}$text%{A}"
(echo $text; sleep $interval) | border-lemonbar -d \
        -B ${bg} -F ${fg} -R ${bo} -g ${g} -f ${font} -r 3 | sh

