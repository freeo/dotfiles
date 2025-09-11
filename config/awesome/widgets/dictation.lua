-- Modern Dictation Controller for Moshi STT
-- Clean, testable implementation using just_dictate.py
--
-- Features:
-- - Server process lifecycle management
-- - Clean UI state management
-- - Comprehensive error handling
-- - Unit testing capabilities
-- - No embedded bash scripts
--
-- Usage:
--   local dictation = require("widgets.dictation")
--   dictation.Toggle()  -- Toggle dictation on/off
--
-- Testing:
--   dictation._test.run_all()  -- Run all tests

-- Force module reload on awesome restart
package.loaded["widgets.dictation"] = nil

local dictation = {}

-- Dependencies
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

-- External modules
local microphone = require("widgets.microphone")

-- Configuration
local config = {
	dictate_script = "/home/freeo/tools/nerd-dict-fork/tools/just_dictate.py", -- Original script for direct moshi-server
	container_dictate_script = "/home/freeo/dotfiles/config/awesome/scripts/dictate_container_client.py", -- New container-specific client
	python_cmd = "/home/freeo/.local/share/mise/installs/python/3.11.6/bin/python", -- Full path to mise Python
	moshi_server_path = "/home/freeo/.cargo/bin/moshi-server",
	use_container = true, -- Toggle between container and direct moshi-server
	timeout = 10, -- seconds to wait for server operations
	log_file = "/home/freeo/wb/awm_dict.log",
	debug = true, -- System debug messages and notifications (temporary: on for debugging)
	log_dictation_content = false, -- Log actual dictated text (default: off to prevent huge logs)
	client_start_delay = 0.2, -- Minimal delay to ensure container is ready
}

-- ============================================================================
-- DictationController: Manages server process lifecycle
-- ============================================================================

local DictationController = {}
DictationController.__index = DictationController

function DictationController.new()
	local self = setmetatable({}, DictationController)
	self.process_pid = nil -- Dictation client process
	self.is_running = false -- Dictation server/container active
	self.stopping = false -- Track graceful shutdown state
	self.callbacks = {
		on_starting = function() end, -- Called immediately when process starts
		on_start = function() end, -- Called when server is ready
		on_stopping = function() end, -- Called when stopping is initiated
		on_stop = function() end, -- Called when completely stopped
		on_error = function(msg) end,
	}
	return self
end

function DictationController:set_callbacks(callbacks)
	for event, callback in pairs(callbacks) do
		if self.callbacks[event] then
			self.callbacks[event] = callback
		end
	end
end

function DictationController:_log(message)
	if config.debug then
		local timestamp = os.date("%Y-%m-%d %H:%M:%S")
		local log_entry = string.format("[%s] DictationController: %s\n", timestamp, message)

		-- Write to log file
		local file = io.open(config.log_file, "a")
		if file then
			file:write(log_entry)
			file:close()
		end

		-- Also print to stdout for debugging
		print("DICTATION: " .. message)
	end
end

function DictationController:_check_process_running()
	if not self.process_pid then
		return false
	end

	-- Check if process is still alive using kill -0
	local cmd = string.format("kill -0 %d 2>/dev/null", self.process_pid)
	local result = os.execute(cmd)
	return result == 0
end

function DictationController:_is_graceful_shutdown()
	-- Return true if we're in the process of gracefully stopping
	return self.stopping
end

function DictationController:start()
	self:_log("Attempting to start dictation")

	if self.is_running then
		self:_log("Dictation already running, ignoring start request")
		return
	end
	

	-- Show orange "starting" status immediately when user presses key
	self.callbacks.on_starting()

	local cmd
	if config.use_container then
		-- Use pure Lua + podman commands instead of wrapper script
		self:_start_container_and_client()
		return
	else
		-- Original direct moshi-server command
		local inner_cmd = string.format("%s %s --output auto", config.python_cmd, config.dictate_script)
		cmd = string.format("env MOSHI_SERVER_PATH=%s PYTHONUNBUFFERED=1 %s", config.moshi_server_path, inner_cmd)
		self:_start_dictation_process(cmd)
	end
end

