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
local sharedtags = require("awesome-sharedtags")

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
    theme = "nord",
    placement = "top_right",
    radius = 8,
    previous_month_button = 3,
    next_month_button = 1,
})
mytextclock:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        cw.toggle()
    end
end)

-- apt_widget unfortunately bugged currently
-- local apt_widget = require("awesome-wm-widgets.apt-widget.apt-widget")
local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")


local net_widgets = require("net_widgets")

net_wired = net_widgets.indicator({
    -- interfaces  = {"enp2s0", "another_interface", "and_another_one"},
    -- interfaces  = {"eno1", "wlp7s0"},
    interfaces  = {"bond0"},
    timeout     = 5
})

net_internet = net_widgets.internet({indent = 10, timeout = 5, showconnected = true})

local capi = { screen = screen,
               client = client }
local gcolor = require("gears.color")
local gstring = require("gears.string")

-- local function tasklist_label(c, args, tb)
local function my_label(c, tb, i)
    -- if not args then args = {} end
    local args = {}
    local theme = beautiful.get()
    local align = args.align or theme.tasklist_align or "left"
    local fg_normal = gcolor.ensure_pango_color(args.fg_normal or theme.tasklist_fg_normal or theme.fg_normal, "white")
    local bg_normal = args.bg_normal or theme.tasklist_bg_normal or theme.bg_normal or "#000000"
    local fg_focus = gcolor.ensure_pango_color(args.fg_focus or theme.tasklist_fg_focus or theme.fg_focus, fg_normal)
    local bg_focus = args.bg_focus or theme.tasklist_bg_focus or theme.bg_focus or bg_normal
    local fg_urgent = gcolor.ensure_pango_color(args.fg_urgent or theme.tasklist_fg_urgent or theme.fg_urgent,
                                                fg_normal)
    local bg_urgent = args.bg_urgent or theme.tasklist_bg_urgent or theme.bg_urgent or bg_normal
    local fg_minimize = gcolor.ensure_pango_color(args.fg_minimize or theme.tasklist_fg_minimize or theme.fg_minimize,
                                                  fg_normal)
    local bg_minimize = args.bg_minimize or theme.tasklist_bg_minimize or theme.bg_minimize or bg_normal
    -- FIXME v5, remove the fallback theme.bg_image_* variables, see GH#1403
    local bg_image_normal = args.bg_image_normal or theme.tasklist_bg_image_normal or theme.bg_image_normal
    local bg_image_focus = args.bg_image_focus or theme.tasklist_bg_image_focus or theme.bg_image_focus
    local bg_image_urgent = args.bg_image_urgent or theme.tasklist_bg_image_urgent or theme.bg_image_urgent
    local bg_image_minimize = args.bg_image_minimize or theme.tasklist_bg_image_minimize or theme.bg_image_minimize
    local tasklist_disable_icon = args.disable_icon or args.tasklist_disable_icon
        or theme.tasklist_disable_icon or false
    local disable_task_name = args.disable_task_name or theme.tasklist_disable_task_name or false
    local font = args.font or theme.tasklist_font or theme.font
    local font_focus = args.font_focus or theme.tasklist_font_focus or theme.font_focus or font
    local font_minimized = args.font_minimized or theme.tasklist_font_minimized or theme.font_minimized or font
    local font_urgent = args.font_urgent or theme.tasklist_font_urgent or theme.font_urgent or font
    -- local text = tostring(i) .. "|"
    local text = ""
    local name = ""
    local bg
    local bg_image
    local shape              = args.shape or theme.tasklist_shape
    local shape_border_width = args.shape_border_width or theme.tasklist_shape_border_width
    local shape_border_color = args.shape_border_color or theme.tasklist_shape_border_color
    local icon_size = args.icon_size or theme.tasklist_icon_size

    -- symbol to use to indicate certain client properties
    local sticky = args.sticky or theme.tasklist_sticky or "▪"
    local ontop = args.ontop or theme.tasklist_ontop or '⌃'
    local above = args.above or theme.tasklist_above or '▴'
    local below = args.below or theme.tasklist_below or '▾'
    local floating = args.floating or theme.tasklist_floating or '✈'
    local maximized = args.maximized or theme.tasklist_maximized or '<b>+</b>'
    local maximized_horizontal = args.maximized_horizontal or theme.tasklist_maximized_horizontal or '⬌'
    local maximized_vertical = args.maximized_vertical or theme.tasklist_maximized_vertical or '⬍'
    local minimized = args.minimized or theme.tasklist_minimized or '<b>_</b>'

    if tb then
        tb:set_halign(align)
    end

    if not theme.tasklist_plain_task_name then
        if c.sticky then name = name .. sticky end

        if c.ontop then name = name .. ontop
        elseif c.above then name = name .. above
        elseif c.below then name = name .. below end

        if c.maximized then
            name = name .. maximized
        else
            if c.maximized_horizontal then name = name .. maximized_horizontal end
            if c.maximized_vertical then name = name .. maximized_vertical end
            if c.floating then name = name .. floating end
        end
        if c.minimized then name = name .. minimized end
    end

    if not disable_task_name then
        if c.minimized then
            name = name .. (gstring.xml_escape(c.icon_name) or gstring.xml_escape(c.name) or
                            gstring.xml_escape("<untitled>"))
        else
            name = name .. (gstring.xml_escape(c.name) or gstring.xml_escape("<untitled>"))
        end
    end

    local focused = c.active
    -- Handle transient_for: the first parent that does not skip the taskbar
    -- is considered to be focused, if the real client has skip_taskbar.
    if not focused and capi.client.focus and capi.client.focus.skip_taskbar
        and capi.client.focus:get_transient_for_matching(function(cl)
                                                             return not cl.skip_taskbar
                                                         end) == c then
        focused = true
    end

    if focused then
        bg = bg_focus
        -- text = text .. "<span color='"..fg_focus.."'>"..name.."</span>"
        text = text .. "<span color='"..fg_focus.."'>".. tostring(i) .. "|"..name.."</span>"
        bg_image = bg_image_focus
        font = font_focus

        if args.shape_focus or theme.tasklist_shape_focus then
            shape = args.shape_focus or theme.tasklist_shape_focus
        end

        if args.shape_border_width_focus or theme.tasklist_shape_border_width_focus then
            shape_border_width = args.shape_border_width_focus or theme.tasklist_shape_border_width_focus
        end

        if args.shape_border_color_focus or theme.tasklist_shape_border_color_focus then
            shape_border_color = args.shape_border_color_focus or theme.tasklist_shape_border_color_focus
        end
    elseif c.urgent then
        bg = bg_urgent
        text = text .. "<span color='"..fg_urgent.."'>"..name.."</span>"
        bg_image = bg_image_urgent
        font = font_urgent

        if args.shape_urgent or theme.tasklist_shape_urgent then
            shape = args.shape_urgent or theme.tasklist_shape_urgent
        end

        if args.shape_border_width_urgent or theme.tasklist_shape_border_width_urgent then
            shape_border_width = args.shape_border_width_urgent or theme.tasklist_shape_border_width_urgent
        end

        if args.shape_border_color_urgent or theme.tasklist_shape_border_color_urgent then
            shape_border_color = args.shape_border_color_urgent or theme.tasklist_shape_border_color_urgent
        end
    elseif c.minimized then
        bg = bg_minimize
        -- text = text .. "<span color='"..fg_minimize.."'>"..name.."</span>"
        text = text .. "<span color='"..fg_minimize.."'>".. tostring(i) .. "|"..name.."</span>"
        bg_image = bg_image_minimize
        font = font_minimized

        if args.shape_minimized or theme.tasklist_shape_minimized then
            shape = args.shape_minimized or theme.tasklist_shape_minimized
        end

        if args.shape_border_width_minimized or theme.tasklist_shape_border_width_minimized then
            shape_border_width = args.shape_border_width_minimized or theme.tasklist_shape_border_width_minimized
        end

        if args.shape_border_color_minimized or theme.tasklist_shape_border_color_minimized then
            shape_border_color = args.shape_border_color_minimized or theme.tasklist_shape_border_color_minimized
        end
    else
        bg = bg_normal
        text = text .. "<span color='"..fg_normal.."'>"..name.."</span>"
        bg_image = bg_image_normal
    end

    if tb then
        tb:set_font(font)
    end

    local other_args = {
        shape              = shape,
        shape_border_width = shape_border_width,
        shape_border_color = shape_border_color,
        icon_size          = icon_size,
    }
    awmlog("final text:")
    awmlog(text)
    return text, bg, bg_image, not tasklist_disable_icon and c.icon or nil, other_args
