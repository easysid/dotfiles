#!/bin/bash
#openbox pipe menu for system information
# easysid

echo "<openbox_pipe_menu>"

echo -e "<separator label='pid ----------------- conky         '/>"
pgrep -ax conky | sort -nr | awk '{
    sub("/home/siddharth","~",$4)
    gsub("_","__",$4)
    printf "<menu id=\"%s\" label=\"%-5s  %s\">\n",$1, $1, $4
    printf "<item label=\"kill\"> <action name =\"Execute\">\n"
    printf "<execute>kill %s</execute></action></item>\n",$1
    printf "</menu>\n"
    }'

echo "</openbox_pipe_menu>"
