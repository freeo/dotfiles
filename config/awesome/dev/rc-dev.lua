-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

DEBUG = true
-- local DEBUG = false

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
local awmlog = require("functions.awmlog")

awmlog("\n\nStarting AwesomeWM")
-- local awesome = require("awesome")

awesome.set_preferred_icon_size(64)

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification({
        urgency = "critical",
        title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message,
    })
end)
-- }}}

-- Enable hotkeys help widget for tmux, vim and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")

-- Custom modules
local kalisi = require("kalisi")
-- local lain = require("lain")
-- shared tags across monitors

-- {{{ Variable definitions
-- @DOC_LOAD_THEME@
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init("./themes/copland/theme.lua")
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
-- beautiful.init(gears.filesystem.get_themes_dir() .. "xresources/theme.lua")
-- beautiful.init(gears.filesystem.get_themes_dir() .. "kalisi/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "kalisi/theme.lua")
beautiful.column_count = 3
beautiful.xresources.set_dpi(144)

-- must be after beautiful.init()
local revelation = require("awesome-revelation")
revelation.init()
-- https://github.com/guotsuan/awesome-revelation

-- https://blingcorp.github.io/bling/#/README
local bling = require("bling")

bling.module.flash_focus.enable()

-- @DOC_DEFAULT_APPLICATIONS@
-- This is used later as the default terminal and editor to run.
terminal = "kitty"
-- terminal = "/home/freeo/dotfiles/scripts/kitty-color.sh"

editor = os.getenv("EDITOR") or "vi"
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
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
    },
    { "manual",      terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart",     awesome.restart },
    {
        "quit",
        function()
            awesome.quit()
        end,
    },
}
-- tmux.add_rules_for_terminal({
--   rule = { name = { "tmux" } }
-- })

mymainmenu =
    awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon }, { "open terminal", terminal } } })

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

local ck_image = gears.surface.load_uncached(os.getenv("HOME") .. "/.config/awesome/icons/ck-logo-dark.png")
mylauncher = awful.widget.launcher({ image = ck_image, menu = mymainmenu  })
-- /home/freeo/.config/awesome/icons/ck-logo-dark.png


-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- must be after beautiful theme is loaded
local machi = require("layout-machi")

require("beautiful").layout_machi = machi.get_icon()
machi.layout.default_cmd = "111h"

-- local layout_3col = machi.layout.create( {
--   name = "3-col",
--   default_cmd = "111h",
-- })

local editor = machi.editor.create()

-- {{{ Tag layout
-- @DOC_LAYOUT@
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        kalisi.layout.tile49wide,
        awful.layout.suit.tile,
        bling.layout.mstab, -- nice for toshiba
        -- bling.layout.centered,
        -- bling.layout.vertical,
        -- bling.layout.equalarea, -- would be nice with some tweaks
        -- bling.layout.deck,
        -- layout_3col,
        -- machi.default_layout,

        awful.layout.suit.floating,
        awful.layout.suit.max,
        --
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

-- https://www.reddit.com/r/awesomewm/comments/k3wkb2/how_can_i_stop_extra_startup_background_programs/
function run_once(prg, arg_string, pname, screen)
    if not prg then
        do
            return nil
        end
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



-- {{{ Wallpaper
-- @DOC_WALLPAPER@
screen.connect_signal("request::wallpaper", function(s)
    run_once("nitrogen", "--restore &")
    -- awful.wallpaper {
    --     screen = s,
    --     widget = {
    --         {
    --             image     = beautiful.wallpaper,
    --             upscale   = true,
    --             downscale = true,
    --             widget    = wibox.widget.imagebox,
    --         },
    --         valign = "center",
    --         halign = "center",
    --         tiled  = false,
    --         widget = wibox.container.tile,
    --     }
    -- }
end)
-- }}}


require("wibar")
require("keybindings")
require("tags")

local microphone = require("widgets.microphone")

-- FIND OUT: how many seconds, before the gears timer will actually be executed?
awful.spawn.easy_async_with_shell("(date; uptime --since; uptime -p; echo '----') >> /home/freeo/wb/awm/uptime.log", function(stdout, stderr, reason, exit_code)
    -- local uptime = stdout:gsub("\n$", "")
    -- naughty.notify({ text = "System uptime: " .. uptime })
end)

-- necessary for it to work on startup
gears.timer {
    timeout   = 5, -- determine time!
    single_shot = true,
    autostart = true,
    callback  = function()
        microphone.Off()
    end
}

local clientstate = require("functions.clientstate")
-- dofile(awful.util.getdir("config") .. "/" .. "./functions/clientstate.lua")



-- @DOC_CLIENT_BUTTONS@
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c)
            c:activate({ context = "mouse_click" })
        end),
        awful.button({ modkey }, 1, function(c)
            c:activate({ context = "mouse_click", action = "mouse_move" })
        end),
        awful.button({ modkey }, 3, function(c)
            c:activate({ context = "mouse_click", action = "mouse_resize" })
        end),
    })
