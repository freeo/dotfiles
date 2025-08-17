#!/bin/bash

eval "$(python ~/dotfiles/scripts/xrandr/detect.py | grep "^NEOG9=\|^TOSHIBA=\|^NEOG9_RESOLUTION=\|^TOSHIBA_RESOLUTION=\|^NEOG9_MAXRATE=\|^TOSHIBA_MAXRATE=")"

# provides:
# export TOSHIBA=HDMI-0
# export NEOG9=DP-0

# xrandr --output HDMI-A-0 --mode 5120x1440 --rate 59.98 --dpi 144 --pos 0x0 --output DisplayPort-0 --off
# toshiba
# xrandr --output HDMI-A-0 --off --output DisplayPort-0 --mode 1920x1080 --rate 60 --pos 5120x0 --dpi 96
# xrandr --output HDMI-A-0 --mode 5120x1440 --rate 59.98 --dpi 144 --pos 0x0 --output DisplayPort-0 --mode 1920x1080 --rate 60 --pos 5120x0 --dpi 96

# xrandr --listactivemonitors | grep $TOSHIBA >/dev/null && xrandr --output $TOSHIBA --off || xrandr --output $TOSHIBA --mode 1920x1080 --rate 60 --pos 5120x0 --dpi 96

case "$1" in
"toshiba")
	xrandr --output $TOSHIBA --mode $TOSHIBA_RESOLUTION --rate $TOSHIBA_MAXRATE --dpi 144 --pos 0x0 --output $NEOG9 --off
	;;
"neog9")
	xrandr --output $NEOG9 --mode $NEOG9_RESOLUTION --rate $NEOG9_MAXRATE --dpi 144 --pos 0x0 --output $TOSHIBA --off
	;;
esac
