#!/bin/bash
# Multiple Exit Script using Zenity for non GDM installs
# Requires zenity 
# 
######## This part is the Exit Type picker  ##########

title="EXIT"
exit_type=`zenity  --width="200" --height="200" --text="What do you want to do?" \
--title="$title" --list --radiolist --column '' --column ''   \
    TRUE "Shutdown" \
    FALSE "Reboot" \
    FALSE "Logout" \
    | sed 's/ max//g' `



######### This part takes the selection and applies it!  #############
if [ "$exit_type" = "Logout" ]
then
        # Do logout here.
        openbox --exit

elif [ "$exit_type" = "Reboot" ]
then
        # Do Reboot here.
        systemctl reboot

elif [ "$exit_type" = "Shutdown" ]
then
        # Do Shutdown here.
        systemctl poweroff
else
        exit 0
fi