end)

-- @DOC_CLIENT_KEYBINDINGS@
client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey }, "f", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, { description = "toggle fullscreen", group = "client" }),
        -- awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
        --     { description = "close", group = "client" }),
        awful.key({ modkey }, "w", function(c)
            c:kill()
        end, { description = "close", group = "client" }),
        awful.key(
            { modkey, "Control" },
            "space",
            awful.client.floating.toggle,
            { description = "toggle floating", group = "client" }
        ),
        awful.key({ modkey, "Control" }, "Return", function(c)
            c:swap(awful.client.getmaster())
        end, { description = "move to master", group = "client" }),
        awful.key({ modkey }, "o", function(c)
            c:move_to_screen()
        end, { description = "move to screen", group = "client" }),
        awful.key({ modkey }, "t", function(c)
            c.ontop = not c.ontop
        end, { description = "toggle keep on top", group = "client" }),
        -- awful.key({ modkey }, "n", function(c)
        --     -- The client currently has the input focus, so it cannot be
        --     -- minimized, since minimized clients can't have the focus.
        --     c.minimized = true
        --     -- local t = c.first_tag
        -- end, { description = "minimize", group = "client" }),
        awful.key({ modkey }, "r", function(c)
            -- c.minimized = true
            clientstate.MinimizeSorted()
        end, { description = "minimize", group = "client" }),

        awful.key({ modkey }, "m", function(c)
            c.maximized = not c.maximized
            c:raise()
        end, { description = "(un)maximize", group = "client" }),
        awful.key({ modkey, "Control" }, "m", function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end, { description = "(un)maximize vertically", group = "client" }),
        awful.key({ modkey, "Shift" }, "m", function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end, { description = "(un)maximize horizontally", group = "client" }),
    })
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
-- @DOC_RULES@
ruled.client.connect_signal("request::rules", function()
    -- @DOC_GLOBAL_RULE@
    -- All clients will match this rule.
    ruled.client.append_rule({
        id = "global",
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    })

    -- @DOC_FLOATING_RULE@
    -- Floating clients.
    ruled.client.append_rule({
        id = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "Sxiv",
                "Tor Browser",
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
                "QjackCtl",
                "Autokey",
                "autokey-qt",
                "Emote",
                "colorpicker",
                "Gnome-calculator",
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
                "Krita - Edit Text",
            },
            role = {
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            },
        },
        -- properties = { floating = true },
        properties = {
            floating = true,
            width = 500,
            height = 500
        },
    })


    ruled.client.append_rule({
        id = "floating",
        rule_any = {
            role = {
                "AlarmWindow", -- Thunderbird's calendar meeting notifications.
            },
        },
        properties = {
            floating = true,
            sticky = true,
            ontop = true,
            urgent = true,
            titlebars_enabled = false,
            placement = awful.placement.centered,
            width = 500,
            height = 350,
        },
    })

    ruled.client.append_rule({
        rule_any = { class = {"copyq"} },
        properties = {
            floating = true,
            placement = function(c)
                awful.placement.top(c, { honor_padding = true, honor_workarea = true })
                local margin_top = 150
                c:geometry({
                    y = c:geometry().y + margin_top
                })
            end,
            width = 1000,
            height = 700,
        },
    })

    ruled.client.append_rule({
        rule = { class = "Xephyr" },
            properties = {
            floating = false,
            -- tag = awful.tag.selected(1),
            -- focus = true,
            -- placement = awful.placement.centered
            }
    })

    -- @DOC_DIALOG_RULE@
    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule({
        -- @DOC_CSD_TITLEBARS@
        id = "titlebars",
        -- rule_any   = { type = { "normal", "dialog" } },
        rule_any = { type = { "dialog" } },
        properties = { titlebars_enabled = true },
    })

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule {
    --     rule       = { class = "Firefox"     },
    --     properties = { screen = 1, tag = "2" }

    ruled.client.append_rule({
        rule = { class = "thunderbird" },
        properties = { tag = "ggg" },
    })

    ruled.client.append_rule({
        rule = { class = "Signal" },
        properties = { tag = "ggg" },
    })

    ruled.client.append_rule({
        rule = { class = "QjackCtl" },
        properties = { tag = "bbb" },
    })

    ruled.client.append_rule({
        rule = { class = "pcloud" },
        properties = { tag = "bbb" },
    })

    ruled.client.append_rule({
        rule = { class = "autokey-qt" },
        properties = { tag = "bbb" },
    })

    ruled.client.append_rule({
        rule = { class = "Solaar" },
        properties = { tag = "bbb" },
    })

    ruled.client.append_rule({
        rule = { class = "Proton Mail Bridge" },
        properties = { tag = "bbb" },
    })

    ruled.client.append_rule({
        rule = { class = "strawberry" },
        properties = { tag = "music" },
    })

    -- Doesn't work, because the name is slightly different directly after startup, read here inn the examples
    -- https://awesomewm.org/doc/api/sample%20files/rc.lua.html#
    ruled.client.append_rule({
        -- rule       = { class = "pcmanfm", name ="pCloudDrive", instance ="pCloudDrive" },
        rule = { name = "pCloudDrive", instance = "pCloudDrive" },
        properties = { tag = "bbb" },
    })

    ruled.client.append_rule({
        rule_any = { class = { "Dragon-drop", "dragon-drop" } },
        properties = {
            floating = true,
            placement = awful.placement.centered,
        },
    })
end)

