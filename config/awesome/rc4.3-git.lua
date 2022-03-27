-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- @DOC_REQUIRE_SECTION@
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- shared tags across monitors
local sharedtags = require("awesome-sharedtags")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
-- @DOC_ERROR_HANDLING@
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- {{{ Variable definitions
-- @DOC_LOAD_THEME@
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init("./themes/copland/theme.lua")
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
-- beautiful.init(gears.filesystem.get_themes_dir() .. "xresources/theme.lua")
-- beautiful.init(gears.filesystem.get_themes_dir() .. "kalisi/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "kalisi/theme.lua")

-- @DOC_DEFAULT_APPLICATIONS@
-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- {{{ Menu
-- @DOC_MENU@
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tag layout
-- @DOC_LAYOUT@
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.floating,
        awful.layout.suit.max,
        -- awful.layout.suit.tile.left,
        -- awful.layout.suit.tile.bottom,
        -- awful.layout.suit.tile.top,
        -- awful.layout.suit.fair,
        -- awful.layout.suit.fair.horizontal,
        -- awful.layout.suit.spiral,
        -- awful.layout.suit.spiral.dwindle,
        -- awful.layout.suit.max.fullscreen,
        -- awful.layout.suit.magnifier,
        -- awful.layout.suit.corner.nw,
    })
end)
-- }}}

-- {{{ Wallpaper
-- @DOC_WALLPAPER@
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            {
                image     = beautiful.wallpaper,
                upscale   = true,
                downscale = true,
                widget    = wibox.widget.imagebox,
            },
            valign = "center",
            halign = "center",
            tiled  = false,
            widget = wibox.container.tile,
        }
    }
end)
-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()


-- Custom Widgets

local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local cw = calendar_widget({
    theme = 'nord',
    placement = 'top_right',
    radius = 8,
    previous_month_button = 3,
    next_month_button = 1,
})
mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
    end)


-- apt_widget unfortunately bugged currently
-- local apt_widget = require("awesome-wm-widgets.apt-widget.apt-widget")
local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")

-- local test_widget = require("widgets.test-widget.test-widget")

-- @DOC_FOR_EACH_SCREEN@
screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    -- @TASKLIST_BUTTON@
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        }
    }

    -- @DOC_WIBAR@
    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen   = s,
        -- @DOC_SETUP_WIDGETS@
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                fs_widget({'/','/home/freeo','/mnt/nvme0n1p6','/mnt/Drive D','/mnt/Drive E'}),
                cpu_widget({
                  -- width = 70,
                  -- step_width = 2,
                  -- step_spacing = 0,
                  color = '#ffffff'
                }),
                ram_widget(),
                -- test_widget(),
                -- apt_widget(), -- bugged
                mykeyboardlayout,
                wibox.widget.systray(),
                mytextclock,
                widget_mic,
                s.mylayoutbox,
            },
        }
    }
end)
-- }}}

-- {{{ Mouse bindings
-- @DOC_ROOT_BUTTONS@
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})
-- }}}

