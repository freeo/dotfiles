local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

-- {{{ Key bindings
-- @DOC_GLOBAL_KEYBINDINGS@

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "e", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    -- {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Control", "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, "Control", "Shift" }, "e", function()
        awful.prompt.run({
            prompt = "Run Lua code: ",
            textbox = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval",
        })
    end, { description = "lua execute prompt", group = "awesome" }),
    awful.key({ "Mod1" }, "Escape", function()
        -- If you want to always position the menu on the same place set coordinates
        awful.menu.menu_keys.down = { "Down", "Alt_L" }
        awful.menu.clients({ theme = { width = 250 } }, { keygrabber = true, coords = { x = 525, y = 330 } })
    end, { description = "client list", group = "awesome" }),

    awful.key({ modkey }, "Return", function()
        awful.spawn(terminal)
    end, { description = "open terminal fallback", group = "launcher" }),
    awful.key({ modkey }, "Escape", function()
        -- awful.spawn("/home/freeo/dotfiles/scripts/kitty-color.sh")
        awful.spawn("kitty")
    end, { description = "open kitty-color", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", function()
        awful.screen.focused().mypromptbox:run()
    end, { description = "run prompt", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "p", function()
        menubar.show()
    end, { description = "show the menubar", group = "launcher" }),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
    awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
    awful.key({ modkey }, "Delete", awful.tag.history.restore, { description = "go back", group = "tag" }),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "j", function()
        awful.client.focus.byidx(1)
    end, { description = "focus next by index", group = "client" }),
    -- Alt+Tab
    awful.key({"Mod1"}, "Tab", function()
        awful.client.focus.byidx(1)
    end, { description = "focus next by index", group = "client" }),
    awful.key({ modkey }, "k", function()
        awful.client.focus.byidx(-1)
    end, { description = "focus previous by index", group = "client" }),

    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function()
        awful.screen.focus_relative(1)
    end, { description = "focus the dnext screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function()
        awful.screen.focus_relative(-1)
    end, { description = "focus the previous screen", group = "screen" }),
    -- awful.key({ modkey, "Control" }, "n", function()
    --     local c = awful.client.restore()
    --     -- Focus restored client
    --     if c then
    --         c:activate({ raise = true, context = "key.unminimize" })
    --     end
    -- end, { description = "restore minimized", group = "client" }),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift" }, "j", function()
        awful.client.swap.byidx(1)
    end, { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function()
        awful.client.swap.byidx(-1)
    end, { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey }, "h", function()
        awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey }, "l", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),
    -- awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
    --     { description = "increase the number of master clients", group = "layout" }),
    -- awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
    --     { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function()
        awful.tag.incncol(1, nil, true)
    end, { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function()
        awful.tag.incncol(-1, nil, true)
    end, { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey }, "space", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function()
        awful.layout.inc(-1)
    end, { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Shift" }, "l", function()
        awful.client.incwfact(-0.05)
    end),
    awful.key({ modkey, "Shift" }, "h", function()
        awful.client.incwfact(0.05)
    end),
})

-- Keybindings by Freeo
awful.keyboard.append_global_keybindings({

    -- SYSTEM
    awful.key({ "Ctrl", "Alt_L" }, "Delete", function()
        awful.spawn.with_shell("sudo pkill -f '/usr/lib/Xorg'")
    end, { description = "Kill Xorg", group = "System" }),

    awful.key({ modkey, "Shift" }, "w", function()
        awful.spawn.with_shell("xkill")
    end, { description = "xkill", group = "System" }),

    -- LAYOUT
    awful.key({ modkey }, "t", revelation, { description = "Revelation", group = "awesome" }),

    -- machi
    awful.key({ modkey }, "/", function()
        editor.start_interactive(awful.screen.focused())
    end, { description = "Machi Editor", group = "machi" }),

    awful.key({ modkey }, "Tab", function()
        machi.switcher.start()
    end, { description = "Machi Switcher", group = "machi" }),

    -- AUDIO
    awful.key({
        modifiers = { modkey, "Mod1" },
        key = "6",
        on_press = function()
            microphone.Toggle()
        end,
        description = "Toggle Mic: Jack Source ",
        group = "Audio",
    }),
    -- awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn.with_shell(
    --             "JACKOUT=$(pactl list short sinks | rg jack_out | cut -c 1-2 | xargs) && pactl set-sink-volume $JACKOUT +5%")
    --     end, {description = "Volume INCREASE jack_out", group = "Audio"}),
    -- awful.key({}, "XF86AudioLowerVolume", function() awful.spawn.with_shell(
    --             "JACKOUT=$(pactl list short sinks | rg jack_out | cut -c 1-2 | xargs) && pactl set-sink-volume $JACKOUT -5%")
    --     end, {description = "Volume DECREASE jack_out", group = "Audio"}),
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn.with_shell(
            "JACKOUT=$(pactl list short sinks | rg Focusrite | cut -f 1 | xargs) && pactl set-sink-volume $JACKOUT +5%"
        )
        awesome.emit_signal("volume_change")
    end, { description = "Volume INCREASE jack_out", group = "Audio" }),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn.with_shell(
            "JACKOUT=$(pactl list short sinks | rg Focusrite | cut -f 1 | xargs) && pactl set-sink-volume $JACKOUT -5%"
        )
        awesome.emit_signal("volume_change")
    end, { description = "Volume DECREASE jack_out", group = "Audio" }),
    awful.key({}, "XF86AudioMute", function()
        awful.spawn.with_shell(
            "JACKOUT=$(pactl list short sinks | rg Focusrite | cut -f 1 | xargs) && pactl set-sink-mute $JACKOUT toggle"
        )
        awesome.emit_signal("volume_change")
    end, { description = "Volume DECREASE jack_out", group = "Audio" }),
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
    --           screen.dpi
    -- awful.key({ modkey,"Control"  }, "t", function () awful.spawn.with_shell( "echo 'dpi: " .. client.focus.screen.dpi .. "' >> ~/workbench/awesome.log") end,
    --           {description = "output to log", group = "debug"}),

    -- DISPLAYS
    awful.key({ modkey }, "8", function()
        awful.screen.focus(1)
        awesome.emit_signal("screen_change")
    end, { description = "Focus screen 1", group = "layout" }),
    awful.key({ modkey }, "9", function()
        awful.screen.focus(2)
        awesome.emit_signal("screen_change")
    end, { description = "Focus screen 2", group = "layout" }),
    awful.key({ modkey }, "0", function()
        awful.screen.focus(2)
    end, { description = "Focus screen 3", group = "layout" }),

    -- VIDEO
    -- XXX make this fallback save! Identify 5120x1440 monitor by xrandr output and use that instead of
    -- possible dynamic values like DP-0,DP-4,DP-5 etc.
    awful.key({ modkey, "Control" }, "=", function()
        awful.spawn(
            "xrandr --output DP-0 --mode 5120x1440 --rate 120 --dpi 144 --output HDMI-0 --mode 1920x1080 --rate 60 --pos 5120x180 --dpi 96"
        )
    end, { description = "xrandr NeoG9+Toshiba", group = "xrandr" }),
    -- awful.key({ modkey, "Control" }, "7",
    --     function() awful.spawn("xrandr --output DP-0 --mode 5120x1440 --rate 120 --dpi 144 --output HDMI-0 --off") end,
    --     { description = "only NeoG9", group = "xrandr" }),
    awful.key(
        { modkey, "Control" },
        "8",
        -- function() awful.spawn.with_shell("xrandr --listactivemonitors | grep DP-0 >/dev/null && { xrandr --output DP-0 --off ; pw-play /usr/lib/libreoffice/share/gallery/sounds/pluck.wav & ; } || { xset dpms force on ; xrandr --output DP-0 --mode 5120x1440 --rate 120 --dpi 144 ; pw-play /usr/lib/libreoffice/share/gallery/sounds/apert.wav & ; }") end,
        -- function() awful.spawn.with_shell("xrandr --listactivemonitors | grep DP-0 >/dev/null && { xrandr --output DP-0 --off; pw-play /usr/lib/libreoffice/share/gallery/sounds/pluck.wav ;} || { xset dpms force off ; sleep 1; xset dpms force on ; sleep 1; xrandr --output DP-0 --mode 5120x1440 --rate 120 --dpi 144 ; pw-play /usr/lib/libreoffice/share/gallery/sounds/apert.wav; }") end,
        -- function() awful.spawn.with_shell("xrandr --listactivemonitors | grep DP-0 >/dev/null && { xrandr --output DP-0 --off; pw-play /usr/share/sounds/Yaru/stereo/power-unplug.oga;} || /home/freeo/dotfiles/scripts/neog9_ON.sh") end,
        function()
            awful.spawn.with_shell("bash /home/freeo/dotfiles/scripts/toggle_neog9.sh")
        end,
        { description = "toggle NeoG9", group = "xrandr" }
    ),
    -- Toggle logic: https://unix.stackexchange.com/questions/315726/how-to-create-xrandr-output-toggle-script/484278
    awful.key({ modkey, "Control" }, "7", function()
        awful.spawn.with_shell(
            "xrandr --listactivemonitors | grep DP-0 >/dev/null && xrandr --output DP-0 --off || xrandr --output DP-0 --mode 5120x1440 --rate 120 --dpi 144"
        )
    end, { description = "toggle NeoG9 OLD", group = "xrandr" }),
    awful.key({ modkey, "Control" }, "6", function()
        awful.spawn.with_shell(
            "xrandr --output DP-0 --mode 1920x1080 && sleep 2.5 && xrandr --output DP-0 --mode 5120x1440 --dpi 144 && pw-play /usr/share/sounds/Yaru/stereo/power-plug.oga"
        )
    end, { description = "Fallback: turn on NeoG9", group = "xrandr" }),
    awful.key({ modkey, "Control" }, "9", function()
        awful.spawn.with_shell(
            "xrandr --listactivemonitors | grep HDMI-0 >/dev/null && xrandr --output HDMI-0 --off || xrandr --output HDMI-0 --mode 1920x1080 --rate 60 --pos 5120x0 --dpi 96"
        )
    end, { description = "toggle Toshiba", group = "xrandr" }),
    -- awful.key({ modkey,  "Control"}, "8", function () awful.spawn("xrandr --output DP-0 --off") end,
    --           {description = "turn off NeoG9", group = "xrandr"}),
    -- awful.key({ modkey,  "Control"}, "9", function () awful.spawn("xrandr --output DP-5 --off") end,
    --           {description = "turn off Toshiba", group = "xrandr"}),

    -- rofi -combi-modi window,drun,ssh -theme solarized -font "hack 10" -show combi -icon-theme "Papirus" -show-icons

    -- AWM INTERNAL: client
    --

    -- APPLICATIONS
    awful.key({ modkey }, "p", function()
        awful.spawn("rofi -show drun -show-icons")
    end, { description = "open rofi", group = "launcher" }),
    awful.key({ modkey, "Control" }, "p", function()
        awful.spawn.with_shell("rofi -show p -modi p:/home/$USER/.config/rofi/rofi-power-menu_freeo/rofi-power-menu")
    end, { description = "rofi power menu", group = "launcher" }),
    awful.key({ modkey, "Control" }, "Escape", function()
        awful.spawn("xsecurelock")
    end, { description = "open rofi", group = "launcher" }),
    awful.key({ modkey, "Control" }, "e", function()
        awful.spawn.with_shell("rofi -show emoji -modi emoji")
    end, { description = "rofi emoji", group = "launcher" }),

    -- Philips Hue
    -- https://github.com/bahamas10/hue-cli
    -- awesome requires hue to be installed in the system node! nvm doesn't work and is hard to debug...
    -- awful.key({ modkey, "Shift" }, "#34", function () awful.spawn.with_shell("/usr/local/bin/hue lights all on") end,
    --           {description = "ON Hue Play Bars", group = "Hue"}),
    -- awful.key({ modkey, "Shift" }, "#35", function () awful.spawn.with_shell("/usr/local/bin/hue lights all off") end,
    --           {description = "OFF Hue Play Bars", group = "Hue"}),

    -- awful.key({ "Control", "Shift" }, "b",
    --     function() awful.spawn("/usr/bin/diodon", { urgent = false, marked = false }) end,
    --     { description = 'clipboard manager', group = 'Applications' }),
    -- awful.key({ "Control", "Shift" }, "b",
    --     function() awful.spawn("/usr/bin/diodon", { urgent = false, marked = false }) end,
    --     { description = 'clipboard manager', group = 'Applications' }),

    -- awful.key({ modkey, "Shift" }, "u", function() awful.spawn("pcmanfm", { urgent = false, marked = false }) end,
    --     { description = 'File Manager', group = 'Applications' }),

    awful.key({ modkey, "Shift" }, "u", function()
        awful.spawn("thunar", { urgent = false, marked = false })
        -- awful.spawn("pcmanfm", { urgent = false, marked = false })
    end, { description = "File Manager", group = "Applications" }),

    awful.key({ modkey, "Control" }, "c", function()
        awful.spawn("/home/freeo/bin/Chrysalis-0.12.0.AppImage")
    end, { description = "open Chrysalis", group = "Applications" }),

    awful.key({ modkey, "Shift" }, "4", function()
        awful.spawn.with_shell("flameshot gui")
    end, { description = "Screenshot flameshot", group = "Applications" }),

    awful.key({ modkey, "Shift", "Control" }, "4", function()
        awful.spawn.with_shell(
            [=[
            flameshot gui --last-region --accept-on-select --path ~/Pictures/flameshots/series/
            -- wait for this to be solved:
            -- https://github.com/flameshot-org/flameshot/issues/3679
            -- if [ $? -eq 0 ]; then
            --     pw-play /usr/share/sounds/Yaru/stereo/bell.oga
            -- fi
            ]=])
    end, { description = "Screenshot flameshot", group = "Applications" }),

    awful.key({ modkey, "Shift" }, "6", function()
            -- simplescreenrecorder
    end, { description = "Screenshot flameshot", group = "Applications" }),

    awful.key({ modkey }, "F11", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),

    -- always last entry, no comma
    awful.key({ modkey, "Shift" }, "5", function()
        awful.spawn("gpick", { urgent = false, marked = false })
    end, { description = "File Manager", group = "Applications" }),
})


