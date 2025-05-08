#!/bin/bash

# mictoggle_script.sh watches for "change" events in pulseaudio event stream.
# Upon a valid change, it checks the state of pulseaudio source "jack_in" and emits the respective awesome signal via awesome-client
# Notes on the script:
# since "pactl subscribe" is a stream, there's two things to incorporate:
#   "--line-buffered" streams rg results, as rg never quits and therefore doesn't have an exit code
#   not having an exit code means you can't chain with &&
# tried multiple receiving programs, but so far only "read line" works as desired
# "read line" reads on stdin while rg is still running
echo "starting..."

pactl subscribe | rg --line-buffered "Event 'change' on source" | \
while read line ; do
  MICSRC=$(pactl list short sources | rg alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input | cut -f 1 | xargs) && echo $MICSRC
  MUTE_STATUS=$(pactl get-source-mute $MICSRC)
  if [[ $MUTE_STATUS = "Mute: yes" ]]; then
    awesome-client 'client.emit_signal("jack_source_off")'
  elif [[ $MUTE_STATUS = "Mute: no" ]]; then
    awesome-client 'client.emit_signal("jack_source_on")'
  fi
done
