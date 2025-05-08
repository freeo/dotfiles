local microphone = {}

local awful = require("awful")
local beautiful = require("beautiful")

function microphone.Toggle()
	awful.spawn.with_shell(
		"MICSRC=$(pactl list short sources | rg alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input | cut -f 1 | xargs) && pactl set-source-mute $MICSRC toggle"
	)

	-- "MICSRC=$(pactl list short sources | rg jack_in | cut -c 1-2 | xargs) && pactl set-source-mute $MICSRC toggle")
end

function microphone.On()
	awful.spawn.with_shell(
		"MICSRC=$(pactl list short sources | rg alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input | cut -f 1 | xargs) && pactl set-source-mute $MICSRC 0"
	)
end

function microphone.Off()
	awful.spawn.with_shell(
		"MICSRC=$(pactl list short sources | rg alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input | cut -f 1 | xargs) && pactl set-source-mute $MICSRC 1"
	)
end

local naughty = require("naughty")

function run_once_substring(prg, pname)
    if not prg then
        do
            return nil
        end
    end
    if not pname then
        pname = prg
    end

    if not arg_string then
				-- naughty.notify({ text = "pname: " .. pname })
				-- naughty.notify({ text = "prg: " .. prg })
				-- rg -v rg: exlude the ripgrep command itself from its own output, otherwise it will always find a match, as the search string will always be found in the rg command
        awful.spawn.with_shell("ps aux -u $USER | rg -v rg | rg '" .. pname .. "' || (" .. prg .. ")")
    end
end

local script_path = awful.util.get_configuration_dir() ..  "widgets/microphone_toggle.sh"
local script_command = 'bash -c "' .. script_path .. '"'
-- naughty.notify({ text = "script_command: " ..script_command })
run_once_substring(script_command, "microphone_toggle.sh")


function mic_border_reset()
	local c = client.focus
	if c then
		c.border_color = "#7e5edc"
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
		local color_highlight_mic_on = "#DD00FF"
		c.border_color = color_highlight_mic_on
		beautiful.border_focus = color_highlight_mic_on
	end
end)

return microphone