-- {{{ Key bindings
-- @DOC_GLOBAL_KEYBINDINGS@

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "e",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              -- {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey, "Control" }, "e",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open terminal", group = "launcher"}),
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Delete", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
})

-- @DOC_NUMBER_KEYBINDINGS@

-- key.keygroups = {
--     lefthand = {
--         {"#38"   , 1},
--         {"#39"   , 2},
--         {"#40"   , 3},
--         {"#41"   , 4},
--         {"#42"   , 5},
--         {"#52"   , 6},
--         {"#53"   , 7},
--         {"#54"   , 8},
--         {"#55"   , 9},
--         {"#56"   , 10},
--     },
-- }
--
-- key.keygroup = {
--     LEFTHAND = 'lefthand'
--   }

local tagskeycodes = {38, 39, 40, 41, 42, -- asdfg
                      52, 53, 54, 55, 56, -- zxcvb
                     }

local tagskeys = {"a","s","d","f","g",
                  "z","x","c","v","b",}

local tags = sharedtags({
    { name = "fox", layout = awful.layout.suit.tile },
    { name = "emx", layout = awful.layout.suit.tile },
    { name = "eee", layout = awful.layout.suit.tile },
    { name = "fff", layout = awful.layout.suit.tile },
    { name = "ggg", layout = awful.layout.layouts[1] },
    { name = "music", layout = awful.layout.suit.tile },
    { name = "xxx", layout = awful.layout.suit.tile },
    { name = "ccc", layout = awful.layout.suit.tile },
    { name = "vvv", layout = awful.layout.suit.tile },
    { name = "bbb", layout = awful.layout.layouts[1] },
    -- { layout = awful.layout.layouts[2] },
    -- { screen = 2, layout = awful.layout.layouts[1] },
})

-- awful.keyboard.append_global_keybindings({
--     awful.key {
--         modifiers   = { modkey },
--         keygroup    = "numrow",
--         description = "only view tag",
--         group       = "tag",
--         on_press    = function (index)
--             local screen = awful.screen.focused()
--             local tag = screen.tags[index]
--             if tag then
--                 tag:view_only()
--             end
--         end,
--     },
--     awful.key {
--         modifiers   = { modkey, "Control" },
--         keygroup    = "numrow",
--         description = "toggle tag",
--         group       = "tag",
--         on_press    = function (index)
--             local screen = awful.screen.focused()
--             local tag = screen.tags[index]
--             if tag then
--                 awful.tag.viewtoggle(tag)
--             end
--         end,
--     },
--     awful.key {
--         modifiers = { modkey, "Shift" },
--         keygroup    = "numrow",
--         description = "move focused client to tag",
--         group       = "tag",
--         on_press    = function (index)
--             if client.focus then
--                 local tag = client.focus.screen.tags[index]
--                 if tag then
--                     client.focus:move_to_tag(tag)
--                 end
--             end
--         end,
--     },
--     awful.key {
--         modifiers   = { modkey, "Control", "Shift" },
--         keygroup    = "numrow",
--         description = "toggle focused client on tag",
--         group       = "tag",
--         on_press    = function (index)
--             if client.focus then
--                 local tag = client.focus.screen.tags[index]
--                 if tag then
--                     client.focus:toggle_tag(tag)
--                 end
--             end
--         end,
--     },
--     awful.key {
--         modifiers   = { modkey },
--         keygroup    = "numpad",
--         description = "select layout directly",
--         group       = "layout",
--         on_press    = function (index)
--             local t = awful.screen.focused().selected_tag
--             if t then
--                 t.layout = t.layouts[index] or t.layout
--             end
--         end,
--     }
-- })


for i, _ in ipairs(tags) do
  awful.keyboard.append_global_keybindings({
    -- globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. tagskeycodes[i],
                  function ()
                        local screen = awful.screen.focused()
                        local tag = tags[i]
                        -- local tag = screen.tags[i]
                        if tag then
                           sharedtags.viewonly(tag, screen)
                           -- tag:view_only()
                        end
                  end,
                  {}),
                  -- {description = "view tag #".. tagskeys[i], group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. tagskeycodes[i],
                  function ()
                      local screen = awful.screen.focused()
                      local tag = tags[i]
                      -- local tag = screen.tags[i]
                      if tag then
                         sharedtags.viewtoggle(tag, screen)
                         -- awful.tag.viewtoggle(tag)
                      end
                  end,
                  -- {description = "toggle tag #" .. tagskeys[i], group = "tag"}),
                  {}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. tagskeycodes[i],
                  function ()
                      if client.focus then
                          local tag = tags[i]
                          -- local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  -- {description = "move focused client to tag #".. tagskeys[i], group = "tag"}),
                  {}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. tagskeycodes[i],
                  function ()
                      if client.focus then
                          local tag = tags[i]
                          -- local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  -- {description = "toggle focused client on tag #" .. tagskeys[i], group = "tag"})
                  {})
})
end


function mic_border_reset()
  local c = client.focus
  if c then
    c.border_color         = "#7e5edc"
    beautiful.border_focus = "#7e5edc"
  end
end