end

local common = require("awful.widget.common")


--- Common update method.
-- @param w The widget.
-- @tparam table buttons
-- @func label Function to generate label parameters from an object.
--   The function gets passed an object from `objects`, and
--   has to return `text`, `bg`, `bg_image`, `icon`.
-- @tparam table data Current data/cache, indexed by objects.
-- @tparam table objects Objects to be displayed / updated.
-- @tparam[opt={}] table args
function my_list_update(w, buttons, label, data, objects, args)
    -- update the widgets, creating them if needed
    w:reset()
    awmlog("gogogo: ".. tostring(#objects))
    awmlog("data: ".. tostring(#data))
    for i, o in ipairs(objects) do
        local cache = data[o]

        -- Allow the buttons to be replaced.
        if cache and cache._buttons ~= buttons then
            cache = nil
        end

        if not cache then
            awmlog("not cache")
            cache = (args and args.widget_template) and
                common.default_template()
                -- common.custom_template(args) or common.default_template()

            awmlog("m1")
            awmlog(inspect(cache))

            awmlog(inspect(buttons))

            local info = debug.getinfo(common.common.create_buttons)
            for k, v in pairs(info) do
                awmlog(k .." " .. v)
            end

            cache.primary.buttons = {common.common.create_buttons(buttons, o)}
            awmlog("m2")
            if cache.create_callback then
                cache.create_callback(cache.primary, o, i, objects)
            end

            if args and args.create_callback then
                args.create_callback(cache.primary, o, i, objects)
            end


            cache._buttons = buttons
            data[o] = cache
            awmlog(data[o])
        elseif cache.update_callback then
            cache.update_callback(cache.primary, o, i, objects)
        end
        awmlog("pre label")
        -- local text, bg, bg_image, icon, item_args = label(o, cache.tb, i)
        local text, bg, bg_image, icon, item_args = label(o, nil , i)
        awmlog("object label: ".. tostring(i))
        awmlog(text)

        item_args = item_args or {}

        -- The text might be invalid, so use pcall.
        -- if cache.tbm and (text == nil or text == "") then
        --     cache.tbm:set_margins(0)
        -- elseif cache.tb then
        --     if not cache.tb:set_markup_silently(text) then
        --         cache.tb:set_markup("<i>&lt;Invalid text&gt;</i>")
        --     end
        -- end

        -- if cache.bgb then
        --     cache.bgb:set_bg(bg)

        --     --TODO v5 remove this if, it existed only for a removed and
        --     -- undocumented API
        --     if type(bg_image) ~= "function" then
        --         cache.bgb:set_bgimage(bg_image)
        --     else
        --         gdebug.deprecate("If you read this, you used an undocumented API"..
        --             " which has been replaced by the new awful.widget.common "..
        --             "templating system, please migrate now. This feature is "..
        --             "already staged for removal", {
        --             deprecated_in = 4
        --         })
        --     end

        --     cache.bgb.shape        = item_args.shape
        --     cache.bgb.border_width = item_args.shape_border_width
        --     cache.bgb.border_color = item_args.shape_border_color

        -- end

        -- if cache.ib and icon then
        --     cache.ib:set_image(icon)
        -- elseif cache.ibm then
        --     cache.ibm:set_margins(0)
        -- end

        -- if item_args.icon_size and cache.ib then
        --     cache.ib.forced_height = item_args.icon_size
        --     cache.ib.forced_width  = item_args.icon_size
        -- elseif cache.ib then
        --     cache.ib.forced_height = nil
        --     cache.ib.forced_width  = nil
        -- end

        -- w:add(cache.primary)
        awmlog("done?")
   end
end



local inspect = require("inspect")

-- Define a function to update the tasklist widget
function update_tasklist_widget(w, buttons, label, data, objects)
    local result = {}
    local new_labels = {}
    awmlog("update_tasklist_widget " .. tostring(#objects))
    -- awmlog("label:")
    -- local info = debug.getinfo(label)
    -- for k, v in pairs(info) do
    --     awmlog(k .." " .. v)
    -- end
    -- awmlog(inspect(objects[1], {depth = 2}))
    -- local obj = objects[1]
    -- awmlog(obj.name)
    -- awmlog(obj.class)
    -- awmlog(obj.type)
    -- for i, o in ipairs(objects) do
        -- awmlog(i)
        -- awmlog(o.name)
        -- local tmp = o.name
        -- o.name = tostring(i) .."|".. tmp
        -- o.name = tostring(i)
        -- o.icon_name = "Roger"
        -- awmlog(o.name)
        -- o.text = i .. "|" .. o.name

        -- local l = i .. "|".. label(o)
        -- awmlog(inspect(l))
        -- awmlog(inspect(o))
        -- local widget_text = "HURR DURR"
        -- if type(widget_text) == "string" then
        --     widget_text = string.format("DORK [%d] %s ", i, widget_text)
        -- end
        -- result[i] = wibox.widget.textbox("HURR DURR")
    --     result[i] = o
    -- end
    my_list_update(w, buttons, my_label, data, objects, {})
    -- my_list_update(w, buttons, my_label, data, result)
    -- awful.widget.common.list_update(w, buttons, tasklist_label, data, result)
    -- awful.widget.common.list_update(w, buttons, label, data, result)
    -- w:set_max_widget_size(100)
    -- return result
end

-- local common = require("common")
function update_tasklist_widget2(w, buttons, label, data, objects)
    w:set_max_widget_size(100)
    awful.widget.common.list_update(w, buttons, label, data, objects)
end

local gpuicon = require("widgets.gpuicon.gpuicon-amd-nvidia")
gpuicon.init()

-- local test_widget = require("widgets.test-widget.test-widget")

-- @DOC_FOR_EACH_SCREEN@
screen.connect_signal("request::desktop_decoration", function(s)
    -- s.dpi = 144

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox({
        screen = s,
        buttons = {
            awful.button({}, 1, function()
                awful.layout.inc(1)
            end),
            awful.button({}, 3, function()
                awful.layout.inc(-1)
            end),
            awful.button({}, 4, function()
                awful.layout.inc(-1)
            end),
            awful.button({}, 5, function()
                awful.layout.inc(1)
            end),
        },
    })

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({}, 1, function(t)
                t:view_only()
            end),
            awful.button({ modkey }, 1, function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end),
            awful.button({}, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end),
            awful.button({}, 4, function(t)
                awful.tag.viewprev(t.screen)
            end),
            awful.button({}, 5, function(t)
                awful.tag.viewnext(t.screen)
            end),
        },
    })

    -- @TASKLIST_BUTTON@
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        -- filter = function(c, screen)
            -- return not c.minimized
        -- end,
        buttons = {
            awful.button({}, 1, function(c)
                -- c:activate({ context = "tasklist", action = "toggle_minimization" })
                c.minimized = not c.minimized
            end),
            awful.button({}, 2, function(c)
                c:kill()
            end),
            awful.button({}, 3, function()
                awful.menu.client_list({ theme = { width = 250 } })
            end),
            awful.button({}, 4, function()
                awful.client.focus.byidx(-1)
            end),
            awful.button({}, 5, function()
                awful.client.focus.byidx(1)
            end),
        },
        style    = {
                border_width = 1,
                shape        = gears.shape.rounded_bar,
        },
        layout   = {
                spacing = 10,
                layout  = wibox.layout.flex.horizontal
        },
        -- XXX entry point to enable my WIP
        -- update_function = update_tasklist_widget,
        widget_template = {
            {
                {
                    {
                        {
                            id = "icon_role",
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget = wibox.container.margin,
                    },
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                    -- forced_width    = 148,
                    -- forced_height   = 24,
                },
                left = 15,
                right = 5,
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = wibox.container.background,
            forced_width = 200,
        },

    })

    -- function s.mytasklist.layout:fit(context, width, height)
    --     return math.min(150, width), height
    -- end

    -- @DOC_WIBAR@
    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        height = 32,
        screen = s,
        -- @DOC_SETUP_WIDGETS@
        widget = {
            layout = wibox.layout.align.horizontal,
            {
                -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox,
            },
            wibox.widget({
                -- Middle widget
                s.mytasklist,
                halign = "center",
                widget = wibox.container.place,
            }),
            {
                -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                wibox.widget.systray(),
                gpuicon.widget,
                fs_widget({ "/", "/home/freeo", "/mnt/nvme0n1p6", "/mnt/Drive D", "/mnt/Drive E" }),
                cpu_widget({
                    -- width = 70,
                    -- step_width = 2,
                    -- step_spacing = 0,
                    color = "#ffffff",
                }),
                ram_widget(),
                -- test_widget(), -- WIP
                -- apt_widget(), -- bugged
                -- mykeyboardlayout,
                net_wired,
                net_internet,
                mytextclock,
                -- widget_mic,
                s.mylayoutbox,
            },
        },
    })
end)
-- }}} beautiful.xresources.set_dpi (dpi[, s]) {{{ Mouse bindings
-- @DOC_ROOT_BUTTONS@
awful.mouse.append_global_mousebindings({
    awful.button({}, 3, function()
        mymainmenu:toggle()
    end),
    awful.button({}, 4, awful.tag.viewprev),
    awful.button({}, 5, awful.tag.viewnext),
})
-- }}}

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