local dictation = require("widgets.dictation")

awful.keyboard.append_global_keybindings({

    -- Dictation
    awful.key({
        modifiers = { modkey },
        key = "Prior",
        on_press = function()
            dictation.Toggle()
        end,
        description = "Dictation Toggle",
        group = "Applications",
    }),

    awful.key({ modkey, "Control", "Shift" }, "b", function()
        awful.spawn("rofi-rbw")
        -- awful.spawn("bwmenu") -- bit outdated, doesn't work ootb from paru: bitwarden-rofi
    end, { description = "launch Bitwarden-Rofi", group = "launcher" }),
})


function GetClients()
    local cc = {}
    for _, c in ipairs(client.get()) do
        -- awmlog(c)
        if awful.widget.tasklist.filter.currenttags(c, mouse.screen) then
            cc[#cc + 1] = c
        end
        -- awmlog("GetClients " .. i)
        -- awmlog(cc[#cc])
    end
    return cc
end


awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Mod1" }, "a", function()

        local cc = GetClients()

        awmlog(cc[3].name)
        cc[3].name = "3|".. cc[3].name
        awmlog(cc[3].name)

    end, { description = "swap 1", group = "debug" }),
    awful.key({ modkey, "Mod1" }, "s", function()
            awful.client.swap.byidx(-1)
    end, { description = "swap -1", group = "debug" }),

    awful.key({ modkey }, "1", function()
        clientstate.focus_client_by_number(1)
    end, { description = "focus 1", group = "focus" }),

    awful.key({ modkey }, "2", function()
        clientstate.focus_client_by_number(2)
    end, { description = "focus 2", group = "focus" }),

    awful.key({ modkey }, "3", function()
        clientstate.focus_client_by_number(3)
    end, { description = "focus 3", group = "focus" }),

    awful.key({ modkey }, "4", function()
        clientstate.focus_client_by_number(4)
    end, { description = "focus 4", group = "focus" }),

    awful.key({ modkey }, "5", function()
        clientstate.focus_client_by_number(5)
    end, { description = "focus 5", group = "focus" }),

    awful.key({ modkey }, "6", function()
        clientstate.focus_client_by_number(6)
    end, { description = "focus 6", group = "focus" }),

    awful.key({ modkey }, "7", function()
        clientstate.focus_client_by_number(7)
    end, { description = "focus 7", group = "focus" }),

    awful.key({ modkey }, "8", function()
        clientstate.focus_client_by_number(8)
    end, { description = "focus 8", group = "focus" }),

    awful.key({ modkey }, "9", function()
        clientstate.focus_client_by_number(9)
    end, { description = "focus 9", group = "focus" }),

    awful.key({ modkey }, "n", function()
        clientstate.MinimizeSorted()
    end,
    { description = "minimize function", group = "client" }),


    awful.key({ modkey, "Control" }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:activate({ raise = true, context = "key.unminimize" })
        end
    end, { description = "restore minimized", group = "client" }),



    awful.key({ modkey, "Shift" }, "n", function()

    cc = {}
    for _, c in ipairs(client.get()) do
        -- awmlog(c)
        if awful.widget.tasklist.filter.currenttags(c, mouse.screen) then
            cc[#cc + 1] = c
        end
        awmlog(cc[#cc])
    end
    awmlog("cc full")
    awmlog(cc)

    clients = cc


    for i, v in ipairs(clients) do
        awmlog(i .. " " .. v.window .. " x:" .. v.x .. " w:" .. v.width .. " " .. tostring(v.minimized) .. " " .. v.name)
    end

    -- table.sort(clients, function(c1, c2)
    --     return c1.x < c2.x
    -- end)

    -- awmlog(clients)

    -- for i, v in ipairs(clients) do
    --     awmlog(i .. " " .. v.x)
    -- end

    -- local focused = client.focus
    -- local clients = awful.screen.focused().selected_tag:clients()
    -- awmlog(awful.client.idx(focused))
    -- awmlog(clients)
    -- awmlog(focused.x)
    -- awmlog(focused.width)
    -- awmlog(awful.client.idx(focused).col)
    -- awful.client.swap.byidx(1, focused)
    end,
    { description = "debug manual function", group = "debug" }),




    -- awful.key({ modkey,"Control"  }, "t", function ()
    -- naughty.notify({ title="KEYSTROKE debug", text="dunce"})
    -- awmlog("debug key pressed")
    -- focusClient()
    -- end,
    -- {description = "current debug", group = "debug"}),

    -- -- from this example:
    -- -- client.get()[1]:move_to_tag(screen[1].tags[2])
    -- -- a screen has tags list. How can I get clients of this tags list?
    -- --
    -- --

    -- client.get()[8]:activate {
    --      switch_to_tag = true,
    --      raise         = true,
    --      context       = "somet_reason",
    -- }

    -- doesn't work
    awful.key({ modkey, "Control" }, "t", function()
        local c = client.focus
        awful.titlebar.toggle(c)
    end, { description = "toggle title bar", group = "client" }),
})