-- }}}

-- {{{ Titlebars
-- @DOC_TITLEBARS@
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({}, 1, function()
            c:activate({ context = "titlebar", action = "mouse_move" })
        end),
        awful.button({}, 3, function()
            c:activate({ context = "titlebar", action = "mouse_resize" })
        end),
    }

    awful.titlebar(c).widget = {
        {
            -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
        },
        {
            -- Middle
            {
                -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c),
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal,
        },
        {
            -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal,
    }
end)

-- {{{ Notifications

ruled.notification.connect_signal("request::rules", function()
    -- All notifications will match this rule.
    ruled.notification.append_rule({
        rule = {},
        properties = {
            screen = awful.screen.preferred,
            implicit_timeout = 5,
        },
    })
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box({ notification = n })
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
client.connect_signal("manage", function(c)
    c.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 10)
    end
end)

-- Border around Active window
-- https://www.reddit.com/r/awesomewm/comments/k7znc4/how_do_i_add_borders_to_active_window_and_make/
-- dotted border:
-- https://www.reddit.com/r/awesomewm/comments/cwv1wo/dotted_border_around_active_window/

beautiful.border_width = "10"
beautiful.useless_gap = "0"
beautiful.border_focus = "#7e5edc"
beautiful.border_normal = "#303030"

screen.connect_signal("arrange", function(s)
    -- local max = s.selected_tag.layout.name == "max"
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        -- if (max or only_one) and not c.floating or c.maximized then
        if only_one and not c.floating or c.maximized then
            -- workaround until top bar color shows micstate
            -- c.border_width = 0
            c.border_width = 8
        else
            c.border_width = beautiful.border_width
        end
    end
end)

client.connect_signal("focus", function(c)
    -- c.opacity = 1
    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    -- transparency
    -- c.opacity = 0.95
end)

-- pgrep -f -x "/usr/bin/python3 /usr/bin/redshift-gtk"
-- if [[ $(pactl get-source-mute 7) = "Mute: no" ]]; then echo "muted"; fi

-------------------------
-- Autostart -- Startup
-------------------------
-- AwesomeWM ignores ~/.config/autostart/*.desktop files!

-- run_once("picom")
-- run_once("picom --backend glx")
-- run_once("compton --backend glx")
-- run_once("volumeicon") -- redundant?
-- run_once("mictray")
-- run_once("nm-applet") -- redundant?
run_once("setxkbmap -option ctrl:nocaps")
-- run_once("dunst") -- if I don't run this, naughty (from awesome) takes over notifications
-- run_once("redshift-gtk", "", "/usr/bin/python3 /usr/bin/redshift-gtk")
-- run_once("redshift-gtk", "", "python3 /usr/bin/redshift-gtk")
run_once("autokey-qt", "", "/usr/bin/python3 /usr/bin/autokey-qt")
-- run_once("emote", "", "python3 /snap/emote/19/bin/emote")
-- run_once("nitrogen", "--restore &")
-- wallpaper
run_once("nitrogen", "--set-scaled /home/freeo/Pictures/Wallpapers/xephyr-bg-flux.png")
-- run_once("xbindkeys", "&")
-- run_once("/usr/bin/diodon")
-- run_once("/usr/bin/copyq")
-- run_once("emacs --daemon")
-- run_once("qjackctl")
-- run_once("thunderbird")
 -- polkit provider needs to running in the background, apps don't invoke it directly, only the polkit interface (dbus?)
-- run_once("lxpolkit")
-- run_once("pcloud")
-- run_once("strawberry")
-- run_once("solaar", "", "/usr/bin/python /usr/bin/solaar")
-- run_once("protonmail-bridge")

-- run_once("emacs")
-- run_once("/usr/lib/firefox/firefox")
-- run_once("hueadm group 0 off")
-- run_once("signal-desktop")
-- run_once("dropbox")
-- run_once("hexchat")
-- run_once("discord")
-- run_once("networkd-notify")
-- run_once("systemctl --user start xidlehook.service")



-- run_once("~/.config/emacs/bin/doom run","", "emacs")

-- Virtual Screens for Neo G9 screen sharing in MS Teams: 2x 2560x1440 instead of 5120x1440
-- XXX turn off temporarily to debug systray icons
-- awful.spawn.with_shell("xrandr --setmonitor LeftVScreen 2560/0x1440/1+0+0 none")
-- awful.spawn.with_shell("xrandr --delmonitor LeftVScreen")
-- Don't use the 2nd one!
-- awful.spawn.with_shell("xrandr --setmonitor RightVScreen 2560/0x1440/1+2560+0 none")

-- XXX
awful.spawn.with_shell("xset r rate 230 40")
-- awful.spawn.with_shell("xset_rate_freeo")

awful.spawn.with_shell("eval `ssh-agent -s`")
awful.spawn.with_shell("ssh-add")

-- Naughty Config: Notifications

naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "top_middle"
naughty.config.defaults.margin = 10
--naughty.config.default_preset.height           = 50
--naughty.config.default_preset.width            = 100
naughty.config.defaults.gap = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = 16
naughty.config.defaults.fg = "#ffffff"
naughty.config.defaults.bg = beautiful.bg_normal
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil
naughty.config.presets.normal.border_color = beautiful.fg_focus

-------------------------
-- Second Level Config --
-------------------------


-- Development Level Config

-- Volume Progress Bar
require("widgets.volume-change")

-- awful.key({ modkey,"Control"  }, "t", function () awful.spawn.with_shell( "echo 'durr: " .. gears.filesystem.get_themes_dir() .. "' >> ~/workbench/awesome.log") end,

function table_to_string(tbl, indent)
    if not indent then
        indent = 0
    end
    local str = ""
    for k, v in pairs(tbl) do
        str = str .. string.rep("  ", indent) -- add indentation
        if type(k) == "string" then
            str = str .. "[" .. string.format("%q", k) .. "] = "
        elseif type(k) == "function" then
            str = str .. "function"
        else
            str = str .. "[" .. k .. "] = "
        end
        if type(v) == "table" then
            str = str .. "{\n" .. table_to_string(v, indent + 1) .. string.rep("  ", indent) .. "},\n"
        else
            str = str .. tostring(v) .. ",\n"
        end
    end
    return str
end

-- orphaned?
function get_client_positions()
    local clients = awful.screen.focused().clients
    local positions = {}
    local count = 0
    for _, c in ipairs(clients) do
        if not c.skip_taskbar then
            count = count + 1
            local geometry = c:geometry()
            local position = geometry.x + (geometry.width / 2)
            positions[count] = position
        end
    end
    return positions
end


-- function focusClient()
    -- mapped to debug key M-C-t
-- end



-- local active_tag = awful.screen.focused().selected_tag

-- called from xidlehook scripts via awmclient
function restore_last_tag()
    local file = io.open("/tmp/awesomewm-last-selected-tags", "r")
    if not file then
        return
    end

    local selected_tags = {}

    for line in file:lines() do
        print(line)
        table.insert(selected_tags, tonumber(line))
    end

    awmlog("xidle restore:")
    for s in screen do

   -- string "Error during execution: /home/freeo/.config/awesome/rc.lua:1982: attempt to concatenate a nil value (local 'i')"
        local i = selected_tags[s.index]
        -- awmlog("i: " .. i)
        local t = s.tags[i]
        -- awmlog("t: " .. string(t))
        t:view_only()
    end

    file:close()
end

-- called from xidlehook scripts via awmclient
function write_last_tag()
    local file = io.open("/tmp/awesomewm-last-selected-tags", "w+")

    awmlog("xidle: write_last_tag: screen:")
    -- local screen = awful.screen
    for s in screen do
        awmlog(s.index)
        if s.selected_tag then
            file:write(s.selected_tag.index, "\n")
        end
    end

    file:close()
end


awesome.connect_signal("exit", function(reason_restart)
    if not reason_restart then
        return
    end

    local file = io.open("/tmp/awesomewm-last-selected-tags", "w+")

    for s in screen do
        file:write(s.selected_tag.index, "\n")
    end

    file:close()
end)

awesome.connect_signal("startup", function()
    local file = io.open("/tmp/awesomewm-last-selected-tags", "r")
    if not file then
        return
    end

    local selected_tags = {}
    local file_is_empty = true

    for line in file:lines() do
        file_is_empty = false
        table.insert(selected_tags, tonumber(line))
    end

    file:close()

   -- If the file is empty, do nothing
    if file_is_empty then
        return
    end

    for s in screen do
        local i = selected_tags[s.index]
        -- XXX: test this doesn't result in issues.
        if i and s.tags[i] then
            local t = s.tags[i]
            t:view_only()
        end
        -- local t = s.tags[i]
        -- t:view_only()
    end

end)

-- XXX Check if required programs are installed on startup
-- amixer (for volume media key display)

-- Load the necessary libraries

-- XXX Weird: before trying this, i got an error. But somehow right on titlebar now does what I want. Is this persistent? I deactivated this code now, error is gone, but the wanted feature still works! Idiot magic?
-- -- Define a function to handle mouse resizing
-- local function resize_window(c, x, y, width, height)
--     -- Update the window's geometry based on the new dimensions
--     c:geometry({ x = x, y = y, width = width, height = height })
-- end

-- -- Bind the mouse button press event to initiate resizing
-- client.connect_signal("button::press", function(c, _, _, button)
--     if button == 1 then -- Left mouse button
--         local grabber = function(mouse)
--             -- Calculate the new dimensions based on the mouse position
--             local width = mouse.x - c.x
--             local height = mouse.y - c.y

--             -- Resize the window
--             resize_window(c, c.x, c.y, width, height)
--         end

--         -- Start grabbing the mouse
--         awful.mouse.resize(c, grabber, "bottom_right")
--     end
-- end)

local Meetingselector = require("widgets.meetingselector")

    awful.keyboard.append_global_keybindings({
        awful.key({ modkey, "Mod1" }, "a", function()
            awmlog("start selector")
            Meetingselector.create_popup()
        end, { description = "swap 1", group = "debug" }),

    })

print("xxx-print-test")

local awful = { placement = require("awful.placement"), --DOC_HIDE
    popup = require("awful.popup") } --DOC_HIDE --DOC_NO_USAGE
local gears = { shape = require("gears.shape") } --DOC_HIDE
local wibox = require("wibox") --DOC_HIDE

-- drawing simple popups
-- awful.popup {
--     widget = {
--         {
--             {
--                 text   = "foobar",
--                 widget = wibox.widget.textbox
--             },
--             {
--                 {
--                     text   = "foobar",
--                     widget = wibox.widget.textbox
--                 },
--                 bg     = "#ff00ff",
--                 clip   = true,
--                 shape  = gears.shape.rounded_bar,
--                 widget = wibox.widget.background
--             },
--             {
--                 value         = 0.5,
--                 forced_height = 30,
--                 forced_width  = 100,
--                 widget        = wibox.widget.progressbar
--             },
--             layout = wibox.layout.fixed.vertical,
--         },
--         margins = 10,
--         widget  = wibox.container.margin
--     },
--     border_color = "#00ff00",
--     border_width = 5,
--     placement    = awful.placement.top_left,
--     shape        = gears.shape.rounded_rect,
--     visible      = true,
-- }
