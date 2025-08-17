local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local television_widget = {}

-- Configuration
local config = {
    width = 0.5,  -- 50% of screen width
    height = 0.5, -- 50% of screen height
    terminal = "kitty",
    command = "bash -c 'tv xrandr | bash'", -- television command
    class = "television-popup"
}

-- Track the current popup client
local current_client = nil

-- Function to create and show the television popup
function television_widget.show()
    -- If already showing, focus it
    if current_client and current_client.valid then
        current_client:emit_signal("request::activate", "key.unminimize", {raise = true})
        return
    end

    -- Get screen geometry
    local screen = awful.screen.focused()
    local geometry = screen.workarea

    -- Calculate popup dimensions
    local popup_width = math.floor(geometry.width * config.width)
    local popup_height = math.floor(geometry.height * config.height)
    local popup_x = geometry.x + math.floor((geometry.width - popup_width) / 2)
    local popup_y = geometry.y + math.floor((geometry.height - popup_height) / 2)

    -- Spawn kitty with television
    awful.spawn.with_shell(string.format(
        "%s --class=%s --title='Television' -o initial_window_width=%d -o initial_window_height=%d %s",
        config.terminal,
        config.class,
        popup_width,
        popup_height,
        config.command
    ))
end

-- Function to hide/close the television popup
function television_widget.hide()
    if current_client and current_client.valid then
        current_client:kill()
        current_client = nil
    end
end

-- Function to toggle the television popup
function television_widget.toggle()
    if current_client and current_client.valid then
        television_widget.hide()
    else
        television_widget.show()
    end
end

-- Client management rules and signals
local function setup_client_rules()
    -- Add rule for the television popup
    awful.rules.rules = awful.rules.rules or {}
    table.insert(awful.rules.rules, {
        rule = { class = config.class },
        properties = {
            floating = true,
            ontop = true,
            sticky = true,
            skip_taskbar = true,
            placement = awful.placement.centered,
            focus = true,
            titlebars_enabled = false,
        },
        callback = function(c)
            current_client = c

            -- Ensure proper geometry
            local screen = awful.screen.focused()
            local geometry = screen.workarea
            local popup_width = math.floor(geometry.width * config.width)
            local popup_height = math.floor(geometry.height * config.height)

            c:geometry({
                width = popup_width,
                height = popup_height,
            })

            -- Center the client
            awful.placement.centered(c)

            -- Set up close handler
            c:connect_signal("unmanage", function()
                current_client = nil
            end)

            -- Auto-close when the process exits
            c:connect_signal("property::urgent", function()
                if not c.valid then
                    current_client = nil
                end
            end)
        end
    })
end

-- Initialize the module
function television_widget.init()
    setup_client_rules()

    -- Optional: Create a widget button (if you want a clickable widget)
    local widget = wibox.widget {
        {
            text = "TV",
            font = "sans 10",
            widget = wibox.widget.textbox,
        },
        bg = "#2e3440",
        fg = "#d8dee9",
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background,
    }

    widget:connect_signal("button::press", function()
        television_widget.toggle()
    end)

    return widget
end

-- Configuration function (optional, for customization)
function television_widget.configure(opts)
    opts = opts or {}
    config.width = opts.width or config.width
    config.height = opts.height or config.height
    config.terminal = opts.terminal or config.terminal
    config.command = opts.command or config.command
    config.class = opts.class or config.class
end

return television_widget
