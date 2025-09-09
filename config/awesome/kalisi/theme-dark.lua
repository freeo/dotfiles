---------------------------------------------
-- Kalisi Dark Theme - 50% reduced lightness
-- Based on the original Kalisi theme
---------------------------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gdebug = require("gears.debug")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

-- inherit default theme
local theme = dofile(themes_path .. "default/theme.lua")

-- Function to reduce lightness by 50%
local function darken_color(hex_color)
	-- Remove # if present
	hex_color = hex_color:gsub("#", "")

	-- Convert hex to RGB
	local r = tonumber(hex_color:sub(1, 2), 16)
	local g = tonumber(hex_color:sub(3, 4), 16)
	local b = tonumber(hex_color:sub(5, 6), 16)

	-- Reduce each channel by 50%
	r = math.floor(r * 0.7)
	g = math.floor(g * 0.7)
	b = math.floor(b * 0.7)

	-- Convert back to hex
	return string.format("#%02x%02x%02x", r, g, b)
end

print("Freeodebug: Loading Kalisi Dark Theme")

-- Load the base kalisi theme first
local base_theme = dofile(gfs.get_configuration_dir() .. "kalisi/theme.lua")

-- Copy all properties from base theme
for key, value in pairs(base_theme) do
	theme[key] = value
end

-- Dark variants of kalisi colors (50% reduced lightness)
theme.hud_slider_fg = darken_color("#7e5edc") -- Original: #7e5edc -> Dark: #3f2f6e
theme.hud_slider_bg = darken_color("#462E6E") -- Original: #462E6E -> Dark: #231737

theme.tasklist_bg_normal = darken_color("#462E6E") -- -> #231737
theme.tasklist_fg_normal = darken_color("#E0E0E0") -- -> #707070
theme.tasklist_bg_minimize = darken_color("#606060") -- -> #303030
theme.tasklist_fg_minimize = darken_color("#E0E0E0") -- -> #707070
theme.tasklist_bg_focus = darken_color("#7e5edc") -- -> #3f2f6e
theme.tasklist_fg_focus = darken_color("#FFFFFF") -- -> #808080
theme.border_color_active = darken_color("#7e5edc") -- -> #3f2f6e
theme.border_focus = darken_color("#7e5edc") -- -> #3f2f6e
theme.color_highlight_mic_on = darken_color("#00DD00")

-- Only override urgent notification colors to darker variants
rnotification.connect_signal("request::rules", function()
	rnotification.append_rule({
		rule = { urgency = "critical" },
		properties = { bg = darken_color("#ff0000"), fg = darken_color("#ffffff") },
	})
end)

return theme