function DictationController:_start_container_and_client()
	self:_log("Starting container with pure Lua + podman approach")

	-- Check if container exists (including stopped ones) - use shell to handle piping
	awful.spawn.easy_async_with_shell(
		"podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^moshi-stt'",
		function(stdout, stderr, reason, exit_code)
			-- Debug output to understand what we're getting
			self:_log(
				string.format(
					"Container check - stdout: '%s', stderr: '%s', exit_code: %s",
					stdout or "nil",
					stderr or "nil",
					tostring(exit_code)
				)
			)

			local container_state = "missing"
			-- Check stdout regardless of exit code since podman may emit warnings to stderr
			if stdout and stdout ~= "" then
				self:_log("Found stdout content: " .. stdout)
				if stdout:match("moshi%-stt") then
					local state_match = stdout:match("moshi%-stt%s+(%S+)")
					if state_match then
						container_state = state_match:lower()
					else
						self:_log("Pattern match failed for state extraction")
					end
				else
					self:_log("No moshi-stt found in stdout")
				end
			else
				self:_log("No stdout content received")
			end

			self:_log("Container state determined: " .. container_state)

			if container_state == "running" then
				self:_log("Container already running, starting client immediately")
				self.is_running = true
				-- Start client immediately since container is ready
				gears.timer.start_new(0.2, function()
					self:_start_container_client()
					return false
				end)
				self.callbacks.on_start()
			elseif container_state == "stopping" then
				self:_log("Container is stopping - waiting before starting")
				self.callbacks.on_error("Container is stopping - please wait a moment and try again")
			elseif container_state == "exited" or container_state == "created" then
				self:_log("Starting stopped container")
				awful.spawn.easy_async(
					"podman start moshi-stt",
					function(start_stdout, start_stderr, start_reason, start_exit_code)
						if start_exit_code == 0 then
							self:_log("Container started successfully")
							self.is_running = true
							-- Start client after delay since we just started the container
							gears.timer.start_new(config.client_start_delay, function()
								self:_start_container_client()
								self.callbacks.on_start()
								return false
							end)
						else
							self:_log("Failed to start container: " .. (start_stderr or "unknown"))
							self.callbacks.on_error("Failed to start container: " .. (start_stderr or "unknown"))
						end
					end
				)
			else
				self:_log("Container not found or in invalid state: " .. container_state)
				self.callbacks.on_error("Container 'moshi-stt' not found. Please create it first.")
			end
		end
	)
end

function DictationController:_wait_for_container_ready()
	self:_log("Waiting for container to be ready...")
	local check_count = 0
	local max_checks = 10 -- 5 seconds maximum wait (reduced from 30)

	local function check_ready()
		check_count = check_count + 1
		awful.spawn.easy_async(
			"podman logs --tail 10 moshi-stt",
			function(log_stdout, log_stderr, log_reason, log_exit_code)
				if log_exit_code == 0 and log_stdout then
					-- Check for readiness signal in logs
					if log_stdout:match("starting asr loop") or log_stdout:match("Server listening") then
						self:_log("Container is ready")
						self:_start_container_client()
						return
					end
				end

				-- Check if we should keep waiting
				if check_count < max_checks then
					-- Check again in 0.5 seconds (reduced from 1 second)
					gears.timer.start_new(0.5, function()
						check_ready()
						return false -- Don't repeat timer
					end)
				else
					-- Just try to connect after 5 seconds
					self:_log("Starting client after timeout")
					self:_start_container_client()
				end
			end
		)
	end

	-- Start checking
	check_ready()
end

function DictationController:_wait_for_container_stopped()
	self:_log("Waiting for container to fully stop...")
	local check_count = 0
	local max_checks = 20 -- 20 seconds maximum wait

	local function check_stopped()
		check_count = check_count + 1
		awful.spawn.easy_async_with_shell(
			"podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^moshi-stt'",
			function(stdout, stderr, reason, exit_code)
				if stdout and stdout ~= "" then
					local state_match = stdout:match("moshi%-stt%s+(%S+)")
					if state_match then
						local container_state = state_match:lower()
						self:_log("Container state check: " .. container_state)

						if container_state == "exited" then
							self:_log("Container fully stopped - calling on_stop")
							self.callbacks.on_stop()
							return
						end
					end
				end

				-- Check if we should keep waiting
				if check_count < max_checks then
					-- Check again in 1 second
					gears.timer.start_new(1, function()
						check_stopped()
						return false -- Don't repeat timer
					end)
				else
					self:_log("Timeout waiting for container to stop, calling on_stop anyway")
					self.callbacks.on_stop()
				end
			end
		)
	end

	-- Start checking
	check_stopped()
end

function DictationController:_start_container_client()
	self:_log("Starting dictation client for container")
	
	-- Double-check no client is already running to prevent duplicates
	awful.spawn.easy_async("pgrep -f dictate_container_client.py", function(stdout, stderr, reason, exit_code)
		if exit_code == 0 then
			self:_log("WARNING: Client already exists, not starting another")
			return
		end
		
		-- Use the new container-specific client script
		local cmd = string.format("%s %s --output auto", config.python_cmd, config.container_dictate_script)
		
		self:_log("Container client command: " .. cmd)
		self:_start_dictation_process(cmd)
		
	end)
