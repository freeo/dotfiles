# output all echo statement to stdout AND to this logfile
log_file="/var/log/freeo/neog9.log"
exec > >(tee -a "$log_file") 2>&1

timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "$timestamp"

# check pre-conditions: used programs and files
if ! hash rg 2>/dev/null ; then
    echo "ripgrep isn't installed! exiting..."
    echo ""
    exit 1
fi

if ! hash pw-play 2>/dev/null ; then
    echo "OPTIONAL: pw-play not installed! Can't play status sound."
fi

sndfile="/usr/share/sounds/Yaru/stereo/power-plug.oga"
if [ ! -e $sndfile ]; then
   echo "optional sound file doesn't exist:"
   echo "$sndfile"
fi

sndfile="/usr/share/sounds/Yaru/stereo/power-unplug.oga"
if [ ! -e $sndfile ]; then
   echo "optional sound file doesn't exist:"
   echo "$sndfile"
fi

# start script

pw-play /usr/share/sounds/Yaru/stereo/power-plug.oga

start=$(date +%s%3N)  # Get the current time in milliseconds

# fastest wake up time, until xrandr reports the correct modes
xrandr --output DP-0 --mode 1024x768 --rate 60

timeout_duration=5

sleep 1 # skip first "on" cycle: xrandr doesn't show any modes after 0.5 secs until about 1.3 secs

iteration_counter=0

while true; do
  output=$(xrandr -q | sed -n '/DP-0/,/^DP-1/p')
  if echo "$output" | rg -q "5120x1440\s+"; then
    if echo "$output" | rg "5120x1440\s+" | rg -q "239.76"; then
      xrandr --output DP-0 --mode 5120x1440 --rate 239.76 --dpi 144
    elif echo "$output" | rg "5120x1440\s+" | rg -q "120.00"; then
      xrandr --output DP-0 --mode 5120x1440 --rate 120 --dpi 144
    fi
    xrandr --output DP-0 --brightness 1
    break
  fi

  # timeout as fallback
  current=$(date +%s%3N)  # Get the current time in milliseconds
  duration=$((current - start))  # Calculate the duration in milliseconds
  if [ $duration -ge $((timeout_duration * 1000)) ]; then
    echo "Timeout! Issue with xrandr output? "
    xrandr -q
    break
  fi

  ((iteration_counter++))
  sleep 0.05

done

xrandr -q | sed -n '/DP-0/,/^DP-1/p'

end=$(date +%s%3N)  # Get the current time in milliseconds
duration=$((end - start))  # Calculate the duration in milliseconds

echo "Iterations (0.05 seconds steps): $iteration_counter"
echo "TOTAL duration: $duration ms"

# try to time the sound exactly with the screen turning on
sleep 2.40

output=$(xrandr -q | sed -n '/DP-0 connected/,/^DP-1/p')
if echo "$output" | rg -q "\*"; then
    echo "xrandr mode set successfully!"
    # pw-play /usr/lib/libreoffice/share/gallery/sounds/apert.wav
    pw-play /usr/share/sounds/Yaru/stereo/power-plug.oga
    echo ""
    exit 0
fi

echo "xrandr mode unsuccessful..."
# pw-play /usr/lib/libreoffice/share/gallery/sounds/pluck.wav
pw-play /usr/share/sounds/Yaru/stereo/power-unplug.oga
echo ""
exit 1