local tagskeycodes = {
    38,
    39,
    40,
    41,
    42, -- asdfg
    52,
    53,
    54,
    55,
    56, -- zxcvb
}

local tagskeys = { "a", "s", "d", "f", "g", "z", "x", "c", "v", "b" }

local tags = sharedtags({
    { name = "fox",   layout = awful.layout.suit.tile },
    { name = "emx",   layout = awful.layout.suit.tile },
    { name = "eee",   layout = awful.layout.suit.tile },
    { name = "fff",   layout = awful.layout.suit.tile },
    -- { name = "ggg",   layout = awful.layout.layouts[1] },
    { name = "ggg",   layout = awful.layout.suit.tile },
    { name = "music", layout = awful.layout.suit.tile },
    { name = "xxx",   layout = awful.layout.suit.tile },
    { name = "ccc",   layout = awful.layout.suit.tile },
    { name = "vvv",   layout = awful.layout.suit.tile },
    { name = "bbb",   layout = awful.layout.suit.tile },
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
        awful.key({ modkey }, "#" .. tagskeycodes[i], function()
            local screen = awful.screen.focused()
            local tag = tags[i]
            -- local tag = screen.tags[i]
            if tag then
                sharedtags.viewonly(tag, screen)
                -- tag:view_only()
            end
        end, {}),
        -- {description = "view tag #".. tagskeys[i], group = "tag"}),
        -- Toggle tag display.
        awful.key(
            { modkey, "Control" },
            "#" .. tagskeycodes[i],
            function()
                local screen = awful.screen.focused()
                local tag = tags[i]
                -- local tag = screen.tags[i]
                if tag then
                    sharedtags.viewtoggle(tag, screen)
                    -- awful.tag.viewtoggle(tag)
                end
            end,
            -- {description = "toggle tag #" .. tagskeys[i], group = "tag"}),
            {}
        ),
        -- Move client to tag.
        awful.key(
            { modkey, "Shift" },
            "#" .. tagskeycodes[i],
            function()
                if client.focus then
                    local tag = tags[i]
                    -- local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                        --  XXX TODO move to last before minimized
                    end
                end
            end,
            -- {description = "move focused client to tag #".. tagskeys[i], group = "tag"}),
            {}
        ),
        -- Toggle tag on focused client.
        awful.key(
            { modkey, "Control", "Shift" },
            "#" .. tagskeycodes[i],
            function()
                if client.focus then
                    local tag = tags[i]
                    -- local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            -- {description = "toggle focused client on tag #" .. tagskeys[i], group = "tag"})
            {}
        ),
    })