-- Shortcuts by Freeo
awful.keyboard.append_global_keybindings({

    -- AUDIO
    awful.key({ modkey,         }, "6", function () awful.spawn.with_shell(
                "MICSRC=$(pactl list short sources | rg jack_in | cut -c 1-2 | xargs) && pactl set-source-mute $MICSRC toggle")
        end, {description = "Toggle Mic: Jack Source ", group = "Audio"}),
    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn.with_shell(
                "JACKOUT=$(pactl list short sinks | rg jack_out | cut -c 1-2 | xargs) && pactl set-sink-volume $JACKOUT +5%")
        end, {description = "Volume INCREASE jack_out", group = "Audio"}),
    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn.with_shell(
                "JACKOUT=$(pactl list short sinks | rg jack_out | cut -c 1-2 | xargs) && pactl set-sink-volume $JACKOUT -5%")
        end, {description = "Volume DECREASE jack_out", group = "Audio"}),
    awful.key({}, "XF86AudioMute", function() awful.spawn.with_shell(
                "JACKOUT=$(pactl list short sinks | rg jack_out | cut -c 1-2 | xargs) && pactl set-sink-mute $JACKOUT toggle")
        end, {description = "Volume DECREASE jack_out", group = "Audio"}),
    -- awful.key({ modkey }, "Next", function() awful.spawn.with_shell( -- PAGE UP = Prior
    --             "JACKOUT=$(pactl list short sinks | rg jack_out | cut -c 1-2 | xargs) && pactl set-sink-volume $JACKOUT +5%")
    --     end, {description = "Volume INCREASE jack_out", group = "Audio"}),
    -- awful.key({ modkey }, "Prior", function() awful.spawn.with_shell(  -- PAGE DOWN = Next
    --             "JACKOUT=$(pactl list short sinks | rg jack_out | cut -c 1-2 | xargs) && pactl set-sink-volume $JACKOUT -5%")
    --     end, {description = "Volume DECREASE jack_out", group = "Audio"}),

    -- *******************************
    --        DEBUG KEYBINDINGS
    -- *******************************
    -- awful.key({ modkey,"Control"  }, "t", function () naughty.notify({ title="KEYSTROKE Pulseevent", text="triggered by signal pulseevent"}) end,
              -- {description = "debug", group = "debug"}),
    -- awful.key({ modkey,"Control"  }, "t", function () awful.spawn.with_shell( "echo 'durr: " .. gears.filesystem.get_themes_dir() .. "' >> ~/workbench/awesome.log") end,
    --           {description = "output to log", group = "debug"}),

    -- DISPLAYS
    awful.key({ modkey,           }, "8", function () awful.screen.focus(1) end,
              {description = "Focus screen 1", group = "layout"}),
    awful.key({ modkey,           }, "9", function () awful.screen.focus(2) end,
              {description = "Focus screen 2", group = "layout"}),
    awful.key({ modkey,           }, "0", function () awful.screen.focus(2) end,
              {description = "Focus screen 3", group = "layout"}),

    -- VIDEO
    awful.key({ modkey,  "Control"}, "=", function () awful.spawn("xrandr --output DP-0 --mode 5120x1440 --rate 120 --output DP-5 --mode 1920x1080 --rate 60 --pos 5120x180") end,
              {description = "xrandr NeoG9+Toshiba", group = "xrandr"}),
    -- Toggle logic: https://unix.stackexchange.com/questions/315726/how-to-create-xrandr-output-toggle-script/484278
    awful.key({ modkey,  "Control"}, "8", function () awful.spawn.with_shell("xrandr --listactivemonitors | grep DP-0 >/dev/null && xrandr --output DP-0 --off || xrandr --output DP-0 --mode 5120x1440 --rate 120") end,
              {description = "toggle NeoG9", group = "xrandr"}),
    awful.key({ modkey,  "Control"}, "9", function () awful.spawn.with_shell("xrandr --listactivemonitors | grep DP-5 >/dev/null && xrandr --output DP-5 --off || xrandr --output DP-5 --mode 1920x1080 --rate 60 --pos 5120x180") end,
              {description = "toggle Toshiba", group = "xrandr"}),
    -- awful.key({ modkey,  "Control"}, "8", function () awful.spawn("xrandr --output DP-0 --off") end,
    --           {description = "turn off NeoG9", group = "xrandr"}),
    -- awful.key({ modkey,  "Control"}, "9", function () awful.spawn("xrandr --output DP-5 --off") end,
    --           {description = "turn off Toshiba", group = "xrandr"}),

    -- rofi -combi-modi window,drun,ssh -theme solarized -font "hack 10" -show combi -icon-theme "Papirus" -show-icons

    -- APPLICATIONS
    awful.key({ modkey,           }, "p", function () awful.spawn("rofi -show drun -show-icons") end,
              {description = "open rofi", group = "launcher"}),
    awful.key({ modkey,"Control"  }, "p", function () awful.spawn.with_shell(
                "rofi -show p -modi p:/home/$USER/.config/rofi/rofi-power-menu/rofi-power-menu") end,
              {description = "rofi power menu", group = "launcher"}),
    awful.key({ modkey, "Control" }, "Escape", function () awful.spawn("xsecurelock") end,
              {description = "open rofi", group = "launcher"}),
    awful.key({ modkey,           }, "Escape", function () awful.spawn(terminal) end,
              {description = "open terminal", group = "launcher"}),

    -- Philips Hue
    -- https://github.com/bahamas10/hue-cli
    -- awesome requires hue to be installed in the system node! nvm doesn't work and is hard to debug...
    awful.key({ modkey, "Shift" }, "#34", function () awful.spawn.with_shell("/usr/local/bin/hue lights all on") end,
              {description = "ON Hue Play Bars", group = "Hue"}),
    awful.key({ modkey, "Shift" }, "#35", function () awful.spawn.with_shell("/usr/local/bin/hue lights all off") end,
              {description = "OFF Hue Play Bars", group = "Hue"}),

    awful.key({ "Control", "Shift" }, 'b', function () awful.spawn("/usr/bin/diodon", {urgent = false, marked = false}) end,
        { description = 'clipboard manager', group = 'Applications' }),

    awful.key({ modkey,    "Shift" }, 'u', function () awful.spawn("pcmanfm", {urgent = false, marked = false}) end,
        { description = 'File Manager', group = 'Applications' }),

    -- always last entry, no comma
    awful.key({ modkey, "Shift"   }, "4", function () awful.spawn.with_shell(
        "flameshot gui"
        ) end,
              {description = "Screenshot flameshot", group = "layout"})
})


