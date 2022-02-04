
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

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
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- shared tags across monitors
local sharedtags = require("awesome-sharedtags")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_themes_dir() .. "xresources/theme.lua")
-- beautiful.init("./themes/copland/theme.lua")

-- This is used later as the default terminal and editor to run.
-- terminal = "x-terminal-emulator"
terminal = "kitty"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"


-- -- Fake Screens
-- ---- Ratio that screen is split
-- local ratio = 0.67 -- 0.6465
-- -- Default resize amount
-- local resize_default_amount = 10
-- -- Table that holds all active fake screen variables
-- local screens = {}
-- -- Modkeys
-- local altkey = 'Mod1' -- Alt


-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    -- awful.layout.suit.corner.nw,

    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
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
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)


awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "fox", "emc", "tty", "f", "teams", "music", "x", "c", "v", "sys" }, s, awful.layout.layouts[1])
    -- Here is a good place to add tags to a newly connected screen, if desired:
    -- sharedtags.viewonly(tags[4], s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
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
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
--



-- -- Fake Screens

-- local function screen_has_fake(s)
--   s = s or awful.screen.focused()
--   return s.has_fake or s.is_fake
-- end

-- local function create_fake(s)
--   -- If screen was not passed
--   s = s or awful.screen.focused()
--   -- If already is or has fake
--   if screen_has_fake(s) then return end
--   -- Create variables
--   local geo = s.geometry
--   local real_w = math.floor(geo.width * ratio)
--   local fake_w = geo.width - real_w
--   -- Index for cleaner code
--   local index = tostring(s.index)
--   -- Set initial sizes into memory
--   screens[index] = {}
--   screens[index].geo = geo
--   screens[index].real_w = real_w
--   screens[index].fake_w = fake_w
--   -- Create if doesn't exist
--   -- Resize screen
--   s:fake_resize(geo.x, geo.y, real_w, geo.height)
--   -- Create fake for screen
--   s.fake = _G.screen.fake_add(
--     geo.x + real_w,
--     geo.y,
--     fake_w,
--     geo.height
--   )
--   s.fake.parent = s
--   -- Mark screens
--   s.fake.is_fake = true
--   s.has_fake = true
--   -- Change status
--   s.fake.is_open = true
--   -- Because memory leak
--   collectgarbage('collect')
--   -- Emit signal
--   s:emit_signal('fake_created')
-- end

-- local function remove_fake(s)
--   -- Return if no screen presented
--   s = s or awful.screen.focused()
--   -- Ge real screen if fake was focused
--   if s.is_fake then s = s.parent end
--   -- If screen doesn't have fake
--   if not s.has_fake then return end
--   -- Index for cleaner code
--   local index = tostring(s.index)
--   s:fake_resize(
--     screens[index].geo.x,
--     screens[index].geo.y,
--     screens[index].geo.width,
--     screens[index].geo.height
--   )
--   -- Remove and handle variables
--   s.fake:fake_remove()
--   s.has_fake = false
--   s.fake = nil
--   screens[index] = {}
--   -- Because memory leaks
--   collectgarbage('collect')
--   -- Emit signal
--   s:emit_signal('fake_created')
-- end

-- -- Toggle fake screen
-- local function toggle_fake(s)
--   -- No screen given as parameter
--   s = s or awful.screen.focused()
--   -- If screen doesn't have fake or isn't fake
--   if not s.has_fake and not s.is_fake then return end
--   -- Ge real screen if fake was focused
--   if s.is_fake then s = s.parent end
--   -- Index for cleaner code
--   local index = tostring(s.index)
--   -- If fake was open
--   if s.fake.is_open then
--     -- Resize real screen to be initial size
--     s:fake_resize(
--       screens[index].geo.x,
--       screens[index].geo.y,
--       screens[index].geo.width,
--       screens[index].geo.height
--     )
--     -- Resize fake to 1px 'out of the view'
--     -- 0px will move clients out of the screen.
--     -- On multi monitor setups it will show up
--     -- on screen on right side of the screen we're handling
--     s.fake:fake_resize(
--       screens[index].geo.width,
--       screens[index].geo.y,
--       1,
--       screens[index].geo.height
--     )
--     -- Mark fake as hidden
--     s.fake.is_open = false
--   else -- Fake was selected
--     -- Resize screens
--     s:fake_resize(
--       screens[index].geo.x,
--       screens[index].geo.y,
--       screens[index].real_w,
--       screens[index].geo.height
--     )
--     s.fake:fake_resize(
--       screens[index].geo.x + screens[index].real_w,
--       screens[index].geo.y,
--       screens[index].fake_w,
--       screens[index].geo.height
--     )
--     -- Mark fake as open
--     s.fake.is_open = true
--   end
--   -- Because memory leaks
--   collectgarbage('collect')
--   -- Emit signal
--   s:emit_signal('fake_toggle')
-- end

-- -- Resize fake with given amount in pixels
-- local function resize_fake(amount, s)
--   -- No screen given
--   s = s or awful.screen.focused()
--   amount = amount or resize_default_amount
--   -- Ge real screen if fake was focused
--   if s.is_fake then s = s.parent end
--   -- Index for cleaner code
--   local index = tostring(s.index)
--   -- Resize only if fake is open
--   if s.fake.is_open then
--     -- Modify width variables
--     screens[index].real_w = screens[index].real_w + amount
--     screens[index].fake_w = screens[index].fake_w - amount
--     -- Resize screens
--     s:fake_resize(
--       screens[index].geo.x,
--       screens[index].geo.y,
--       screens[index].real_w,
--       screens[index].geo.height
--     )
--     s.fake:fake_resize(
--       screens[index].geo.x + screens[index].real_w,
--       screens[index].geo.y,
--       screens[index].fake_w,
--       screens[index].geo.height
--     )
--   end
--   -- Because memory leak
--   collectgarbage('collect')
--   -- Emit signal
--   s:emit_signal('fake_resize')
-- end

-- -- Reset screen widths to default value
-- local function reset_fake(s)
--   -- No sreen given
--   s = s or awful.screen.focused()
--   -- Get real screen if fake was focused
--   if s.is_fake then s = s.parent end
--   -- In case screen doesn't have fake
--   if not s.has_fake then return end
--   -- Index for cleaner code
--   local index = tostring(s.index)
--   if s.fake.is_open then
--     screens[index].real_w = math.floor(screens[index].geo.width * ratio)
--     screens[index].fake_w = screens[index].geo.width - screens[index].real_w
--     s:fake_resize(
--       screens[index].geo.x,
--       screens[index].geo.y,
--       screens[index].real_w,
--       screens[index].geo.height
--     )
--     s.fake:fake_resize(
--       screens[index].real_w,
--       screens[index].geo.y,
--       screens[index].geo.width - screens[index].real_w,
--       screens[index].geo.height
--     )
--   end
--   -- Because memory leak
--   collectgarbage('collect')
--   -- Emit signal
--   s:emit_signal('fake_reset')
-- end



-- -- Signals, maybe useful for keybinds. s = screen, a = amount
-- _G.screen.connect_signal('remove_fake', function(s) remove_fake(s) end)
-- _G.screen.connect_signal('toggle_fake', function(s) toggle_fake(s) end)
-- _G.screen.connect_signal('create_fake', function(s) create_fake(s) end)
-- _G.screen.connect_signal('resize_fake', function(a, s) resize_fake(a, s) end)
-- _G.screen.connect_signal('reset_fake', function(s) reset_fake(s) end)






-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "e",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    -- awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    --           {description = "go back", group = "tag"}),

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
    awful.key({ modkey,           }, "t", function () mymainmenu:show() end, -- default: "w"
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    -- awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    --           {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

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



    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    -- awful.key({ modkey }, "n", -- default: "x"
    --           function ()
    --               awful.prompt.run {
    --                 prompt       = "Run Lua code: ",
    --                 textbox      = awful.screen.focused().mypromptbox.widget,
    --                 exe_callback = awful.util.eval,
    --                 history_path = awful.util.get_cache_dir() .. "/history_eval"
    --               }
    --           end,
    --           {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey, "Shift" }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),


    -- Freeo
    awful.key({ modkey,           }, "8", function () awful.screen.focus(1) end,
              {description = "Focus screen 1", group = "layout"}),
    awful.key({ modkey,           }, "9", function () awful.screen.focus(2) end,
              {description = "Focus screen 2", group = "layout"}),
    awful.key({ modkey,           }, "0", function () awful.screen.focus(2) end,
              {description = "Focus screen 3", group = "layout"}),

    awful.key({ modkey,  "Control"}, "=", function () awful.spawn("xrandr --output DP-0 --mode 5120x1440 --rate 120 --output DP-5 --mode 1920x1080 --rate 60 --pos 5120x180") end,
              {description = "xrandr NeoG9+Toshiba", group = "xrandr"}),
    -- Toggle logic: https://unix.stackexchange.com/questions/315726/how-to-create-xrandr-output-toggle-script/484278
    awful.key({ modkey,  "Control"}, "8", function () awful.util.spawn_with_shell("xrandr --listactivemonitors | grep DP-0 >/dev/null && xrandr --output DP-0 --off || xrandr --output DP-0 --mode 5120x1440 --rate 120") end,
              {description = "toggle NeoG9", group = "xrandr"}),
    awful.key({ modkey,  "Control"}, "9", function () awful.util.spawn_with_shell("xrandr --listactivemonitors | grep DP-5 >/dev/null && xrandr --output DP-5 --off || xrandr --output DP-5 --mode 1920x1080 --rate 60 --pos 5120x180") end,
              {description = "toggle Toshiba", group = "xrandr"}),

    -- awful.key({ modkey,  "Control"}, "8", function () awful.spawn("xrandr --output DP-0 --off") end,
    --           {description = "turn off NeoG9", group = "xrandr"}),
    -- awful.key({ modkey,  "Control"}, "9", function () awful.spawn("xrandr --output DP-5 --off") end,
    --           {description = "turn off Toshiba", group = "xrandr"}),

    awful.key({ modkey,           }, "p", function () awful.spawn("rofi -show drun") end,
              {description = "open rofi", group = "launcher"}),

    awful.key({ modkey, "Control" }, "Escape", function () awful.spawn("xsecurelock") end,
              {description = "open rofi", group = "launcher"}),

    awful.key({ modkey,           }, "Escape", function () awful.spawn("kitty", {urgent = false, marked = false}) end,
              {description = "open kitty", group = "launcher"}),


    -- -- Fake Screens
    -- -- Toggle/hide fake screen
    -- awful.key({ modkey }, 'F3',
    --     function()
    --     _G.screen.emit_signal('toggle_fake')
    --     end,
    -- { description = 'show/hide fake screen', group = 'fake screen' }),

    -- -- Create or remove
    -- awful.key({ modkey, altkey }, 'F3',
    --     function()
    --     if screen_has_fake() then
    --         _G.screen.emit_signal('remove_fake')
    --     else
    --         _G.screen.emit_signal('create_fake')
    --     end
    --     end,
    -- { description = 'create/remove fake screen', group = 'fake screen' }),

    -- -- Increase fake screen size
    -- awful.key({ modkey, altkey }, 'Left',
    --     function()
    --     _G.screen.emit_signal('resize_fake', -10)
    --     end,
    -- { description = 'resize fake screen', group = 'fake screen' }),

    -- -- Decrease fake screen size
    -- awful.key({ modkey, altkey }, 'Right',
    --     function()
    --     _G.screen.emit_signal('resize_fake', 10)
    --     end,
    --     { description = 'resize fake screen', group = 'fake screen' }),

    -- -- Reset screen sizes to initial size
    -- awful.key({ modkey, altkey }, 'r',
    --     function()
    --     _G.screen.emit_signal('reset_fake')
    --     end,
    --     { description = 'reset fake screen size', group = 'fake screen' }),

    awful.key({ "Control", "Shift" }, 'b', function () awful.spawn("/usr/bin/diodon", {urgent = false, marked = false}) end,
        { description = 'reset fake screen size', group = 'fake screen' }),


    -- always last entry, no comma
    -- replaced by flameshot
    -- awful.key({ modkey, "Shift"   }, "4", function () awful.util.spawn_with_shell(
    --     "sleep 0.5 && scrot -s -e 'mv $f ~/Pictures/Scrots'"
    --     ) end,
    --           {description = "Screenshot selection ", group = "layout"})
    awful.key({ modkey, "Shift"   }, "4", function () awful.util.spawn_with_shell(
        "flameshot gui"
        ) end,
              {description = "Screenshot flameshot", group = "layout"})

)

clientkeys = gears.table.join(
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
    -- awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
    --           {description = "toggle keep on top", group = "client"}),
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

    awful.key({ modkey, "Control" }, "backslash",
      function (c)
        awful.titlebar.toggle(c) end,
        {description = 'toggle title bar', group = 'client'})

)


