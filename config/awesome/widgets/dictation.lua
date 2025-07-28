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

-- Microphone state tracking
local microphone_state = {
	is_on = false,
	last_checked = 0,
}

-- Function to check actual microphone state
local function check_microphone_state(callback)
	awful.spawn.easy_async(
		"bash -c 'MICSRC=$(pactl list short sources | rg alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input | cut -f 1 | xargs) && pactl get-source-mute $MICSRC'",
		function(stdout, stderr, reason, exit_code)
			if exit_code == 0 then
				local is_on = not stdout:match("Mute: yes")
				microphone_state.is_on = is_on
				microphone_state.last_checked = os.time()
				if callback then
					callback(is_on)
				end
			end
		end
	)
end

-- Configuration
local config = {
	dictate_script = "/home/freeo/tools/nerd-dict-fork/tools/just_dictate.py",
	python_cmd = "mise exec python@3.11 -- python",
	moshi_server_path = "/home/freeo/.cargo/bin/moshi-server",
	timeout = 10, -- seconds to wait for server operations
	log_file = "/home/freeo/wb/awm_dict.log",
	debug = false, -- System debug messages and notifications (default: off)
	log_dictation_content = false, -- Log actual dictated text (default: off to prevent huge logs)
}

-- ============================================================================
-- DictationController: Manages server process lifecycle
-- ============================================================================

local DictationController = {}
DictationController.__index = DictationController

function DictationController.new()
	local self = setmetatable({}, DictationController)
	self.process_pid = nil
	self.is_running = false
	self.stopping = false -- Track graceful shutdown state
	self.mic_activation_time = nil -- Track when microphone was last activated
	self.callbacks = {
		on_starting = function() end, -- Called immediately when process starts
		on_start = function() end, -- Called when server is ready
		on_stop = function() end,
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

	-- Build command with absolute moshi-server path and unbuffered output
	local inner_cmd = string.format("%s %s --output auto", config.python_cmd, config.dictate_script)
	local cmd = string.format("env MOSHI_SERVER_PATH=%s PYTHONUNBUFFERED=1 %s", config.moshi_server_path, inner_cmd)
	self:_log("Executing command: " .. cmd)

	-- Start process with line callback to capture output
	self:_log("About to call awful.spawn.with_line_callback")

	local spawn_result = awful.spawn.with_line_callback(cmd, {
		stdout = function(line)
			-- Filter dictation content based on config setting
			local is_dictation_content = line:match("%[EndWord@") or 
			                           (line:match("^%s*%w") and not line:match("^🎯") and not line:match("^✅") and 
			                            not line:match("^🔧") and not line:match("^🎤") and not line:match("^🗣️") and
			                            not line:match("^%-%-%-") and not line:match("^📤") and not line:match("^🟢") and
			                            not line:match("^🚀") and not line:match("^🔗") and not line:match("^❌") and
			                            not line:match("^⚠️") and not line:match("^🔄") and not line:match("^🛑") and
			                            not line:match("^===") and not line:match("^Server:") and not line:match("^Device:") and
			                            not line:match("^Output:") and not line:match("^🤖") and not line:match("^👤") and
			                            not line:match("^Press Ctrl") and not line:match("^   Command:") and
			                            not line:match("^   Working directory:") and not line:match("^   Terminating PID:"))
			
			-- Always log system messages, only log dictation content if enabled
			if not is_dictation_content or config.log_dictation_content then
				self:_log("STDOUT: " .. line)
			end

			-- Check for server ready signals (turn green immediately when connected)
			if line:match("✅ Connected to Kyutai") or line:match("Connected to Kyutai server") then
				self:_log("DETECTED SERVER CONNECTED: " .. line)
				self.is_running = true
				self.callbacks.on_start()
				self:_log("Dictation started successfully")

			-- Check for specific error conditions (but ignore normal shutdown messages)
			elseif line:match("❌ moshi%-server not found") then
				self.callbacks.on_error("moshi-server not found in PATH. Please install or check PATH configuration.")
			elseif line:match("❌ Connection error") or line:match("Connection call failed") then
				self.callbacks.on_error("Cannot connect to moshi-server. Server may not be running.")
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

			-- Handle errors
			if line:match("Error") or line:match("Failed") then
				self.callbacks.on_error("Dictation error: " .. line)
			end
		end,
		exit = function(reason, code)
			self:_log(string.format("Process exited: reason=%s, code=%s", reason or "unknown", code or "unknown"))

			self.process_pid = nil
			self.is_running = false
			self.stopping = false -- Clear stopping flag on process exit
			self.callbacks.on_stop()
		end,
	})

	-- Check if spawn was successful
	if spawn_result then
		if type(spawn_result) == "number" then
			self.process_pid = spawn_result
			self:_log("Process started with PID: " .. spawn_result)
			self.callbacks.on_starting() -- Signal orange state immediately
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
		return
	end

	-- Set stopping flag to ignore normal shutdown messages
	self.stopping = true

	if self.process_pid then
		-- Send SIGTERM to gracefully shutdown
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
				-- Clear stopping flag after cleanup
				self.stopping = false
				return false -- Don't repeat timer
			end)
		end)
	end

	-- Update state immediately for UI responsiveness
	self.is_running = false
	self.callbacks.on_stop()
end

function DictationController:toggle()
	self:_log(
		string.format(
			"Toggle called: is_running=%s, process_pid=%s",
			tostring(self.is_running),
			tostring(self.process_pid)
		)
	)

	if self.is_running then
		self:_log("Calling stop() because is_running=true")
		self:stop()
	else
		self:_log("Calling start() because is_running=false")
		self:start()
	end
end