end

function DictationController:_start_dictation_process(cmd)
	self:_log("Executing command: " .. cmd)

	-- Start process with line callback to capture output
	self:_log("About to call awful.spawn.with_line_callback")

	local spawn_result = awful.spawn.with_line_callback(cmd, {
		stdout = function(line)
			-- Filter dictation content based on config setting
			local is_dictation_content = line:match("%[EndWord@")
				or (
					line:match("^%s*%w")
					and not line:match("^🎯")
					and not line:match("^✅")
					and not line:match("^🔧")
					and not line:match("^🎤")
					and not line:match("^🗣️")
					and not line:match("^%-%-%-")
					and not line:match("^📤")
					and not line:match("^🟢")
					and not line:match("^🚀")
					and not line:match("^🔗")
					and not line:match("^❌")
					and not line:match("^⚠️")
					and not line:match("^🔄")
					and not line:match("^🛑")
					and not line:match("^===")
					and not line:match("^Server:")
					and not line:match("^Device:")
					and not line:match("^Output:")
					and not line:match("^🤖")
					and not line:match("^👤")
					and not line:match("^Press Ctrl")
					and not line:match("^   Command:")
					and not line:match("^   Working directory:")
					and not line:match("^   Terminating PID:")
				)

			-- Always log system messages, only log dictation content if enabled
			if not is_dictation_content or config.log_dictation_content then
				self:_log("STDOUT: " .. line)
			end

			-- Check for server ready signals (turn green immediately when connected)
			if
				line:match("✅ Connected to")
				or line:match("Connected to Kyutai server")
				or line:match("✅ STT server ready")
				or line:match("ASR warmed up and ready")
				or line:match("🟢 Server ready")
				or line:match("Connected to container server")
			then
				self:_log("DETECTED SERVER CONNECTED: " .. line)

				-- Only call on_start once (prevent duplicate notifications)
				if not self.is_running then
					self.is_running = true
					self.callbacks.on_start()
					self:_log("Dictation started successfully")
				else
					self:_log("Server ready signal received but already running - ignoring duplicate")
				end

			-- Check for specific error conditions (but ignore normal shutdown messages)
			elseif line:match("❌ moshi%-server not found") then
				self.callbacks.on_error("moshi-server not found in PATH. Please install or check PATH configuration.")
			elseif line:match("❌ Container not found") then
				self.callbacks.on_error("STT container not found. Please create it first.")
			elseif line:match("❌ Failed to start container") then
				self.callbacks.on_error("Failed to start STT container. Check container configuration.")
			elseif line:match("❌ Connection error") or line:match("Connection call failed") then
				self.callbacks.on_error("Cannot connect to STT server. Server may not be ready yet.")
			elseif line:match("⚠️  WebSocket connection closed") and not self:_is_graceful_shutdown() then
				-- Only treat as error if it's not during graceful shutdown
				self.callbacks.on_error("WebSocket connection dropped unexpectedly")
			elseif line:match("🔄 Connection lost") and not self:_is_graceful_shutdown() then
				-- Only treat as error if it's not during graceful shutdown
				self.callbacks.on_error("Connection lost unexpectedly")
			elseif line:match("❌ Error:") then
				self.callbacks.on_error("Dictation error: " .. line)
			end
		end,
		stderr = function(line)
			self:_log("STDERR: " .. line)

			-- Handle errors - be more aggressive about catching client issues
			if
				line:match("Error")
				or line:match("Failed")
				or line:match("can't open file")
				or line:match("ImportError")
				or line:match("ModuleNotFoundError")
				or line:match("❌")
			then
				self.callbacks.on_error("Client error: " .. line)
			end
		end,
		exit = function(reason, code)
			self:_log(string.format("Process exited: reason=%s, code=%s", reason or "unknown", code or "unknown"))

			-- Provide more detailed exit information for debugging
			if code and code ~= 0 then
				self:_log(string.format("Client process exited with code: %s", code))
				-- Don't show error if we're stopping or if it was killed intentionally
				-- Exit code 9 = SIGKILL (which we use to stop clients)
				-- Exit code 15 = SIGTERM (graceful shutdown)
				if not self.stopping and code ~= 9 and code ~= 15 then
					self.callbacks.on_error(string.format("Client process exited unexpectedly (code: %s)", code))
				elseif self.stopping then
					self:_log("Client process stopped as requested")
				end
			end

			-- Clear the PID
			self.process_pid = nil
			
			-- Don't change is_running state here - the container is still running
			-- Just update UI to show muted state
			if self.is_running and self.ui and not self.stopping then
				self.ui:update_status("ready", false)
			end

			-- Only call on_stop if we haven't already (prevents duplicate notifications)
			-- For containers, we wait for container to fully stop before calling on_stop
			if not self.stopping and not config.use_container then
				self.callbacks.on_stop()
			end

			self.stopping = false -- Clear stopping flag on process exit
		end,
	})

	-- Check if spawn was successful
	if spawn_result then
		if type(spawn_result) == "number" then
			-- Set the appropriate PID based on mode
			self.process_pid = spawn_result
			self:_log("Process started with PID: " .. spawn_result)
		else
			self:_log("Spawn returned: " .. tostring(spawn_result))
		end
	else
		self:_log("ERROR: awful.spawn.with_line_callback returned nil/false")
		self.callbacks.on_error("Failed to start dictation process - spawn failed")
	end