-- a 38 g 42
-- z 52 b 56
-- q 24 t 28
-- local tags = {a=38, s=39,d=40, f=41, g=42,
              -- z=52, x=53, c=54, v=55, b=56,
              -- q=24, w=25, e=26, r=27, t=28,
                -- }

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

-- awful.tag({ "fox", "emc", "tty", "f", "teams", "music", "x", "c", "v", "sys" }, s, awful.layout.layouts[1])

for i, _ in ipairs(tags) do
    globalkeys = gears.table.join(globalkeys,
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
                  {description = "view tag #".. tagskeys[i], group = "tag"}),
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
                  {description = "toggle tag #" .. tagskeys[i], group = "tag"}),
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
                  {description = "move focused client to tag #".. tagskeys[i], group = "tag"}),
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
                  {description = "toggle focused client on tag #" .. tagskeys[i], group = "tag"})
    )
end



-- -- Bind all key numbers to tags.
-- -- Be careful: we use keycodes to make it work on any keyboard layout.
-- -- This should map on the top row of your keyboard, usually 1 to 9.
-- for i = 1, 9 do
--     globalkeys = gears.table.join(globalkeys,
--         -- View tag only.
--         awful.key({ modkey }, "#" .. i + 9,
--                   function ()
--                         local screen = awful.screen.focused()
--                         local tag = screen.tags[i]
--                         if tag then
--                            tag:view_only()
--                         end
--                   end,
--                   {description = "view tag #"..i, group = "tag"}),
--         -- Toggle tag display.
--         awful.key({ modkey, "Control" }, "#" .. i + 9,
--                   function ()
--                       local screen = awful.screen.focused()
--                       local tag = screen.tags[i]
--                       if tag then
--                          awful.tag.viewtoggle(tag)
--                       end
--                   end,
--                   {description = "toggle tag #" .. i, group = "tag"}),
--         -- Move client to tag.
--         awful.key({ modkey, "Shift" }, "#" .. i + 9,
--                   function ()
--                       if client.focus then
--                           local tag = client.focus.screen.tags[i]
--                           if tag then
--                               client.focus:move_to_tag(tag)
--                           end
--                      end
--                   end,
--                   {description = "move focused client to tag #"..i, group = "tag"}),
--         -- Toggle tag on focused client.
--         awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
--                   function ()
--                       if client.focus then
--                           local tag = client.focus.screen.tags[i]
--                           if tag then
--                               client.focus:toggle_tag(tag)
--                           end
--                       end
--                   end,
--                   {description = "toggle focused client on tag #" .. i, group = "tag"})
--     )
-- end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
          "QjackCtl",
          "Autokey",
          "Emote",
          "Signal"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
      -- properties = { screen = 1, tag = "fox" } },
    -- { rule = { class = "Emacs" },
      -- properties = { tag = "emx", maximized = true } },
      -- properties = { tag = "emx" } },
    { rule = { class = "QjackCtl" },
      properties = { tag = "bbb" } },
    -- { rule = { class = "Microsoft Teams - Preview" },
      -- properties = { tag = "ggg"} },

    { rule = { class = "Emote" },
      properties = { titlebars_enabled= false } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- hide titlebar (close/max/float etc.)
    awful.titlebar.hide(c)
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
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

-- Enable sloppy focus, so that focus follows mouse.
-- Annoying...
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

-- not working with copland theme
-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

client.disconnect_signal("request::activate", awful.ewmh.activate)
function awful.ewmh.activate(c)
    if c:isvisible() then
        client.focus = c
        c:raise()
    end
end
client.connect_signal("request::activate", awful.ewmh.activate)

-- Add rounded corners to clients
client.connect_signal("manage", function (c) c.shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,10) end end)