function DictationController:get_status()
	return {
		is_running = self.is_running,
		process_pid = self.process_pid,
		process_alive = self:_check_process_running(),
	}
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

	-- Setup layout
	self.container:setup({
		{
			direction = "north",
			layout = wibox.container.rotate,
			wibox.container.margin(self.status_indicator, dpi(4), dpi(4), dpi(4), dpi(4), "#42239F"),
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
	if state == "ready" or state == true then
		-- When server is ready, color depends on microphone state
		if mic_state ~= nil then
			if mic_state then
				self.status_indicator.bg = "#4CAF50" -- Green for mic on + server ready
				self.text_widget.markup = "<span foreground='#FFFFFF'><b>listening</b></span>"
			else
				self.status_indicator.bg = "#7e5edc" -- Purple for mic off + server ready (as requested)
				self.text_widget.markup = "<span foreground='#FFFFFF'><b>ready/muted</b></span>"
			end
		else
			-- Check microphone state if not provided
			check_microphone_state(function(is_mic_on)
				if is_mic_on then
					self.status_indicator.bg = "#4CAF50" -- Green
					self.text_widget.markup = "<span foreground='#FFFFFF'><b>listening</b></span>"
				else
					self.status_indicator.bg = "#7e5edc" -- Purple
					self.text_widget.markup = "<span foreground='#FFFFFF'><b>ready/muted</b></span>"
				end
				self.text_widget:emit_signal("widget::redraw_needed")
				self.status_indicator:emit_signal("widget::redraw_needed")
			end)
			return -- Exit early, let callback handle the update
		end
	elseif state == "starting" then
		self.status_indicator.bg = "#FF9800" -- Orange for starting
		self.text_widget.markup = "<span foreground='#FFFFFF'><b>starting...</b></span>"
	else -- stopped/false/inactive
		self.status_indicator.bg = "#9D6DCA" -- Purple for inactive
		self.text_widget.markup = "<span foreground='#FFFFFF'><b>dictation</b></span>"
	end

	-- Force widget refresh
	self.text_widget:emit_signal("widget::redraw_needed")
	self.status_indicator:emit_signal("widget::redraw_needed")
end

function UIManager:show_error(message)
	self.status_indicator.bg = "#F44336" -- Red for error
	self.text_widget.markup = "<span foreground='#FFFFFF'><b>error</b></span>" -- White text on red background

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

-- Initialize components
local controller = DictationController.new()
local ui = UIManager.new()

-- Connect to microphone state signals from microphone_toggle.sh
client.connect_signal("jack_source_on", function()
	microphone_state.is_on = true
	microphone_state.last_checked = os.time()

	if config.debug then
		local time_since_activation = controller.mic_activation_time and (os.time() - controller.mic_activation_time) or 999
		print("DEBUG: jack_source_on signal - " .. time_since_activation .. "s after activation")
	end

	-- Update widget if dictation is running
	if controller.is_running then
		ui:update_status("ready", true)
	end
end)

client.connect_signal("jack_source_off", function()
	microphone_state.is_on = false
	microphone_state.last_checked = os.time()

	-- Update widget if dictation is running
	if controller.is_running then
		-- Check if this is happening shortly after microphone activation (possible race condition)
		local time_since_activation = controller.mic_activation_time and (os.time() - controller.mic_activation_time) or 999
		
		if time_since_activation < 3 then
			-- This might be a spurious signal shortly after activation - try to recover
			if config.debug then
				print("DEBUG: Microphone turned off " .. time_since_activation .. "s after activation - attempting recovery")
			end
			
			gears.timer.start_new(0.2, function()
				microphone.On()
				-- Double-check state after recovery attempt
				gears.timer.start_new(0.3, function()
					check_microphone_state(function(recovered_state)
						ui:update_status("ready", recovered_state)
						if config.debug then
							print("DEBUG: Recovery attempt result: " .. tostring(recovered_state))
						end
					end)
					return false
				end)
				return false
			end)
		else
			-- Normal microphone off signal - update widget
			ui:update_status("ready", false)
		end
	end
end)

-- Setup callbacks
controller:set_callbacks({
	on_starting = function()
		ui:show()
		ui:update_status("starting")
		-- Turn on microphone when starting dictation
		microphone.On()
		
		-- Set a flag to ignore immediate microphone off signals for a brief period
		controller.mic_activation_time = os.time()
	end,

	on_start = function()
		if config.debug then
			print("DEBUG: on_start callback called - setting to ready")
		end
		
		-- Give microphone.On() time to take effect before checking state
		gears.timer.start_new(0.5, function()
			check_microphone_state(function(mic_is_on)
				ui:update_status("ready", mic_is_on)
				
				-- If microphone is unexpectedly off, try turning it on again
				if not mic_is_on and controller.is_running then
					if config.debug then
						print("DEBUG: Microphone unexpectedly off, turning on again")
					end
					microphone.On()
					-- Check again after a brief delay
					gears.timer.start_new(0.3, function()
						check_microphone_state(function(retry_mic_is_on)
							ui:update_status("ready", retry_mic_is_on)
						end)
						return false
					end)
				end
			end)
			return false
		end)
		
		if config.debug then
			naughty.notify({
				title = "Dictation",
				text = "Started successfully - checking microphone state",
				preset = naughty.config.presets.normal,
			})
		end
	end,

	on_stop = function()
		ui:hide()
		ui:update_status(false)
		-- Turn off microphone when stopping dictation
		microphone.Off()
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

		-- Auto-hide error after 5 seconds without affecting microphone
		gears.timer.start_new(5, function()
			ui.container.visible = false
			ui:update_status(false)
			return false -- Don't repeat
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
