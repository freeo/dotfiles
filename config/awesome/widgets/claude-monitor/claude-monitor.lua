local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local naughty = require("naughty")

local claude_monitor_widget = {}

local function escape_markup(text)
    -- Escape special XML/Pango markup characters
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
    local timeout = args.timeout or 30  -- 30 seconds as requested
    local color_cost = args.color_cost or (beautiful.fg_normal or "#ffffff")
    local color_reset = args.color_reset or (beautiful.fg_focus or "#00ff00")
    local color_error = args.color_error or (beautiful.fg_urgent or "#ff0000")
    local widget_path = args.widget_path or "/home/freeo/dotfiles/config/awesome/widgets/claude-monitor/claude_kpi_direct.py"

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

    -- Get widget components safely
    local cost_text = widget_instance:get_children_by_id('cost_text')[1]
    local reset_text = widget_instance:get_children_by_id('reset_text')[1]
    
    -- Verify we got the widgets
    if not cost_text or not reset_text then
        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Claude Monitor Widget Error",
            text = "Failed to initialize widget components"
        })
        return widget_instance
    end
    
    -- Set initial colors safely
    local function safe_set_markup(widget, color, text)
        if widget and widget.set_markup then
            local safe_text = escape_markup(text)
            local safe_color = escape_markup(color)
            widget:set_markup('<span color="' .. safe_color .. '">' .. safe_text .. '</span>')
        end
    end
    
    safe_set_markup(cost_text, color_cost, '$0.00')
    safe_set_markup(reset_text, color_reset, 'Reset: --')

    -- Update function with better error handling
    local function update_widget(widget, stdout, stderr, exitreason, exitcode)
        -- Protect against nil values
        exitcode = exitcode or -1
        stdout = stdout or ""
        
        if exitcode == 0 and stdout ~= "" then
            -- Parse the widget output: "$X.XX | Reset: Xh Xm" or "$X.XX | Reset: Xm"
            local line = stdout:match("^([^\n]+)")
            if line then
                -- Try to parse the expected format
                local cost_part, reset_part = line:match("^(.+) | Reset: (.+)$")
                if cost_part and reset_part then
                    safe_set_markup(cost_text, color_cost, cost_part)
                    safe_set_markup(reset_text, color_reset, 'Reset: ' .. reset_part)
                else
                    -- Fallback if parsing fails - display raw output
                    safe_set_markup(cost_text, color_cost, line)
                    safe_set_markup(reset_text, color_reset, '--')
                end
            else
                -- Empty output
                safe_set_markup(cost_text, color_error, 'No data')
                safe_set_markup(reset_text, color_error, '--')
            end
        else
            -- Error handling - show offline status
            safe_set_markup(cost_text, color_error, 'Claude: Offline')
            safe_set_markup(reset_text, color_error, '--')
        end
    end

    -- Build command with proper escaping
    local cmd = string.format("python3 '%s' --widget 2>/dev/null", widget_path)
    
    -- Set up the watch with the widget instance
    watch(cmd, timeout, update_widget, widget_instance)

    -- Add click functionality for manual refresh
    widget_instance:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                -- Manual refresh on left click
                awful.spawn.easy_async(cmd, function(stdout, stderr, exitreason, exitcode)
                    update_widget(widget_instance, stdout, stderr, exitreason, exitcode)
                end)
            end),
            awful.button({}, 3, function()
                -- Right click to show raw JSON (useful for debugging)
                local json_cmd = string.format("python3 '%s' --json 2>/dev/null", widget_path)
                awful.spawn.easy_async(json_cmd, function(stdout, stderr, exitreason, exitcode)
                    if stdout and stdout ~= "" then
                        naughty.notify({
                            title = "Claude Monitor Raw Data",
                            text = escape_markup(stdout),
                            timeout = 5
                        })
                    else
                        naughty.notify({
                            title = "Claude Monitor",
                            text = "No data available",
                            timeout = 3
                        })
                    end
                end)
            end)
        )
    )

    return widget_instance
end

return setmetatable(claude_monitor_widget, { __call = function(_, ...)
    return worker(...)
end })