end

function DictationController:stop()
	self:_log("Attempting to stop dictation")

	if not self.is_running then
		self:_log("Dictation not running, ignoring stop request")
		-- But still try to clean up any orphaned processes
		awful.spawn.easy_async("pkill -f dictate_container_client.py", function()
			self:_log("Cleaned up any orphaned client processes")
		end)
		return
	end

	-- Set stopping flag to ignore normal shutdown messages
	self.stopping = true

	-- If we don't have a PID (e.g., after AWM restart), kill by name
	if not self.process_pid then
		self:_log("No process PID tracked - killing by process name")
		-- Use SIGKILL to ensure process dies
		awful.spawn.easy_async("pkill -9 -f dictate_container_client.py", function(stdout, stderr, reason, exit_code)
			self:_log("Force killed client processes by name")
			-- Still handle container stopping if needed
			if config.use_container then
				-- Add delay before stopping container to ensure client is dead
				gears.timer.start_new(1, function()
					self:_log("Stopping container")
					awful.spawn.easy_async("podman stop moshi-stt", function()
						self:_wait_for_container_stopped()
					end)
					return false
				end)
			end
		end)
		self.is_running = false
		self.callbacks.on_stopping()
		return
	end

	if self.process_pid then
		-- Send SIGTERM to gracefully shutdown the dictation client
		local cmd = string.format("kill -TERM %d", self.process_pid)
		self:_log("Sending SIGTERM to PID: " .. self.process_pid)

		awful.spawn.easy_async(cmd, function(stdout, stderr, reason, exit_code)
			self:_log(string.format("Kill command result: code=%s", exit_code or "unknown"))

			-- Give process time to cleanup
			gears.timer.start_new(2, function()
				if self:_check_process_running() then
					-- Force kill if still running
					local force_cmd = string.format("kill -KILL %d", self.process_pid)
					self:_log("Force killing PID: " .. self.process_pid)
					awful.spawn(force_cmd)
				end

				-- Also stop the container if we're using containers
				if config.use_container then
					-- First ensure ALL clients are dead
					awful.spawn.easy_async("pkill -9 -f dictate_container_client.py", function()
						self:_log("Ensured all clients are killed before stopping container")
						
						self:_log("Stopping container with pure podman command")
						awful.spawn.easy_async(
							"podman stop moshi-stt",
							function(container_stdout, container_stderr, container_reason, container_exit_code)
								if container_exit_code == 0 then
									self:_log("Container stopped successfully")
									-- Wait for container to fully exit, then call on_stop
									self:_wait_for_container_stopped()
								else
									self:_log("Failed to stop container: " .. (container_stderr or "unknown error"))
									-- Still try to wait for container state change
									self:_wait_for_container_stopped()
								end
							end
						)
					end)
				end

				-- Clear stopping flag after cleanup
				self.stopping = false
				return false -- Don't repeat timer
			end)
		end)
	end

	-- Update state immediately for UI responsiveness - show stopping state
	self.is_running = false
	self:_log("About to call on_stopping callback")
	self.callbacks.on_stopping()
	self:_log("on_stopping callback completed")
end

function DictationController:toggle()
	self:_log(
		string.format(
			"Toggle called: is_running=%s, process_pid=%s",
			tostring(self.is_running),
			tostring(self.process_pid)
		)
	)

	-- Check if there are any running clients (in case we lost track after AWM restart)
	awful.spawn.easy_async("pgrep -f dictate_container_client.py", function(stdout, stderr, reason, exit_code)
		if exit_code == 0 and stdout and stdout ~= "" then
			-- Found running client processes
			self:_log("Found running client processes (possibly from before AWM restart)")
			self.is_running = true  -- Set state to running
			-- Now stop them
			self:stop()
		elseif self.is_running then
			self:_log("Calling stop() because is_running=true")
			self:stop()
		else
			self:_log("Calling start() because is_running=false and no clients found")
			self:start()
		end
	end)
