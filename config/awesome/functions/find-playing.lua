-- ./functions/find-playing.lua

local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")

local M = {}

-- DEBUG MODE - Set to true to enable debug notifications
local DEBUG_MODE = true

-- Debug function to show what's happening
local function debug_notify(title, text)
	if DEBUG_MODE then
		naughty.notify({
			title = "DEBUG: " .. title,
			text = text,
			timeout = 8,
			width = 500,
			position = "top_right",
		})
	end
end

-- Debug function to log to file (always logs regardless of DEBUG_MODE)
local function debug_log(message)
	local log_file = io.open("/tmp/awesomewm_audio_debug.log", "a")
	if log_file then
		log_file:write(os.date("[%Y-%m-%d %H:%M:%S] ") .. message .. "\n")
		log_file:close()
	end
end

-- Function to show debug info and log it
local function debug_info(title, text)
	local full_message = title .. ": " .. text
	debug_log(full_message)
	debug_notify(title, text)
end

-- Simplified function to check if a command exists by trying to run it with --version or --help
local function check_command_exists(command, callback)
	debug_info("CHECKING_CMD", "Checking if " .. command .. " exists by testing it directly")

	-- Try to run the command with --version first, then --help if that fails
	spawn_with_debug(command .. " --version", function(stdout, stderr, exitreason, exitcode)
		if exitcode == 0 then
			debug_info("CMD_EXISTS", command .. " exists (--version worked)")
			callback(true)
		else
			-- Try --help as fallback
			spawn_with_debug(command .. " --help", function(stdout2, stderr2, exitreason2, exitcode2)
				if exitcode2 == 0 then
					debug_info("CMD_EXISTS", command .. " exists (--help worked)")
					callback(true)
				else
					debug_info("CMD_NOT_EXISTS", command .. " does not exist or is not working")
					callback(false)
				end
			end, 2)
		end
	end, 2)
end

