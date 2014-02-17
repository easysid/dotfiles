#!/bin/bash
#openbox pipe menu for system information
# easysid 

echo "<openbox_pipe_menu>"

#System info

echo "<separator label='SYSTEM'/>"

echo "<item label=\"Host:     $(uname -n)\"/>"
echo "<item label=\"Kernel:   $(uname -r)\"/>"
echo "<item label=\"Packages: $(pacman -Q | wc -l)\"/>"
awk '/upgraded/ {line=$0;} END { $0=line; gsub(/[\[\]]/,"",$0); printf "<item label=\"Upgraded: %s %s\"/>\n",$1,$2;}' /var/log/pacman.log

# CPU and RAM info

echo "<separator label='CPU - RAM'/>"

#CPU
CPU=$(grep -m 1 'model name' /proc/cpuinfo | sed 's/.*://;s/      //')
MHZ=$(grep -m 1 'MHz' /proc/cpuinfo | sed 's/.*://')
echo "<item label=\"CPU: $CPU\"/>"
echo "<item label=\"CPU @$MHZ MHz\"/>"
#RAM
free -mh | awk '/+ buffers/{printf "<item label=\"RAM:  %s of 2.9G used (%s free)\"/>\n", $3, $4}'

# Temperatures

echo "<separator label='TEMPS'/>"
sensors | awk '/Core/{printf "<item label=\"%s %s %s\"/>\n",$1, $2, $3}'
echo "<item label=\"Radeon: $(sensors radeon-pci-0100 | grep temp1 | cut -c15-22)\"/>"

# Disks

echo "<separator label='Device   Size  Used  Free  Use%  Mounted on'/>"
#df -h | awk '/^\/dev\/s/{printf "<item label=\"%-10s %-5s %-5s %-5s %s   %s\"/>\n", $1, $2, $3, $4, $5, $6}'
df -h | awk '/^\/dev\/s/{printf "<item label=\"%-10s %-5s %-5s %-5s %s   %s\"/>\n", $1, $2, $3, $4, $5, $6}'
echo "</openbox_pipe_menu>"
