#!/bin/bash
# Toggles between Acer ROG and external Toshiba monitor

# KNOWN ISSUE:
# if DP-x isn't found, xrandr will through a WARNING, but return statuscode 0,
# which isn't catched currently and therefore will end up writing the wrong
# variable to the cfg file.

export CFGFILE="/home/freeo/.config/monitor.freeo"
MONITOR=$(<$CFGFILE)
echo "CFG File:" $MONITOR

activateToshiba() {
    xrandr \
    --dpi 108 \
    --output DP-0 --off \
    --output HDMI-0 --mode 1920x1080 --rate 60 --pos 0x0 --primary
    postXrandr "TOSHIBA"
}

activateROG() {
    xrandr \
    --dpi 108 \
    --output DP-0 --mode 2560x1440 --rate 144 --pos 0x0 --primary \
    --output HDMI-0 --off
    postXrandr "ROG"
}

# $1 = ROG | TOSHIBA
postXrandr() {
    if [[ $? -eq 0 ]]; then
        echo -n $1 > $CFGFILE
        echo "Activated "$1
    else
        echo "Aborting - xrandr unsuccessful"
    fi
}


if [ -z $MONITOR ]; then
    echo "First run: MONITOR wasn't set yet"
    activateROG
elif [ $MONITOR == "ROG" ]; then
    activateToshiba
elif [ $MONITOR == "TOSHIBA" ]; then
    activateROG
fi
