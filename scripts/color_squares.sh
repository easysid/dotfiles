#!/bin/bash
#
# ANSI color scheme script by pfh
#
# Initializing mod by lolilolicon from Archlinux
#

f=3 b=4
for j in f b; do
  for i in {1..6}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
bld=$'\e[1m'
rst=$'\e[0m'
inv=$'\e[7m'
echo -e '\n\n'
cat << EOF

        ${f1}████  ${f2}████  ${f3}████  ${f4}████  ${f5}████  ${f6}████
${bld}\
        ${f1}████  ${f2}████  ${f3}████  ${f4}████  ${f5}████  ${f6}████
${rst}

EOF
echo
