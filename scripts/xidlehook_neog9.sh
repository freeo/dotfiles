# https://gitlab.com/jD91mZM2/xidlehook
#
# sleep 15: let the monitor fully go into standby, before watching for activity. There seem to be some kind of "alive?"-pings as long as the monitor isn't in standby, which are interpreted as "user activity" by xidlehook. Sleep skips listening, until relevant.
#
# Executed by:
# /home/freeo/dotfiles/config/systemd/user/xidlehook.service -> /home/freeo/.config/systemd/user/xidlehook.service

log_file="/var/log/freeo/xidlehook.log"
exec > >(tee -a "$log_file") 2>&1

log_cmd() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $@"
    "$@"
}
# Use log_cmd for each command you want to log
# log_cmd echo "Hello, World!"
# log_cmd pwd

# Format the PS4 prompt to include a timestamp
# export PS4='+ $(date "+%Y-%m-%d %H:%M:%S") '
# Enable command tracing
# set -x

timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "$timestamp"

## onoff: enable or disable
MOUSE() {
  local onoff="$1"
  # Get the list of input devices
  xinput_list=$(xinput list)
  # Extract the "Virtual core pointer" block and discard the rest
  # pointer_devices=$(echo "$xinput_list" | sed -n '/Virtual core pointer/,/Virtual core keyboard/p' | sed '$d')
  # Extract the IDs of all devices
  # device_ids=$(echo "$pointer_devices" | rg -i "cooler master.*mm" | grep -oP 'id=\K\d+')
  device_ids=$(echo "$xinput_list" | rg -i "cooler master.*mm" | grep -oP 'id=\K\d+')
  # echo $device_ids
  # echo ""
  # Disable each pointer device by ID
  # echo "Disable each pointer device by ID:"
  # echo $onoff
  # for id in $device_ids; do
  # ZSH style loop! device_ids output is different from bash
  log_cmd echo "SHELL: $SHELL"
  for id in ${(f)device_ids}; do
      xinput $onoff $id
      # if [[ -z $ERRORCODE ]]; then
      #   echo "$onoff device with ID: $id"
      # else
      #   echo "error: $onoff device with ID: $id"
      #   echo $xinput_list | rg $id
      # fi
  done
}


function TURN_OFF {
  # xrandr --output DP-0 --off && sleep 15 && pw-play /usr/share/sounds/Yaru/stereo/power-unplug.oga
  # xrandr --output DP-0 --off && sleep 15 && pw-play /usr/share/sounds/gnome/default/alerts/glass.ogg
  # log_cmd echo "turn off!"
  echo ""
  log_cmd echo "turn  off:"
  awesome-client "write_last_tag()"
  # MOUSE disable &
  MOUSE disable
  # sleep 2
  # pw-play /usr/share/sounds/Yaru/stereo/message.oga
  pw-play /usr/share/sounds/Yaru/stereo/power-unplug.oga

  date +%s > /tmp/xidle_timestamp
  echo "OFF XIDLE_TIMESTAMP:"
  cat /tmp/xidle_timestamp
  date +"%Y-%m-%d %H:%M:%S"

  xrandr --output DP-0 --off
  # echo "sleep..."
  # pw-play /usr/share/sounds/gnome/default/alerts/glass.ogg

  # echo "last tags:"
  # cat /tmp/awesomewm-last-selected-tags

  # XIDLE_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  # export XIDLE_TIMESTAMP=$(date +%s)
  echo "done turning off."
  # log_cmd echo "done turning off."
  # IMPORTANT: Prevent xrandr off from triggering the xidlehook-"on" signal
  # sleep 2
}

function TURN_ON {
  echo ""
  log_cmd echo "hmm, turn on?"
  echo "ON XIDLE_TIMESTAMP:"
  XIDLE_TIMESTAMP=$(cat /tmp/xidle_timestamp)
  echo $XIDLE_TIMESTAMP
  time_difference=$(($(date +%s) - XIDLE_TIMESTAMP ))
  # Check if the timestamp was within the last 5 seconds
  echo "time_difference:" $time_difference
  if [ $time_difference -le 5 ]; then
    echo "do nothing."
    return
  else
    log_cmd echo "turn on!"
    pw-play /usr/share/sounds/Yaru/stereo/bell.oga
    bash /home/freeo/dotfiles/scripts/neog9_ON.sh
    MOUSE enable

    # awesome-client "restore_last_tag()"
    log_cmd echo "done turning on."
  fi
}

export -f MOUSE
export -f TURN_OFF
export -f TURN_ON
export -f log_cmd


  # 'date +%H:%M:%S; bash /home/freeo/dotfiles/scripts/turn_off.sh' \
  # 'date +%H:%M:%S; bash /home/freeo/dotfiles/scripts/neog9_ON.sh'

# 'echo "xidlehook off"; TURN_OFF' \
# 'echo "xidlehook on"; TURN_ON'
#
  # --timer 10 \
  #   'xrandr --output DP-0 --brightness .5' \
  #   'xrandr --output DP-0 --brightness 1' \

  # --timer 15 \
  #   'xrandr --output DP-0 --brightness .5 && sleep 15' \
  #   'xrandr --output DP-0 --brightness 1 && sleep 15' \

xidlehook \
  --detect-sleep \
  --not-when-fullscreen \
  --timer 180 \
    'TURN_OFF ' \
    'TURN_ON '


# xidlehook \
#   --detect-sleep \
#   --not-when-fullscreen \
#   --timer 10 \
#   '/home/freeo/dotfiles/scripts/turn_off.sh' \
#   '/home/freeo/dotfiles/scripts/neog9_ON.sh'

# xidlehook \
#   --detect-sleep \
#   --not-when-fullscreen \
#   --timer 5 \
#   'echo "FUCK OFF!"' \
#   'echo "SHIT ON!"'
