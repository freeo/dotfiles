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
    --output DP-5 --mode 1920x1080 --rate 60 --pos 0x0 --primary
    postXrandr "TOSHIBA"
}

activateROG() {
    xrandr \
    --dpi 108 \
    --output DP-0 --mode 2560x1440 --rate 144 --pos 0x0 --primary \
    --output HDMI-0 --off
    postXrandr "ROG"
}


xrandrG9() {
echo "run"
xrandr \
    --dpi 108 \
    --output DP-0 --mode 5120x1440 --rate 120 --pos 0x0 --primary --scale 1.0x1.0 \
    --output DP-5 --off
echo $?
}

activateG9() {
    xrandrG9
    # sleep 1
    # xrandrG9
    postXrandr "G9"
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
    activateToshiba
elif [ $MONITOR == "G9" ]; then
    activateToshiba
elif [ $MONITOR == "TOSHIBA" ]; then
    activateG9
fi