end

function DictationController:get_status()
	return {
		is_running = self.is_running,
		process_pid = self.process_pid,
		process_alive = self:_check_process_running(),
	}
end

-- Container state detection (public-facing)
function DictationController:get_container_state(callback)
	awful.spawn.easy_async_with_shell(
		"podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^moshi-stt'",
		function(stdout, stderr, reason, exit_code)
			local state = "missing"
			if stdout and stdout:match("moshi%-stt") then
				local state_match = stdout:match("moshi%-stt%s+(%S+)")
				if state_match then
					state = state_match:lower()
				end
			end
			if callback then
				callback(state)
			end
		end
	)
end


-- Simplified client management
function DictationController:client_start()
	self:_log("Starting client due to microphone activation")
	
	-- Only start if dictation is running and container is ready
	if not self.is_running then
		self:_log("Dictation not running - not starting client")
		return
	end
	
	self:_start_container_client()
end

function DictationController:client_stop()
	self:_log("Stopping client due to microphone deactivation")
	
	-- Set flag to prevent error notification
	self.stopping = true
	
	-- Kill all clients
	awful.spawn.easy_async("pkill -f dictate_container_client.py", function(stdout, stderr, reason, exit_code)
		if exit_code == 0 then
			self:_log("Killed dictation client(s)")
		else
			self:_log("No clients to kill")
		end
		-- Clear PID
		self.process_pid = nil
		
		-- Clear flag after a moment
		gears.timer.start_new(0.5, function()
			self.stopping = false
			return false
		end)
	end)
	
	-- Update widget immediately to show muted state
	if self.is_running and self.ui then
		self.ui:update_status("ready", false)
	end
end

-- ============================================================================
-- UIManager: Manages the visual dictation status widget
-- ============================================================================

local UIManager = {}
UIManager.__index = UIManager

