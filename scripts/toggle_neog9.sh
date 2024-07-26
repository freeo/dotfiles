log_file="/var/log/freeo/toggle_neog9.log"
exec > >(tee -a "$log_file") 2>&1

timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo ""
echo "$timestamp"

function isG9on () {
  # xrandr -q --verbose | grep "DP-0 connected"
  xrandr -q | grep "Screen 0: minimum 8 x 8, current 5120 x 1440, maximum 32767 x 32767"

  # xrandr -q | sed -n '/DP-0/,/^DP-1/p' | grep "*"
  # xrandr -q | sed -n '/DP-0/,/^DP-1/p'

  r=$?
  echo isG9on: $r
  return $r
}

function isG9off () {
  # xrandr -q --verbose | grep "DP-0 disconnected"
  xrandr -q | grep "Screen 0: minimum 8 x 8, current 8 x 8, maximum 32767 x 32767"
  r=$?
  echo isG9off: $r
  return $r
}

function unplug (){

  # wtf... it makes a screenshot...
  # flameshot full -c -p /home/freeo/wb/g9off
  awesome-client "write_last_tag()"
  xrandr --output DP-0 --off
  # echo "off"
  echo "turn it off!"
  pw-play /usr/share/sounds/Yaru/stereo/power-unplug.oga


  #
  # echo $(isG9on)
  # xrandr --listactivemonitors
  # xrandr -q | sed -n '/DP-0/,/^DP-1/p'
  # xrandr --output DP-0 --off; xset -q | sed -n '/DPMS/,/$/p'
  # inxi -aG
  # echo ""
  # echo "XDPYINFO BEGIN"
  # xdpyinfo
  # echo "XDPYINFO END"
  # echo ""
}

# isG9on && echo "unplug" || echo "plug in!"
# isG9on && unplug || /home/freeo/dotfiles/scripts/neog9_ON.sh > /dev/null
# xssstate -s


xset -q | sed -n '/DPMS/,/$/p' && isG9on && awesome-client "write_last_tag()" && unplug || { isG9off && echo "turn it on!" && /home/freeo/dotfiles/scripts/neog9_ON.sh > /dev/null;}
#
# works, but refactored restoring the tag into neog9_ON.sh
# xset -q | sed -n '/DPMS/,/$/p' && isG9on && awesome-client "write_last_tag()" && unplug || { isG9off && echo "turn it on!" && /home/freeo/dotfiles/scripts/neog9_ON.sh > /dev/null && awesome-client "restore_last_tag()";}


# xset -q | sed -n '/DPMS/,/$/p' && isG9on && unplug || { isG9off && echo "turn it on!" && /home/freeo/dotfiles/scripts/neog9_ON.sh > /dev/null;}

# xrandr --listactivemonitors | grep DP-0 >/dev/null && unplug || echo "on" && /home/freeo/dotfiles/scripts/neog9_ON.sh > /dev/null




# xrandr --listactivemonitors | grep DP-0 >/dev/null && { xrandr --output DP-0 --off; pw-play /usr/share/sounds/Yaru/stereo/power-unplug.oga;} || /home/freeo/dotfiles/scripts/neog9_ON.sh

# xrandr --listactivemonitors | grep DP-0 >/dev/null && { xrandr --output DP-0 --off; pw-play /usr/share/sounds/Yaru/stereo/power-unplug.oga;} || /home/freeo/dotfiles/scripts/neog9_ON.sh