end

local microphone = require("widgets.microphone")
local clientstate = require("functions.clientstate")
-- dofile(awful.util.getdir("config") .. "/" .. "./functions/clientstate.lua")


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
run_once("volumeicon")
-- run_once("mictray")
run_once("nm-applet")
run_once("setxkbmap -option ctrl:nocaps")
run_once("dunst") -- if I don't run this, naughty (from awesome) takes over notifications
-- run_once("redshift-gtk", "", "/usr/bin/python3 /usr/bin/redshift-gtk")
run_once("redshift-gtk", "", "python3 /usr/bin/redshift-gtk")
run_once("autokey-qt", "", "/usr/bin/python3 /usr/bin/autokey-qt")
run_once("emote", "", "python3 /snap/emote/19/bin/emote")
run_once("nitrogen", "--restore &")
run_once("xbindkeys", "&")
-- run_once("/usr/bin/diodon")
run_once("/usr/bin/copyq")
run_once("emacs --daemon")
-- run_once("qjackctl")
run_once("thunderbird")
 -- polkit provider needs to running in the background, apps don't invoke it directly, only the polkit interface (dbus?)
run_once("lxpolkit")
run_once("pcloud")
run_once("strawberry")
run_once("solaar", "", "/usr/bin/python /usr/bin/solaar")
run_once("protonmail-bridge")

run_once("emacs")
run_once("/usr/lib/firefox/firefox")
run_once("hueadm group 0 off")
run_once("signal-desktop")
run_once("dropbox")
-- run_once("hexchat")
-- run_once("discord")
run_once("networkd-notify")
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

inspect = require("inspect")


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


-- local active_tag = awful.screen.focused().selected_tag

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
