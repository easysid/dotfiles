#! /bin/sh

# a script to pop up whatever is sent to it. Uses lemonbar
# copied from z3bra's blog

. theme_config

X=1366
interval=3
h=30
y=20
pad=4

text="  %{c}${@}   "

# inner bar
w=$(txtw -f ${FONT1} "${text}" )
x=$((X-w-20))
g="${w}x${h}+${x}+${y}"

# outer bar (for border)
w0=$((w+2*pad))
h0=$((h+2*pad))
x0=$((x-pad))
y0=$((y-pad))
g0="${w0}x${h0}+${x0}+${y0}"

# draw outer bar first, followed by inner bar with text
sleep $interval | lemonbar -d -B '#90f0f0f0' -g "$g0" &
(echo $text; sleep $interval) | lemonbar -d -B "${BAR_BG}" -F "${BAR_FG}" \
                                -g "${g}" -f "${FONT1}"