-- Border around Active window
-- https://www.reddit.com/r/awesomewm/comments/k7znc4/how_do_i_add_borders_to_active_window_and_make/
-- dotted border:
-- https://www.reddit.com/r/awesomewm/comments/cwv1wo/dotted_border_around_active_window/

beautiful.border_width = "8"
beautiful.useless_gap = "0"
beautiful.border_focus = "#7e5edc"

screen.connect_signal("arrange", function (s)
    -- local max = s.selected_tag.layout.name == "max"
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        -- if (max or only_one) and not c.floating or c.maximized then
        if (only_one) and not c.floating or c.maximized then
            c.border_width = 0
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



-- awful.spawn.with_shell(
--        'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
--        'xrdb -merge <<< "awesome.started:true";' ..
--        -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
--        'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
--        )

-- https://www.reddit.com/r/awesomewm/comments/k3wkb2/how_can_i_stop_extra_startup_background_programs/
function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end
    if not pname then
        pname = prg
    end
    if not arg_string then
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end

-- pgrep -f -x "/usr/bin/python3 /usr/bin/redshift-gtk"


run_once("picom")
run_once("volumeicon")
run_once("nm-applet")
run_once("dunst")
run_once("redshift-gtk","","/usr/bin/python3 /usr/bin/redshift-gtk")
run_once("autokey","","/usr/bin/python3 /usr/bin/autokey")
run_once("emote","", "python3 /snap/emote/19/bin/emote")
run_once("nitrogen","--restore &")
run_once("xbindkeys","&")
run_once("/usr/bin/diodon")

-- Virtual Screens for Neo G9 screen sharing in MS Teams: 2x 2560x1440 instead of 5120x1440
awful.util.spawn_with_shell("xrandr --setmonitor VScreenLeft 2560/0x1440/1+0+0 none")
awful.util.spawn_with_shell("xrandr --setmonitor VScreenRight 2560/0x1440/1+2560+0 none")

awful.util.spawn_with_shell("xset r rate 180 40")


-- Autostart
-- awful.spawn("picom")
-- awful.spawn.single_instance("volumeicon")
-- awful.spawn("nm-applet")
-- awful.spawn("dunst")
-- awful.spawn.single_instance("redshift-gtk")
-- awful.spawn("autokey", {tag = "bbb"})
-- awful.spawn("emote", {tag = "bbb"})
-- awful.spawn("nitrogen --restore &")
-- awful.spawn("xbindkeys &")

-- awful.spawn("firefox")
-- awful.spawn("emacs" ,{tag = "emx", urgent = false })
-- awful.spawn("emacs" ,{tag = "vvv", urgent = false })
-- awful.spawn("google-chrome")
-- awful.spawn("kitty", {tag = "eee", maximized = false, urgent = false})
-- awful.spawn("qjackctl", {tag = "sys", urgent = false})
