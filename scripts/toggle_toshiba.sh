log_file="/var/log/freeo/toggle_toshiba.log"
exec > >(tee -a "$log_file") 2>&1

timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo ""
echo "$timestamp"

function isG9on() {

	resolutions=(
		"Screen 0: minimum 8 x 8, current 5120 x 1440, maximum 32767 x 32767"
		"Screen 0: minimum 8 x 8, current 3840 x 1080, maximum 32767 x 32767"
	)

	# for debug:
	# xrandr -q | grep -q "Screen 0: minimum 8 x 8, current 3840 x 1080, maximum 32767 x 32767"

	# 1 = off, 0 = on, because of grep errorcode
	isG9on=1

	for r in "${resolutions[@]}"; do
		if xrandr -q | grep -q "$r"; then
			isG9on=0
			break
		fi
	done

	echo "isG9on: $isG9on"
	return $isG9on
}

function isG9off() {
	# xrandr -q --verbose | grep "DP-0 disconnected"
	xrandr -q | grep "Screen 0: minimum 8 x 8, current 8 x 8, maximum 32767 x 32767"
	r=$?
	echo isG9off: $r
	return $r
}

function unplug() {

	# wtf... it makes a screenshot...
	# flameshot full -c -p /home/freeo/wb/g9off
	awesome-client "write_last_tag()"
	xrandr --output DP-0 --off
	# echo "off"
	echo "turn it off!"
	pw-play /usr/share/sounds/Yaru/stereo/power-unplug.oga

}

xset -q | sed -n '/DPMS/,/$/p' && isG9on && awesome-client "write_last_tag()" && unplug || { isG9off && echo "turn it on!" && /home/freeo/dotfiles/scripts/neog9_ON.sh >/dev/null; }

# works, but refactored restoring the tag into neog9_ON.sh
# xset -q | sed -n '/DPMS/,/$/p' && isG9on && awesome-client "write_last_tag()" && unplug || { isG9off && echo "turn it on!" && /home/freeo/dotfiles/scripts/neog9_ON.sh > /dev/null && awesome-client "restore_last_tag()";}