-- Enhanced async spawn wrapper with timeout and better error handling
local function spawn_with_debug(command, callback, timeout_seconds)
	timeout_seconds = timeout_seconds or 10

	debug_info("SPAWN_START", "Starting command: " .. command)

	local timer = gears.timer({
		timeout = timeout_seconds,
		single_shot = true,
		callback = function()
			debug_info("SPAWN_TIMEOUT", "Command timed out after " .. timeout_seconds .. " seconds: " .. command)
			naughty.notify({
				title = "Command Timeout",
				text = "Command timed out: " .. command,
				timeout = 5,
			})
		end,
	})

	timer:start()

	awful.spawn.easy_async(command, function(stdout, stderr, exitreason, exitcode)
		timer:stop()

		debug_info(
			"SPAWN_COMPLETE",
			"Command: "
				.. command
				.. "\n"
				.. "Exit code: "
				.. tostring(exitcode)
				.. "\n"
				.. "Exit reason: "
				.. tostring(exitreason)
				.. "\n"
				.. "Stdout length: "
				.. tostring(#(stdout or ""))
				.. "\n"
				.. "Stderr: "
				.. (stderr or "none")
		)

		if callback then
			callback(stdout, stderr, exitreason, exitcode)
		end
	end)
end

-- Function to find clients playing audio using PipeWire native commands
local function find_audio_clients_pipewire()
	debug_info("PIPEWIRE_START", "Starting PipeWire audio detection")

	spawn_with_debug("pw-cli list-objects", function(stdout, stderr, exitreason, exitcode)
		debug_info(
			"pw-cli result",
			"Exit code: "
				.. tostring(exitcode)
				.. ", Stdout length: "
				.. tostring(#stdout)
				.. ", Stderr: "
				.. (stderr or "none")
		)

		local audio_clients = {}
		local current_id = nil
		local current_pid = nil
		local current_app = nil
		local current_state = nil
		local current_media_class = nil
		local in_props = false

		if exitcode ~= 0 then
			debug_info("ERROR", "pw-cli failed with exit code " .. tostring(exitcode) .. ", stderr: " .. (stderr or ""))
			naughty.notify({
				title = "Error",
				text = "pw-cli failed with exit code " .. tostring(exitcode) .. "\n" .. (stderr or ""),
				timeout = 5,
			})
			return
		end

		debug_info("PARSING", "Starting to parse pw-cli output")
		local line_count = 0

		for line in stdout:gmatch("[^\r\n]+") do
			line_count = line_count + 1
			line = line:gsub("^%s+", "") -- trim leading whitespace

			-- Look for object IDs
			if line:match("^id %d+,") then
				current_id = line:match("^id (%d+),")
				current_pid = nil
				current_app = nil
				current_state = nil
				current_media_class = nil
				in_props = false
				debug_info("FOUND_ID", "Found object ID: " .. (current_id or "nil"))
			elseif line:match("^%s*type PipeWire:Interface:Node") then
				debug_info("NODE_TYPE", "Found Node type for ID: " .. (current_id or "nil"))
				-- This is a node object, continue processing
			elseif line:match("^%s*props:") then
				in_props = true
				debug_info("PROPS_START", "Started props section for ID: " .. (current_id or "nil"))
			elseif in_props and line:match("media%.class") then
				current_media_class = line:match('"([^"]+)"')
				debug_info(
					"MEDIA_CLASS",
					"ID " .. (current_id or "nil") .. " has media.class: " .. (current_media_class or "nil")
				)
			elseif in_props and line:match("application%.process%.id") then
				current_pid = line:match('"([^"]+)"')
				debug_info("PID", "ID " .. (current_id or "nil") .. " has PID: " .. (current_pid or "nil"))
			elseif in_props and line:match("application%.name") then
				current_app = line:match('"([^"]+)"')
				debug_info("APP_NAME", "ID " .. (current_id or "nil") .. " has app name: " .. (current_app or "nil"))
			elseif in_props and line:match("node%.state") then
				current_state = line:match('"([^"]+)"')
				debug_info("STATE", "ID " .. (current_id or "nil") .. " has state: " .. (current_state or "nil"))
			elseif line:match("^id %d+,") or line:match("^%*") then
				-- End of current object, process if we have what we need
				if
					current_pid
					and current_state == "running"
					and current_media_class
					and current_media_class:match("Stream/Output/Audio")
				then
					debug_info(
						"MATCH_FOUND",
						"Found matching stream - PID: "
							.. current_pid
							.. ", App: "
							.. (current_app or "unknown")
							.. ", State: "
							.. current_state
					)

					local client_found = false
					for _, c in ipairs(client.get()) do
						if c.pid and tostring(c.pid) == current_pid then
							table.insert(audio_clients, {
								client = c,
								app_name = current_app or "Unknown",
								node_id = current_id,
								tag = c.first_tag and c.first_tag.name or "Unknown",
								screen = c.screen and c.screen.index or 1,
								pid = current_pid,
							})
							client_found = true
							debug_info(
								"CLIENT_MATCHED",
								"Matched client: " .. (c.name or "no name") .. " with PID: " .. current_pid
							)
							break
						end
					end

					if not client_found then
						debug_info("CLIENT_NOT_FOUND", "No AwesomeWM client found for PID: " .. current_pid)
					end
				end
				in_props = false
			end
		end

		-- Process the last object if needed
		if
			current_pid
			and current_state == "running"
			and current_media_class
			and current_media_class:match("Stream/Output/Audio")
		then
			debug_info(
				"LAST_MATCH",
				"Processing last object - PID: " .. current_pid .. ", App: " .. (current_app or "unknown")
			)

			local client_found = false
			for _, c in ipairs(client.get()) do
				if c.pid and tostring(c.pid) == current_pid then
					table.insert(audio_clients, {
						client = c,
						app_name = current_app or "Unknown",
						node_id = current_id,
						tag = c.first_tag and c.first_tag.name or "Unknown",
						screen = c.screen and c.screen.index or 1,
						pid = current_pid,
					})
					client_found = true
					debug_info("LAST_CLIENT_MATCHED", "Matched last client: " .. (c.name or "no name"))
					break
				end
			end

			if not client_found then
				debug_info("LAST_CLIENT_NOT_FOUND", "No AwesomeWM client found for last PID: " .. current_pid)
			end
		end

		debug_info(
			"PARSING_COMPLETE",
			"Processed " .. line_count .. " lines, found " .. #audio_clients .. " audio clients"
		)

		-- Display results
		if #audio_clients > 0 then
			local message = "🔊 Active Audio Sources (PipeWire):\n\n"
			for i, info in ipairs(audio_clients) do
				message = message
					.. string.format(
						"%d. %s (PID: %s)\n   Tag: %s (Screen %d)\n   Title: %s\n\n",
						i,
						info.app_name,
						info.pid,
						info.tag,
						info.screen,
						info.client.name or "No title"
					)
			end

			-- Show notification with options to focus clients
			local notification = naughty.notify({
				title = "Audio Playing Clients",
				text = message,
				timeout = 15,
				width = 450,
				actions = {},
			})

			-- Add action buttons for each client
			for i, info in ipairs(audio_clients) do
				local action = naughty.action({
					name = "Focus " .. i,
					icon = nil,
				})

				action:connect_signal("invoked", function()
					-- Switch to the client's tag and focus it
					if info.client.first_tag then
						info.client.first_tag:view_only()
					end
					client.focus = info.client
					info.client:raise()
					notification:destroy()
				end)

				notification:add_action(action)
			end
		else
			debug_info("NO_CLIENTS", "No audio clients found")
			naughty.notify({
				title = "No Audio Playing",
				text = "No clients are currently playing audio\n(or clients not found by PID)",
				timeout = 3,
			})
		end
	end, 15) -- 15 second timeout for pw-cli
end

-- Alternative using wpctl (WirePlumber control utility)
local function find_audio_clients_wpctl()
	debug_info("WPCTL_START", "Starting wpctl audio detection")

	spawn_with_debug("wpctl status", function(stdout, stderr, exitreason, exitcode)
		if exitcode ~= 0 then
			debug_info("WPCTL_FAILED", "wpctl failed with exit code " .. tostring(exitcode))
			naughty.notify({
				title = "Error",
				text = "wpctl failed, trying pw-cli...",
				timeout = 3,
			})
			find_audio_clients_pipewire()
			return
		end

		debug_info("WPCTL_SUCCESS", "wpctl succeeded, parsing output")

		-- Parse wpctl output to find active streams
		local audio_clients = {}
		local in_streams = false

		for line in stdout:gmatch("[^\r\n]+") do
			if line:match("Audio") then
				in_streams = false
			elseif line:match("Streams:") then
				in_streams = true
				debug_info("WPCTL_STREAMS", "Found Streams section")
			elseif in_streams and line:match("RUNNING") then
				debug_info("WPCTL_RUNNING", "Found running stream: " .. line)
				-- Extract stream info from wpctl output
				local stream_info = line:match("(%d+)%.%s+(.+)%s+%[RUNNING%]")
				if stream_info then
					local stream_id, stream_name = stream_info:match("(%d+)%.%s+(.+)")
					if stream_id and stream_name then
						debug_info("WPCTL_STREAM_INFO", "Stream ID: " .. stream_id .. ", Name: " .. stream_name)

						-- Get more details about this stream
						spawn_with_debug("pw-cli info " .. stream_id, function(info_stdout)
							local pid = info_stdout:match('application%.process%.id = "([^"]+)"')
							local app_name = info_stdout:match('application%.name = "([^"]+)"')

							debug_info(
								"WPCTL_STREAM_DETAILS",
								"PID: " .. (pid or "none") .. ", App: " .. (app_name or "none")
							)

							if pid then
								for _, c in ipairs(client.get()) do
									if c.pid and tostring(c.pid) == pid then
										table.insert(audio_clients, {
											client = c,
											app_name = app_name or "Unknown",
											stream_id = stream_id,
											tag = c.first_tag and c.first_tag.name or "Unknown",
											screen = c.screen and c.screen.index or 1,
											pid = pid,
										})
										debug_info("WPCTL_CLIENT_MATCHED", "Matched client for PID: " .. pid)
										break
									end
								end
							end
						end, 10)
					end
				end
			end
		end

		-- If no results, fallback to pw-cli
		gears
			.timer({
				timeout = 2,
				single_shot = true,
				callback = function()
					if #audio_clients == 0 then
						debug_info("WPCTL_NO_RESULTS", "No results from wpctl, falling back to pw-cli")
						find_audio_clients_pipewire()
					end
				end,
			})
			:start()
	end, 10)
end

-- Fallback to PulseAudio compatibility layer if PipeWire native doesn't work
local function find_audio_clients_pactl()
	debug_info("PACTL_START", "Starting pactl audio detection")

	spawn_with_debug("pactl list sink-inputs", function(stdout, stderr, exitreason, exitcode)
		local audio_clients = {}
		local current_sink = nil
		local current_pid = nil
		local current_app = nil
		local current_state = nil

		if exitcode ~= 0 then
			debug_info("PACTL_FAILED", "pactl failed with exit code " .. tostring(exitcode))
			naughty.notify({
				title = "Error",
				text = "pactl failed with exit code " .. tostring(exitcode) .. "\n" .. (stderr or ""),
				timeout = 5,
			})
			return
		end

		debug_info("PACTL_SUCCESS", "pactl succeeded, parsing output")

		for line in stdout:gmatch("[^\r\n]+") do
			line = line:gsub("^%s+", "") -- trim leading whitespace

			if line:match("Sink Input #") then
				current_sink = line:match("#(%d+)")
				current_pid = nil
				current_app = nil
				current_state = nil
				debug_info("PACTL_SINK", "Found sink input: " .. (current_sink or "none"))
			elseif line:match("application%.process%.id") then
				current_pid = line:match('"([^"]+)"')
				debug_info("PACTL_PID", "Found PID: " .. (current_pid or "none"))
			elseif line:match("application%.name") then
				current_app = line:match('"([^"]+)"')
				debug_info("PACTL_APP", "Found app: " .. (current_app or "none"))
			elseif line:match("State:") then
				current_state = line:match("State:%s*(%w+)")
				debug_info("PACTL_STATE", "Found state: " .. (current_state or "none"))
			end

			if current_pid and current_state == "RUNNING" then
				debug_info("PACTL_MATCH_ATTEMPT", "Trying to match PID: " .. current_pid)

				for _, c in ipairs(client.get()) do
					if c.pid and tostring(c.pid) == current_pid then
						table.insert(audio_clients, {
							client = c,
							app_name = current_app or "Unknown",
							sink_id = current_sink,
							tag = c.first_tag and c.first_tag.name or "Unknown",
							screen = c.screen and c.screen.index or 1,
							pid = current_pid,
						})
						debug_info("PACTL_CLIENT_MATCHED", "Matched client for PID: " .. current_pid)
						break
					end
				end
			end
		end

		debug_info("PACTL_COMPLETE", "Found " .. #audio_clients .. " audio clients")

		-- Display results
		if #audio_clients > 0 then
			local message = "🔊 Active Audio Sources (PulseAudio compat):\n\n"
			for i, info in ipairs(audio_clients) do
				message = message
					.. string.format(
						"%d. %s (PID: %s)\n   Tag: %s (Screen %d)\n   Title: %s\n\n",
						i,
						info.app_name,
						info.pid,
						info.tag,
						info.screen,
						info.client.name or "No title"
					)
			end

			local notification = naughty.notify({
				title = "Audio Playing Clients",
				text = message,
				timeout = 15,
				width = 450,
				actions = {},
			})

			for i, info in ipairs(audio_clients) do
				local action = naughty.action({
					name = "Focus " .. i,
					icon = nil,
				})

				action:connect_signal("invoked", function()
					if info.client.first_tag then
						info.client.first_tag:view_only()
					end
					client.focus = info.client
					info.client:raise()
					notification:destroy()
				end)

				notification:add_action(action)
			end
		else
			naughty.notify({
				title = "No Audio Playing",
				text = "No clients are currently playing audio",
				timeout = 3,
			})
		end
	end, 10)
end

-- Simplified function to check if a command exists by trying to run it with --version or --help
local function check_command_exists(command, callback)
	debug_info("CHECKING_CMD", "Checking if " .. command .. " exists by testing it directly")

	-- Try to run the command with --version first, then --help if that fails
	spawn_with_debug(command .. " --version", function(stdout, stderr, exitreason, exitcode)
		if exitcode == 0 then
			debug_info("CMD_EXISTS", command .. " exists (--version worked)")
			callback(true)
		else
			-- Try --help as fallback
			spawn_with_debug(command .. " --help", function(stdout2, stderr2, exitreason2, exitcode2)
				if exitcode2 == 0 then
					debug_info("CMD_EXISTS", command .. " exists (--help worked)")
					callback(true)
				else
					debug_info("CMD_NOT_EXISTS", command .. " does not exist or is not working")
					callback(false)
				end
			end, 2)
		end
	end, 2)
end

-- Main function - prioritize PipeWire native tools
function M.find_playing_audio()
	debug_info("MAIN_START", "Starting audio detection")

	-- Try PipeWire native commands first
	debug_info("CHECKING_PW_CLI", "Checking if pw-cli is available")

	check_command_exists("pw-cli", function(pw_cli_exists)
		if pw_cli_exists then
			debug_info("USING_PW_CLI", "pw-cli found, using PipeWire native detection")
			find_audio_clients_pipewire()
		else
			debug_info("FALLBACK_WPCTL", "pw-cli not found, trying wpctl")

			-- Try wpctl as alternative
			check_command_exists("wpctl", function(wpctl_exists)
				if wpctl_exists then
					debug_info("USING_WPCTL", "wpctl found, using WirePlumber detection")
					find_audio_clients_wpctl()
				else
					debug_info("FALLBACK_PACTL", "wpctl not found, trying pactl")

					-- Fallback to PulseAudio compatibility
					check_command_exists("pactl", function(pactl_exists)
						if pactl_exists then
							debug_info("USING_PACTL", "pactl found, using PulseAudio compatibility")
							find_audio_clients_pactl()
						else
							debug_info("ERROR_NO_TOOLS", "No audio tools found")
							naughty.notify({
								title = "Audio Detection Error",
								text = "No PipeWire or PulseAudio tools found",
								timeout = 5,
							})
						end
					end)
				end
			end)
		end
	end)
end

-- Toggle debug mode function
function M.toggle_debug()
	DEBUG_MODE = not DEBUG_MODE
	local status = DEBUG_MODE and "enabled" or "disabled"
	debug_log("Debug mode " .. status)
	naughty.notify({
		title = "Debug Mode",
		text = "Debug mode " .. status .. "\nLog file: /tmp/awesomewm_audio_debug.log",
		timeout = 3,
	})
end

-- Clear debug log function
function M.clear_debug_log()
	local log_file = io.open("/tmp/awesomewm_audio_debug.log", "w")
	if log_file then
		log_file:write("=== Debug log cleared at " .. os.date("%Y-%m-%d %H:%M:%S") .. " ===\n")
		log_file:close()
		naughty.notify({
			title = "Debug Log",
			text = "Debug log cleared",
			timeout = 2,
		})
	end
end

-- Simple test function to verify the module loads
function M.test()
	naughty.notify({
		title = "Test",
		text = "find-playing module loaded successfully!",
		timeout = 3,
	})
end

-- Manual test functions for debugging
function M.test_pw_cli()
	debug_info("TEST_PW_CLI", "Testing pw-cli directly")
	spawn_with_debug("pw-cli list-objects", function(stdout, stderr, exitreason, exitcode)
		debug_info("TEST_PW_CLI_RESULT", "Exit code: " .. tostring(exitcode) .. ", Output length: " .. #stdout)
		naughty.notify({
			title = "pw-cli Test",
			text = "Exit code: " .. tostring(exitcode) .. "\nOutput: " .. string.sub(stdout, 1, 200) .. "...",
			timeout = 10,
		})
	end)
end

function M.test_wpctl()
	debug_info("TEST_WPCTL", "Testing wpctl directly")
	spawn_with_debug("wpctl status", function(stdout, stderr, exitreason, exitcode)
		debug_info("TEST_WPCTL_RESULT", "Exit code: " .. tostring(exitcode) .. ", Output length: " .. #stdout)
		naughty.notify({
			title = "wpctl Test",
			text = "Exit code: " .. tostring(exitcode) .. "\nOutput: " .. string.sub(stdout, 1, 200) .. "...",
			timeout = 10,
		})
	end)
end

function M.test_pactl()
	debug_info("TEST_PACTL", "Testing pactl directly")
	spawn_with_debug("pactl list sink-inputs", function(stdout, stderr, exitreason, exitcode)
		debug_info("TEST_PACTL_RESULT", "Exit code: " .. tostring(exitcode) .. ", Output length: " .. #stdout)
		naughty.notify({
			title = "pactl Test",
			text = "Exit code: " .. tostring(exitcode) .. "\nOutput: " .. string.sub(stdout, 1, 200) .. "...",
			timeout = 10,
		})
	end)
end

return M

-- ============================================================================
-- ADD THIS TO YOUR rc.lua FILE:
-- ============================================================================

--[[

-- Import the find-playing module
local find_playing = require("functions.find-playing")

-- Test that the module loads (optional)
-- find_playing.test()

-- Add keyboard shortcuts (add these to your key bindings section)
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift" }, "a", find_playing.find_playing_audio, {
        description = "Find clients playing audio",
        group = "client"
    }),
    awful.key({ modkey, "Shift" }, "d", find_playing.toggle_debug, {
        description = "Toggle audio debug mode",
        group = "client"
    }),
    awful.key({ modkey, "Shift" }, "c", find_playing.clear_debug_log, {
        description = "Clear audio debug log",
        group = "client"
    })
})

-- Make functions available for awesome-client
_G.find_playing_audio = find_playing.find_playing_audio
_G.toggle_audio_debug = find_playing.toggle_debug
_G.clear_audio_debug_log = find_playing.clear_debug_log

-- New test functions for debugging
_G.test_pw_cli = find_playing.test_pw_cli
_G.test_wpctl = find_playing.test_wpctl
_G.test_pactl = find_playing.test_pactl

-- CLI usage examples (run these in terminal):
-- awesome-client "find_playing_audio()"
-- awesome-client "toggle_audio_debug()"
-- awesome-client "clear_audio_debug_log()"

-- Test individual audio tools:
-- awesome-client "test_pw_cli()"
-- awesome-client "test_wpctl()"
-- awesome-client "test_pactl()"

-- To enable debug mode from start, uncomment this:
-- find_playing.toggle_debug()

--]]
