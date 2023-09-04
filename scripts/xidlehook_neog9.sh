# https://gitlab.com/jD91mZM2/xidlehook
#
# sleep 15: let the monitor fully go into standby, before watching for activity. There seem to be some kind of "alive?"-pings as long as the monitor isn't in standby, which are interpreted as "user activity" by xidlehook. Sleep skips listening, until relevant.
#
# Executed by:
# /home/freeo/dotfiles/config/systemd/user/xidlehook.service -> /home/freeo/.config/systemd/user/xidlehook.service

xidlehook \
  --detect-sleep \
  --not-when-fullscreen \
  --timer 165 \
    'xrandr --output DP-0 --brightness .5' \
    'xrandr --output DP-0 --brightness 1' \
  --timer 15 \
    'xrandr --output DP-0 --off && sleep 15 && pw-play /usr/share/sounds/Yaru/stereo/power-unplug.oga' \
    'bash /home/freeo/dotfiles/scripts/neog9_ON.sh'