-- @DOC_CLIENT_BUTTONS@
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

-- @DOC_CLIENT_KEYBINDINGS@
client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey,           }, "w",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
    })
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
-- @DOC_RULES@
ruled.client.connect_signal("request::rules", function()
    -- @DOC_GLOBAL_RULE@
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- @DOC_FLOATING_RULE@
    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer",
                "QjackCtl", "Autokey", "Emote", "Signal"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- @DOC_DIALOG_RULE@
    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        -- @DOC_CSD_TITLEBARS@
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false      }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule {
    --     rule       = { class = "Firefox"     },
    --     properties = { screen = 1, tag = "2" }
    -- 
    ruled.client.append_rule {
        rule       = { class = "QjackCtl"     },
        properties = { tag = "bbb" }
    }
end)

-- }}}

-- {{{ Titlebars
-- @DOC_TITLEBARS@
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    awful.titlebar(c).widget = {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)


-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)

-- }}}

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:activate { context = "mouse_enter", raise = false }
-- end)

-- Not urgent on startup in different workspace
-- https://www.reddit.com/r/awesomewm/comments/nzqsdu/help_with_trying_to_disable_new_clients_being/
client.disconnect_signal("request::activate", awful.permissions.activate)
function awful.permissions.activate(c)
    if c:isvisible() then
        client.focus = c
        c:raise()
    end
end
client.connect_signal("request::activate", awful.permissions.activate)

-- Add rounded corners to clients
client.connect_signal("manage", function (c) c.shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,10) end end)

