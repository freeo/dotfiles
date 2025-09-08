local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local naughty = require("naughty")

-- Import and initialize TUI widget ONCE at module level (like television.lua)
local claude_tui = require("widgets.claude-monitor.claude-tui-simple")
claude_tui.init()  -- Initialize once here, not per widget instance

local claude_monitor_widget = {}

-- Debug control
local DEBUG = false  -- Set to true to enable debugging

-- Debug logging - only active when DEBUG=true
local function debug_log(msg)
	if not DEBUG then return end
	
	local log_file = "/tmp/claude_widget_debug.log"
	local f = io.open(log_file, "a")
	if f then
		f:write(os.date("%Y-%m-%d %H:%M:%S") .. " - " .. tostring(msg) .. "\n")
		f:close()
	end
end

local function escape_markup(text)
	if not text then return "" end
	text = tostring(text)
	text = text:gsub("&", "&amp;")
	text = text:gsub("<", "&lt;")
	text = text:gsub(">", "&gt;")
	text = text:gsub("'", "&apos;")
	text = text:gsub('"', "&quot;")
	return text
end

local function worker(user_args)
	local args = user_args or {}
	local timeout = args.timeout or 30
	local color_cost = args.color_cost or (beautiful.fg_normal or "#ffffff")
	local color_reset = args.color_reset or "#00ff00"
	local color_error = args.color_error or "#ff4444"
	local use_mock = args.use_mock or false
	local widget_path = args.widget_path or "/home/freeo/dotfiles/config/awesome/widgets/claude-monitor/claude_kpi_direct.py"
	local mock_path = "/home/freeo/dotfiles/config/awesome/widgets/claude-monitor/test_mock.py"

	debug_log("Initializing Claude widget...")

	-- Create the widget instance
	local widget_instance = wibox.widget {
		{
			{
				id = 'cost_text',
				text = '$0.00',
				align = 'center',
				valign = 'center',
				font = beautiful.font or "sans 9",
				widget = wibox.widget.textbox
			},
			{
				id = 'separator_text',
				text = ' | ',
				align = 'center',
				valign = 'center',
				font = beautiful.font or "sans 9",
				widget = wibox.widget.textbox
			},
			{
				id = 'reset_text',
				text = 'Reset: --',
				align = 'center',
				valign = 'center',
				font = beautiful.font or "sans 9",
				widget = wibox.widget.textbox
			},
			layout = wibox.layout.fixed.horizontal
		},
		margins = 4,
		widget = wibox.container.margin
	}

	-- Get widget components
	local cost_text = widget_instance:get_children_by_id('cost_text')[1]
	local reset_text = widget_instance:get_children_by_id('reset_text')[1]

	if not cost_text or not reset_text then
		debug_log("ERROR: Failed to get widget components")
		return widget_instance
	end

	-- Safe markup function
	local function safe_set_markup(widget, color, text)
		if widget and widget.set_markup then
			local safe_text = escape_markup(text)
			local safe_color = escape_markup(color)
			widget:set_markup('<span color="' .. safe_color .. '">' .. safe_text .. '</span>')
		end
	end

	-- Set initial text
	safe_set_markup(cost_text, color_cost, '$0.00')
	safe_set_markup(reset_text, color_reset, 'Reset: --')

	-- Current script to use
	local current_script = use_mock and mock_path or widget_path

	-- Update function 
	local function update_widget(widget, stdout, stderr, exitreason, exitcode)
		exitcode = exitcode or -1
		stdout = stdout or ""
		
		debug_log("Update: exitcode=" .. exitcode .. ", stdout='" .. stdout .. "'")

		if exitcode == 0 and stdout ~= "" then
			local line = stdout:match("([^\n]+)")
			if line then
				local cost_part, reset_part = line:match("^(.+) | Reset: (.+)$")
				if cost_part and reset_part then
					safe_set_markup(cost_text, color_cost, cost_part)
					safe_set_markup(reset_text, color_reset, 'Reset: ' .. reset_part)
				else
					safe_set_markup(cost_text, color_cost, line)
					safe_set_markup(reset_text, color_reset, '--')
				end
			end
		else
			safe_set_markup(cost_text, color_error, 'Claude: Offline')
			safe_set_markup(reset_text, color_error, '--')
		end
	end

	-- Set up simple watch - no custom timers!
	local cmd = string.format("python3 '%s' --widget", current_script)
	debug_log("Watch command: " .. cmd)
	
	watch(cmd, timeout, update_widget, widget_instance)

	-- Add click handlers
	widget_instance:buttons(
		awful.util.table.join(
			awful.button({}, 1, function()
				-- Left click: Toggle TUI overlay (spawn once, then show/hide)
				claude_tui.toggle()
			end),
			awful.button({}, 3, function()
				-- Right click: Manual refresh
				awful.spawn.easy_async(cmd, update_widget)
			end)
		)
	)

	return widget_instance
end

return setmetatable(claude_monitor_widget, { __call = function(_, ...)
	return worker(...)
end })