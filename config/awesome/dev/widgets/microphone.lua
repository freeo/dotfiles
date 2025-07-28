local microphone = {}

local awful = require("awful")
local beautiful = require("beautiful")

function microphone.Toggle()
  awful.spawn.with_shell(
            "MICSRC=$(pactl list short sources | rg alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input | cut -f 1 | xargs) && pactl set-source-mute $MICSRC toggle")

        -- "MICSRC=$(pactl list short sources | rg jack_in | cut -c 1-2 | xargs) && pactl set-source-mute $MICSRC toggle")

end

function microphone.On()
  awful.spawn.with_shell(
            "MICSRC=$(pactl list short sources | rg alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input | cut -f 1 | xargs) && pactl set-source-mute $MICSRC 0")
end

function microphone.Off()
  awful.spawn.with_shell(
            "MICSRC=$(pactl list short sources | rg alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input | cut -f 1 | xargs) && pactl set-source-mute $MICSRC 1")
end

-- mictoggle_script watches for "change" events in pulseaudio event stream.
-- Upon a valid change, it checks the state of pulseaudio source "jack_in" and emits the respective awesome signal via awesome-client
-- Notes on the script:
-- since "pactl subscribe" is a stream, there's two things to incorporate:
--   "--line-buffered" streams rg results, as rg never quits and therefore doesn't have an exit code
--   not having an exit code means you can't chain with &&
-- tried multiple receiving programs, but so far only "read line" works as desired
-- "read line" reads on stdin while rg is still running
MICTOGGLE_SCRIPT = [=[
#!/bin/bash

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
]=]

awful.spawn.with_shell(MICTOGGLE_SCRIPT)

function mic_border_reset()
    local c = client.focus
    if c then
        c.border_color         = "#7e5edc"
        beautiful.border_focus = "#7e5edc"
    end
end


client.connect_signal("jack_source_off", function()
    mic_border_reset()
end)

client.connect_signal("jack_source_on", function()
    local c = client.focus
    if c then
        -- local color_highlight_mic_on = "#B200FF"
        -- local color_highlight_mic_on = "#DD00FF"
        local color_highlight_mic_on = "#00dd00"
        c.border_color               = color_highlight_mic_on
        beautiful.border_focus       = color_highlight_mic_on
    end
end)

return microphone