-- Border around Active window
-- https://www.reddit.com/r/awesomewm/comments/k7znc4/how_do_i_add_borders_to_active_window_and_make/
-- dotted border:
-- https://www.reddit.com/r/awesomewm/comments/cwv1wo/dotted_border_around_active_window/

beautiful.border_width = "8"
beautiful.useless_gap = "0"
beautiful.border_focus = "#7e5edc"
beautiful.border_normal = "#303030"


screen.connect_signal("arrange", function (s)
    -- local max = s.selected_tag.layout.name == "max"
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        -- if (max or only_one) and not c.floating or c.maximized then
        if (only_one) and not c.floating or c.maximized then
            -- workaround until top bar color shows micstate
            -- c.border_width = 0
            c.border_width = 8
        else
            c.border_width = beautiful.border_width
        end
    end
end)

client.connect_signal("focus", function(c)
  c.opacity = 1
  c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)



-- Autostart

-- https://www.reddit.com/r/awesomewm/comments/k3wkb2/how_can_i_stop_extra_startup_background_programs/
function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end
    if not pname then
        pname = prg
    end
    if not arg_string then
        awful.spawn.with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")")
    else
        awful.spawn.with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. arg_string .. ")")
    end
end

-- pgrep -f -x "/usr/bin/python3 /usr/bin/redshift-gtk"
-- if [[ $(pactl get-source-mute 7) = "Mute: no" ]]; then echo "muted"; fi


client.connect_signal("jack_source_off", function()
  mic_border_reset()
end)

client.connect_signal("jack_source_on", function()
  local c = client.focus
  if c then
    -- local color_highlight_mic_on = "#B200FF"
    local color_highlight_mic_on = "#DD00FF"
    c.border_color         = color_highlight_mic_on
    beautiful.border_focus = color_highlight_mic_on
  end
end)

-- mictoggle_script watches for "change" events in pulseaudio event stream.
-- Upon a valid change, it checks the state of pulseaudio source "jack_in" and emits the respective awesome signal via awesome-client
-- Notes on the script:
-- since "pactl subscribe" is a stream, there's two things to incorporate:
--   "--line-buffered" streams rg results, as rg never quits and therefore doesn't have an exit code
--   not having an exit code means you can't chain with &&
-- tried multiple receiving programs, but so far only "read line" works as desired
-- "read line" reads on stdin while rg is still running
MICTOGGLE_SCRIPT = [=[
#!/bin/bash

pactl subscribe | rg --line-buffered "Event 'change' on source" | \
while read line ; do
  MICSRC=$(pactl list short sources | rg jack_in | cut -c 1-2 | xargs) && echo $MICSRC
  MUTE_STATUS=$(pactl get-source-mute $MICSRC)
  if [[ $MUTE_STATUS = "Mute: yes" ]]; then
    awesome-client 'client.emit_signal("jack_source_off")'
  elif [[ $MUTE_STATUS = "Mute: no" ]]; then
    awesome-client 'client.emit_signal("jack_source_on")'
  fi
done
]=]

awful.spawn.with_shell(MICTOGGLE_SCRIPT)



run_once("picom")
-- run_once("volumeicon")
-- run_once("mictray")
run_once("nm-applet")
run_once("dunst")
run_once("redshift-gtk","","/usr/bin/python3 /usr/bin/redshift-gtk")
run_once("autokey","","/usr/bin/python3 /usr/bin/autokey")
run_once("emote","", "python3 /snap/emote/19/bin/emote")
run_once("nitrogen","--restore &")
run_once("xbindkeys","&")
run_once("/usr/bin/diodon")
run_once("qjackctl")

-- Virtual Screens for Neo G9 screen sharing in MS Teams: 2x 2560x1440 instead of 5120x1440
awful.spawn.with_shell("xrandr --setmonitor VScreenLeft 2560/0x1440/1+0+0 none")
awful.spawn.with_shell("xrandr --setmonitor VScreenRight 2560/0x1440/1+2560+0 none")

awful.spawn.with_shell("xset r rate 180 40")

awful.spawn.with_shell("eval `ssh-agent -s`")
awful.spawn.with_shell("ssh-add")