function UIManager.new()
	local self = setmetatable({}, UIManager)

	-- Screen reference
	local focused = awful.screen.focused()

	-- Create main container
	self.container = wibox({
		screen = focused,
		x = (focused.geometry.width / 2) - 80,
		y = focused.geometry.height - 128,
		width = 160,
		height = 64,
		bg = beautiful.hud_panel_bg or "#1e1e1e",
		shape = gears.shape.rounded_rect,
		visible = false,
		ontop = true,
		opacity = 0.9,
	})

	-- Create text widget
	self.text_widget = wibox.widget({
		widget = wibox.widget.textbox,
		valign = "center",
		halign = "center",
		markup = "<span foreground='#42239F'><b>dictation</b></span>",
		font = "sans 12",
	})

	-- Create status indicator
	self.status_indicator = wibox.widget({
		bg = "#9D6DCA",
		widget = wibox.widget.background,
		shape = gears.shape.rectangle,
		forced_height = 50,
		forced_width = 50,
	})

	-- Create margin container (we'll update its color dynamically)
	self.margin_container = wibox.container.margin(self.status_indicator, dpi(4), dpi(4), dpi(4), dpi(4), "#42239F")

	-- Setup layout
	self.container:setup({
		{
			direction = "north",
			layout = wibox.container.rotate,
			self.margin_container,
		},
		{
			self.text_widget,
			widget = wibox.container.place,
		},
		layout = wibox.layout.stack,
	})

	return self
end

function UIManager:show()
	self.container.visible = true
	-- Don't automatically control microphone - let user control it manually
end

function UIManager:hide()
	self.container.visible = false
	-- Don't automatically control microphone - let user control it manually
end

function UIManager:update_status(state, mic_state)
	-- Debug logging to track UI updates
	if config.debug then
		print(
			string.format(
				"DEBUG: UIManager:update_status called with state='%s', mic_state='%s'",
				tostring(state),
				tostring(mic_state)
			)
		)
	end

	-- Define coordinated color schemes for each state
	local color_schemes = {
		listening = {
			background = "#4CAF50", -- Green
			margin = "#2E7D32", -- Darker green
			text = "#1B5E20", -- Dark green for contrast
			label = "dictate",
		},
		ready_muted = {
			background = "#7e5edc", -- Purple
			margin = "#5E35B1", -- Darker purple
			text = "#311B92", -- Dark purple for contrast
			label = "muted",
		},
		starting = {
			background = "#FF9800", -- Orange
			margin = "#F57C00", -- Darker orange
			text = "#E65100", -- Dark orange for contrast
			label = "starting...",
		},
		stopping = {
			background = "#FF5722", -- Deep Orange/Red
			margin = "#D84315", -- Darker deep orange
			text = "#BF360C", -- Dark deep orange for contrast
			label = "stopping...",
		},
		inactive = {
			background = "#9D6DCA", -- Light purple
			margin = "#7B1FA2", -- Darker purple
			text = "#4A148C", -- Dark purple for contrast
			label = "inactive",
		},
		error = {
			background = "#F44336", -- Red
			margin = "#C62828", -- Darker red
			text = "#B71C1C", -- Dark red for contrast
			label = "error",
		},
	}

	local scheme
	if state == "ready" then
		-- When server is ready, color depends on microphone state
		scheme = mic_state and color_schemes.listening or color_schemes.ready_muted
	elseif state == "starting" then
		scheme = color_schemes.starting
	elseif state == "stopping" then
		scheme = color_schemes.stopping
	else -- stopped/false/inactive
		scheme = color_schemes.inactive
	end

	if config.debug and scheme then
		print(string.format("DEBUG: UIManager applying scheme: %s", scheme.label or "unknown"))
	end

	self:_apply_color_scheme(scheme)
end

function UIManager:_apply_color_scheme(scheme)
	if not scheme then
		return
	end

	-- Apply colors
	self.status_indicator.bg = scheme.background
	self.margin_container.color = scheme.margin
	self.text_widget.markup = string.format("<span foreground='%s'><b>%s</b></span>", scheme.text, scheme.label)

	-- Force widget refresh
	self.text_widget:emit_signal("widget::redraw_needed")
	self.status_indicator:emit_signal("widget::redraw_needed")
	self.margin_container:emit_signal("widget::redraw_needed")
end

function UIManager:show_error(message)
	-- Use the coordinated error color scheme
	local error_scheme = {
		background = "#F44336", -- Red
		margin = "#C62828", -- Darker red
		text = "#B71C1C", -- Dark red for contrast
		label = "error",
	}

	self:_apply_color_scheme(error_scheme)

	-- Show error notification
	naughty.notify({
		title = "Dictation Error",
		text = message,
		preset = naughty.config.presets.critical,
	})
end

-- ============================================================================
-- Main Dictation Module
-- ============================================================================

-- Cleanup any leftover processes on module load/reload
local function cleanup_leftover_processes()
	if config.debug then
		print("DEBUG: Cleaning up leftover dictation processes on module load")
	end

	-- ALWAYS kill ALL client processes on reload to prevent duplicates
	awful.spawn.easy_async("pkill -f dictate_container_client.py", function(stdout, stderr, reason, exit_code)
		if config.debug then
			if exit_code == 0 then
				print("DEBUG: Killed leftover container client processes")
			else
				print("DEBUG: No container client processes found")
			end
		end
	end)

	-- Always kill any existing just_dictate.py processes
	awful.spawn.easy_async("pkill -f just_dictate.py", function(stdout, stderr, reason, exit_code)
		if config.debug and exit_code == 0 then
			print("DEBUG: Killed leftover just_dictate.py processes")
		end
	end)

	if config.use_container then
		-- DON'T stop the container on reload - we want to detect its state
		-- Just clean up clients
		if config.debug then
			print("DEBUG: Container mode - not stopping container, just cleaning clients")
		end
	else
		-- Kill any existing moshi-server processes (original behavior)
		awful.spawn.easy_async("pkill -f moshi-server", function(stdout, stderr, reason, exit_code)
			if config.debug and exit_code == 0 then
				print("DEBUG: Killed leftover moshi-server processes")
			end
		end)
	end
end

-- Run cleanup on module load
cleanup_leftover_processes()

-- Initialize components
local controller = DictationController.new()
local ui = UIManager.new()

-- Make ui accessible to controller
controller.ui = ui

-- Connect to microphone state signals from microphone_toggle.sh
client.connect_signal("jack_source_on", function()
	if config.debug then
		print("DEBUG: jack_source_on signal received")
		print("DEBUG: controller.is_running = " .. tostring(controller.is_running))
	end

	-- Check both controller state AND actual container state
	controller:get_container_state(function(container_state)
		if config.debug then
			print("DEBUG: Container state = " .. container_state)
		end
		
		-- If container is running, we should be able to start client
		if container_state == "running" then
			-- Check if client is already running
			awful.spawn.easy_async("pgrep -f dictate_container_client.py", function(stdout, stderr, reason, exit_code)
				if exit_code == 0 and stdout and stdout ~= "" then
					if config.debug then
						print("DEBUG: Client already running")
					end
					-- Just update UI to show listening state
					if ui then
						ui:update_status("ready", true)
					end
				else
					-- Container is running but no client - start client
					if config.debug then
						print("DEBUG: Starting client - container is running")
					end
					-- Update controller state if it was wrong
					if not controller.is_running then
						controller.is_running = true
					end
					controller:_start_container_client()
					if ui then
						ui:update_status("ready", true)
					end
				end
			end)
		else
			-- Container not running - don't start anything
			if config.debug then
				print("DEBUG: Microphone on but container not running (state: " .. container_state .. ") - ignoring")
			end
		end
	end)
end)

client.connect_signal("jack_source_off", function()
	if config.debug then
		print("DEBUG: jack_source_off signal received")
	end
	
	-- Stop client when mic turns off (if dictation is running)
	if controller.is_running then
		controller:client_stop()
	end
end)

-- Setup callbacks
controller:set_callbacks({
	on_starting = function()
		ui:show()
		ui:update_status("starting")
		-- Turn on microphone when starting dictation
		microphone.On()
	end,

	on_start = function()
		if config.debug then
			print("DEBUG: on_start callback - container/server ready")
		end
		-- Server is ready, show UI with current mic state
		-- The microphone should already be on from on_starting
		ui:update_status("ready", microphone.state.is_on)
		if config.debug then
			naughty.notify({
				title = "Dictation",
				text = "Server ready - dictation active",
				preset = naughty.config.presets.normal,
			})
		end
	end,

	on_stopping = function()
		ui:show()
		ui:update_status("stopping")
		-- Turn off microphone when stopping dictation
		microphone.Off()
		if config.debug then
			naughty.notify({
				title = "Dictation",
				text = "Stopping...",
				preset = naughty.config.presets.normal,
			})
		end
	end,

	on_stop = function()
		ui:hide()
		ui:update_status(false)
		if config.debug then
			naughty.notify({
				title = "Dictation",
				text = "Stopped",
				preset = naughty.config.presets.normal,
			})
		end
	end,

	on_error = function(message)
		ui:show_error(message)

		-- Auto-hide error after 5 seconds
		gears.timer.start_new(5, function()
			ui.container.visible = false
			ui:update_status(false)
			return false
		end)
	end,
})

-- Public API
function dictation.Toggle()
	controller:toggle()
end

function dictation.Start()
	controller:start()
end

function dictation.Stop()
	controller:stop()
end

function dictation.GetStatus()
	return controller:get_status()
end

function dictation.SetConfig(new_config)
	for key, value in pairs(new_config) do
		if config[key] ~= nil then
			config[key] = value
		end
	end
end

-- Client Management APIs (for manual control)
function dictation.ClientStart()
	-- Use the same robust client starting logic as Toggle() does
	-- Check if there are any running clients first
	awful.spawn.easy_async("pgrep -f dictate_container_client.py", function(stdout, stderr, reason, exit_code)
		if exit_code == 0 and stdout and stdout ~= "" then
			print("Client already running")
		elseif controller.is_running then
			-- Dictation is running but no client - start client like Toggle() does  
			controller:_start_container_client()
		else
			-- Need to start the whole dictation system
			print("Dictation not running - starting full system")
			controller:start()
		end
	end)
end

function dictation.ClientStop()
	controller:client_stop()
end

-- Container state check
function dictation.GetContainerState(callback)
	controller:get_container_state(callback)
end

-- ============================================================================
-- Testing Framework
-- ============================================================================

dictation._test = {}

-- Mock dependencies for testing
local function create_mock_awful()
	return {
		spawn = {
			with_line_callback = function(cmd, callbacks, start_callback)
				-- Simulate successful process start
				if start_callback then
					start_callback(12345) -- Mock PID
				end

				-- Simulate stdout messages
				gears.timer.start_new(0.1, function()
					if callbacks.stdout then
						callbacks.stdout("Server ready - start speaking!")
					end
					return false
				end)

				return 12345
			end,
			easy_async = function(cmd, callback)
				gears.timer.start_new(0.1, function()
					if callback then
						callback("", "", "exit", 0)
					end
					return false
				end)
			end,
		},
	}
end

function dictation._test.test_controller_creation()
	local test_controller = DictationController.new()

	assert(test_controller ~= nil, "Controller should be created")
	assert(test_controller.is_running == false, "Controller should start in stopped state")
	assert(test_controller.process_pid == nil, "Controller should have no PID initially")

	print("✓ Controller creation test passed")
	return true
end

function dictation._test.test_controller_start_stop()
	local test_controller = DictationController.new()
	local started = false
	local stopped = false

	test_controller:set_callbacks({
		on_start = function()
			started = true
		end,
		on_stop = function()
			stopped = true
		end,
	})

	-- Test start
	test_controller:start()

	-- Wait for async operations
	gears.timer.start_new(0.5, function()
		assert(started == true, "Start callback should be called")
		assert(test_controller.is_running == true, "Controller should be running")

		-- Test stop
		test_controller:stop()

		gears.timer.start_new(0.2, function()
			assert(stopped == true, "Stop callback should be called")
			assert(test_controller.is_running == false, "Controller should be stopped")

			print("✓ Controller start/stop test passed")
			return false
		end)

		return false
	end)

	return true
end

function dictation._test.test_ui_show_hide()
	local test_ui = UIManager.new()

	-- Test show
	test_ui:show()
	assert(test_ui.container.visible == true, "UI should be visible after show()")

	-- Test hide
	test_ui:hide()
	assert(test_ui.container.visible == false, "UI should be hidden after hide()")

	print("✓ UI show/hide test passed")
	return true
end

function dictation._test.test_ui_status_updates()
	local test_ui = UIManager.new()

	-- Test running status
	test_ui:update_status(true)
	assert(test_ui.status_indicator.bg == "#4CAF50", "Status indicator should be green when running")

	-- Test stopped status
	test_ui:update_status(false)
	assert(test_ui.status_indicator.bg == "#9D6DCA", "Status indicator should be purple when stopped")

	print("✓ UI status update test passed")
	return true
end

function dictation._test.test_config_management()
	local original_timeout = config.timeout

	dictation.SetConfig({ timeout = 20 })
	assert(config.timeout == 20, "Config should be updated")

	-- Restore original
	config.timeout = original_timeout

	print("✓ Config management test passed")
	return true
end

function dictation._test.run_all()
	print("Running dictation module tests...")
	print("==================================")

	local tests = {
		dictation._test.test_controller_creation,
		dictation._test.test_ui_show_hide,
		dictation._test.test_ui_status_updates,
		dictation._test.test_config_management,
		-- Note: start_stop test requires async operations, run separately
	}

	local passed = 0
	local total = #tests

	for i, test in ipairs(tests) do
		local success, error_msg = pcall(test)
		if success then
			passed = passed + 1
		else
			print("✗ Test " .. i .. " failed: " .. (error_msg or "unknown error"))
		end
	end

	print("==================================")
	print(string.format("Tests completed: %d/%d passed", passed, total))

	if passed == total then
		print("🎉 All tests passed!")

		-- Run async test separately
		print("\nRunning async test...")
		dictation._test.test_controller_start_stop()
	else
		print("❌ Some tests failed")
	end

	return passed == total
end

-- ============================================================================
-- Debug utilities
-- ============================================================================

function dictation._debug_info()
	local status = controller:get_status()

	print("Dictation Debug Info:")
	print("====================")
	print("Is running: " .. tostring(status.is_running))
	print("Process PID: " .. tostring(status.process_pid))
	print("Process alive: " .. tostring(status.process_alive))
	print("UI visible: " .. tostring(ui.container.visible))
	print("Config:")
	for key, value in pairs(config) do
		print("  " .. key .. ": " .. tostring(value))
	end
end

function dictation._test_command()
	print("Testing dictation command:")
	local inner_cmd = string.format("%s %s --output auto", config.python_cmd, config.dictate_script)
	local cmd = string.format("bash -c 'export PATH=%s:$PATH && %s'", config.cargo_path, inner_cmd)
	print("Command: " .. cmd)

	-- Test if files exist
	local script_file = io.open(config.dictate_script, "r")
	if script_file then
		print("✓ Script file exists: " .. config.dictate_script)
		script_file:close()
	else
		print("✗ Script file NOT found: " .. config.dictate_script)
	end

	-- Test mise command
	awful.spawn.easy_async("which mise", function(stdout, stderr, reason, exit_code)
		if exit_code == 0 then
			print("✓ mise command available")
		else
			print("✗ mise command NOT available")
		end
	end)

	-- Test moshi-server with correct PATH using bash wrapper
	awful.spawn.easy_async(
		string.format("bash -c 'export PATH=%s:$PATH && which moshi-server'", config.cargo_path),
		function(stdout, stderr, reason, exit_code)
			if exit_code == 0 then
				print("✓ moshi-server available at: " .. stdout:gsub("%s+", ""))
			else
				print("✗ moshi-server NOT found in PATH")
				print("  stderr: " .. (stderr or "none"))
			end
		end
	)
end

return dictation
