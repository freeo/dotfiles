-- Dynamic theme switcher for AwesomeWM
-- Responds to awesome-client signals to switch between light/dark kalisi themes
-- Usage: echo 'awesome.emit_signal("theme::switch", "dark")' | awesome-client

local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local theme_switcher = {}

-- Define theme file paths
local theme_files = {
    light = gears.filesystem.get_configuration_dir() .. "kalisi/theme.lua",
    dark = gears.filesystem.get_configuration_dir() .. "kalisi/theme-dark.lua"
}

-- Current theme state
local current_theme = "light"  -- Default to light (original kalisi)

function theme_switcher.apply_theme(theme_name)
    if not theme_files[theme_name] then
        return false
    end
    
    current_theme = theme_name
    
    -- Load the new theme
    local theme_path = theme_files[theme_name]
    local new_theme = dofile(theme_path)
    
    if not new_theme then
        return false
    end
    
    -- Update beautiful with the new theme
    for key, value in pairs(new_theme) do
        beautiful[key] = value
    end
    
    -- Force update all client borders
    for _, c in ipairs(client.get()) do
        if c == client.focus then
            c.border_color = beautiful.border_color_active
        else
            c.border_color = beautiful.border_color_normal
        end
    end
    
    -- Update all screens' tasklists and taglists
    for s in screen do
        if s.mywibox then
            -- Force redraw of wibox components
            s.mywibox:emit_signal("property::bg")
            s.mywibox:emit_signal("property::fg")
        end
        
        -- Update tasklist if it exists
        if s.mytasklist then
            s.mytasklist:emit_signal("widget::redraw_needed")
        end
        
        -- Update taglist if it exists  
        if s.mytaglist then
            s.mytaglist:emit_signal("widget::redraw_needed")
        end
    end
    
    -- Emit signal for custom widgets to update
    awesome.emit_signal("theme::changed", theme_name)
    
    return true
end

function theme_switcher.get_current_theme()
    return current_theme
end

function theme_switcher.toggle_theme()
    local new_theme = current_theme == "dark" and "light" or "dark"
    return theme_switcher.apply_theme(new_theme)
end

-- Connect to awesome signals
awesome.connect_signal("theme::switch", function(theme_name)
    theme_switcher.apply_theme(theme_name)
end)

awesome.connect_signal("theme::toggle", function()
    theme_switcher.toggle_theme()
end)

-- Auto-detect theme from gsettings on startup
awesome.connect_signal("startup", function()
    awful.spawn.easy_async("gsettings get org.gnome.desktop.interface color-scheme", function(stdout)
        local gsetting = stdout:match("'([^']*)'")
        if gsetting == "prefer-light" then
            theme_switcher.apply_theme("light")
        else
            theme_switcher.apply_theme("dark")
        end
    end)
end)

return theme_switcher