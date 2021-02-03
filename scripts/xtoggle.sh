#!/bin/bash
# Toggles between Acer ROG and external Toshiba monitor

# echo $(</home/freeo/.config/monitor.freeo)

export CFGFILE="/home/freeo/.config/monitor.freeo"
MONITOR=$(<$CFGFILE)
echo "CFG File:" $MONITOR

activateToshiba() {
    echo -n "TOSHIBA" > $CFGFILE
    export MONITOR=TOSHIBA
    xrandr \
    --dpi 108 \
    --output DP-1 --off \
    --output HDMI-1 --mode 1920x1080 --rate 60 --pos 0x0 --primary \
    --output DP-2 --off \
    --output DP-3 --off \
    --output None-1 --off 
    echo "Activated Toshiba"
}

activateROG() {
    echo -n "ROG" > $CFGFILE
    export MONITOR=ROG
    xrandr \
    --dpi 108 \
    --output DP-1 --mode 2560x1440 --rate 144 --pos 0x0 --primary \
    --output HDMI-1 --off \
    --output DP-2 --off \
    --output DP-3 --off \
    --output None-1 --off 
    echo "Activated ROG"
    echo $(<$CFGFILE)
    
}


if [ -z $MONITOR ]; then
    echo "First run: MONITOR wasn't set yet"
    activateROG
elif [ $MONITOR == "ROG" ]; then
    activateToshiba
elif [ $MONITOR == "TOSHIBA" ]; then
    activateROG
fi
