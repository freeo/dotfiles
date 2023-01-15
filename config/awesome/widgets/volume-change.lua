-- source and autho
-- https://raw.githubusercontent.com/1jss/awesome-lighter/main/awesome/components/volume-adjust.lua

-- ===================================================================
-- Initialization
-- ===================================================================


local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

local offsety = dpi(80)
local offsetx = dpi(256)
local screen = awful.screen.focused()
local icon_dir = gears.filesystem.get_configuration_dir() .. "/icons/volume/"


-- ===================================================================
-- Appearance & Functionality
-- ===================================================================


local volume_icon = wibox.widget {
   widget = wibox.widget.imagebox
}

-- create the volume_adjust component
local volume_adjust = wibox({
   screen = awful.screen.focused(),
   -- x = (screen.geometry.width/2) - offsetx,
   -- y = offsety,
   x = offsetx,
   y = offsety,
   width = offsetx*2,
   height = offsety,
   bg = beautiful.hud_panel_bg,
   -- shape = gears.shape.rounded_rect,
   shape = gears.shape.rounded_bar,
   visible = false,
   ontop = true,
   opacity = 0.9
})

local volume_text = wibox.widget{
   widget = wibox.widget.textbox,
   valign = "center",
   halign = "center",
   markup = "durr",
   font = "sans 16",
}

local volume_bar = wibox.widget{
    widget = wibox.widget.progressbar,
    shape = gears.shape.rounded_bar,
    -- shape = gears.shape.rounded_rect,
    color = beautiful.hud_slider_fg,
    background_color = beautiful.hud_slider_bg,
    max_value = 100,
    value = 0,
    forced_height = offsety,
    forced_width = offsetx
}


volume_adjust:setup {
  {
    wibox.container.margin(
        volume_bar, dpi(6), dpi(6), dpi(6), dpi(6)
    ),
    forced_height = offsety,
    forced_width = offsetx,
    direction = "north",
    layout = wibox.container.rotate
  },
  {
    volume_text,
    widget = wibox.container.place,
    -- widget = wibox.container.background,
  },
  layout = wibox.layout.stack
}



-- create a 3 second timer to hide the volume adjust
-- component whenever the timer is started
local hide_volume_adjust = gears.timer {
   timeout = 3,
   autostart = true,
   callback = function()
      volume_adjust.visible = false
   end
}


-- client.connect_signal("focus", function(c)
-- awful.client.screen.connect_signal("focus", function(c)
awesome.connect_signal("screen_change", function()

  volume_adjust.screen = awful.screen.focused()
  volume_adjust.x = (screen.geometry.width/2) - offsetx
  volume_adjust.y = offsety

  -- naughty.notify({ title="Debug", text="screen:".. awful.screen.focused()  })
end)

-- show volume-adjust when "volume_change" signal is emitted
awesome.connect_signal("volume_change",
   function()
      -- set new volume value
      awful.spawn.easy_async_with_shell(
          -- 0.1 was carefully tested: smaller values result in wrong display for fast changes
         "sleep 0.1 && amixer sget Master | grep 'Right:' | sed -n '1p' | awk -F '[][]' '{print $2}'| sed 's/[^0-9]//g'",
         function(stdout)
            local volume_level = tonumber(stdout)
            if (volume_level == nil ) then
               return
            end

            volume_bar.value = volume_level
            volume_text.markup = "<span foreground='#fafafa'><b>"..volume_level.."%</b></span>"
            -- if (volume_level > 50) then
            --    volume_icon:set_image(icon_dir .. "volume-high.png")
            -- elseif (volume_level > 0) then
            --    volume_icon:set_image(icon_dir .. "volume-low.png")
            -- else
            --    volume_icon:set_image(icon_dir .. "volume-off.png")
            -- end
         end,
         false
      )

      -- make volume_adjust component visible
      if volume_adjust.visible then
         hide_volume_adjust:again()
      else
         volume_adjust.visible = true
         hide_volume_adjust:start()
      end
   end
)
