local microphone = {}

local awful = require("awful")
local beautiful = require("beautiful")

-- Global microphone state tracking
microphone.state = {
	is_on = false,
	last_updated = 0,
	initialized = false
}

-- Initialize actual microphone state on module load
local function init_mic_state()
	awful.spawn.easy_async_with_shell(
		"MICSRC=$(pactl list short sources | rg alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input | cut -f 1 | xargs) && pactl get-source-mute $MICSRC",
		function(stdout, stderr, reason, exit_code)
			if exit_code == 0 and stdout then
				local is_muted = stdout:match("Mute: yes")
				microphone.state.is_on = not is_muted
				microphone.state.last_updated = os.time()
				microphone.state.initialized = true
				
				-- Emit signal based on actual state
				if microphone.state.is_on then
					awesome.emit_signal("microphone_state_initialized", true)
				end
			end
		end
	)
end

-- Run initialization
init_mic_state()

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
	-- Immediately update state (signal will confirm it later)
	microphone.state.is_on = true
	microphone.state.last_updated = os.time()
end

function microphone.Off()
	awful.spawn.with_shell(
		"MICSRC=$(pactl list short sources | rg alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input | cut -f 1 | xargs) && pactl set-source-mute $MICSRC 1"
	)
	-- Immediately update state (signal will confirm it later)
	microphone.state.is_on = false
	microphone.state.last_updated = os.time()
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

local script_path = awful.util.get_configuration_dir() .. "widgets/microphone_toggle.sh"
local script_command = 'bash -c "' .. script_path .. '"'
-- naughty.notify({ text = "script_command: " ..script_command })
run_once_substring(script_command, "microphone_toggle.sh")

function mic_border_reset()
	local c = client.focus
	if c then
		c.border_color = beautiful.border_focus
		-- No need to set beautiful.border_focus since it's already the theme value
		c.tasklist_bg_focus = beautiful.border_focus
	end
end

client.connect_signal("jack_source_off", function()
	microphone.state.is_on = false
	microphone.state.last_updated = os.time()
	mic_border_reset()
end)

client.connect_signal("jack_source_on", function()
	microphone.state.is_on = true
	microphone.state.last_updated = os.time()
	
	-- Update ALL visible clients' borders when mic turns on
	for s in screen do
		for _, c in ipairs(s.clients) do
			if client.focus == c then
				-- Focused client gets green
				c.border_color = beautiful.color_highlight_mic_on or "#00DD00"
			else
				-- Unfocused clients also get green (optional - you can keep them normal)
				-- c.border_color = beautiful.color_highlight_mic_on or "#00DD00"
			end
		end
	end
	
	-- Also update tasklist
	local c = client.focus
	if c then
		c.tasklist_bg_focus = beautiful.color_highlight_mic_on
	end
end)

return microphone
