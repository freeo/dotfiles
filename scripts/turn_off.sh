timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "$timestamp"

# xrandr --output DP-0 --off && sleep 15 && pw-play /usr/share/sounds/Yaru/stereo/power-unplug.oga
# xrandr --output DP-0 --off && sleep 15 && pw-play /usr/share/sounds/gnome/default/alerts/glass.ogg
echo "turn off!"
xrandr --output DP-0 --off &


# pw-play /usr/share/sounds/gnome/default/alerts/glass.ogg
pw-play /usr/share/sounds/Yaru/stereo/message.oga

echo "sleep 0.5..."
sleep 0.5

# MOUSE disable
echo "done turning off."
