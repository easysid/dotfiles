#!/bin/sh
# Multiple Exit Script using Zenity for non GDM installs
# Requires zenity
#
######## This part is the Exit Type picker  ##########
title="EXIT"
exit_type=$(zenity  --width="200" --height="200" --text="What do you want to do?" \
--title="$title" --list --radiolist --column '' --column ''   \
    TRUE "Shutdown" \
    FALSE "Reboot" \
    FALSE "Logout" \
    | sed 's/ max//g')

######### This part takes the selection and applies it  #############
case "$exit_type" in
    Logout)
        bspc quit
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac

