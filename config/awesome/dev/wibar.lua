local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

-- {{{ Wibar

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

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
        -- o.
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
    awful.widget.common.list_update(w, buttons, label, data, result)
    -- w:set_max_widget_size(100)
    -- return result
end

-- local common = require("common")
function update_tasklist_widget2(w, buttons, label, data, objects)
    w:set_max_widget_size(100)
    awful.widget.common.list_update(w, buttons, label, data, objects)
end

local rainbow_colors = {
    "#FF6F61",  -- Soft Coral
    "#6B5B93",  -- Soft Lavender
    "#88B04B",  -- Soft Olive Green
    "#F7CAC9",  -- Soft Pink
    "#92A8D1",  -- Soft Sky Blue
    "#955251",  -- Soft Burgundy
    "#B9C8A3",  -- Soft Sage Green
    "#F6C5A0",  -- Soft Peach
    "#E2B2D4",  -- Soft Lilac
    "#F2E6D5"   -- Soft Cream
}

-- XXX prompt: write a function, that sets the background color of each widget depending on its position in the tasklist. The first widget has bg color nr 1 from table rainbow_colors, the 2nd widget has bg color nr 2 from that same table and so on. Minimized clients should have the default minimized color.
--
-- Function to set background color based on position
-- local function update_tasklist_colors(self, c, index, objects)
local function update_tasklist_colors(s)
    --
    -- if not s.mytasklist then
    --     awmlog("s.mytasklist is nil")
    --     return
    -- end
    -- local layout = s.mytasklist.layout or s.mytasklist._private.layout
    -- if not layout then
    --     awmlog("Unable to find layout in s.mytasklist")
    --     return
    -- end
    -- awmlog("s.mytasklist:", s.mytasklist)

    -- local children = layout:get_children()
    -- local clients = s.clients

    -- for i, child in ipairs(children) do
    --     local c = clients[i]
    --     if c then
    --         local bg_widget = child:get_children_by_id('background_role')[1]
    --         if bg_widget then
    --             bg_widget.bg = c.minimized and beautiful.tasklist_bg_minimize
    --                                         or rainbow_colors[(i-1) % #rainbow_colors + 1]
    --         else
    --             print("No background_role widget found for client " .. i)
    --         end
    --     end
    -- end


    -- local clients = s.clients
    -- for i, c in ipairs(clients) do
    --     local tasklist_item = s.mytasklist:get_widgets_by_indices(i)[1]
    --     if tasklist_item then
    --         local bg_widget = tasklist_item:get_children_by_id('background_role')[1]
    --         if bg_widget then
    --             if c.minimized then
    --                 bg_widget.bg = beautiful.tasklist_bg_minimize
    --             else
    --                 local color_index = (i - 1) % #rainbow_colors + 1
    --                 bg_widget.bg = rainbow_colors[color_index]
    --             end
    --         end
    --     end
    -- end
end

        -- bg_widget.bg = "#FF00FF"

    -- -- Add hover effect
    -- self:connect_signal('mouse::enter', function()
    --     if not c.minimized then
    --         -- Store the original color
    --         self.original_bg = bg_widget.bg
    --         -- Set hover color (you can adjust this)
    --         bg_widget.bg = "#FFFFFF" -- White for hover
    --     end
    -- end)

    -- self:connect_signal('mouse::leave', function()
    --     if not c.minimized then
    --         -- Restore the original color
    --         bg_widget.bg = self.original_bg
    --     end
    -- end)


local function set_tasklist_colors(s)
    -- s = awful.screen.focused()
    awmlog("Tasklist all_children:")
    awmlog(s.mytasklist)
    awmlog(s.mytasklist.children)
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
        -- update_function = set_tasklist_colors,
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
                    forced_width    = 56,
                    forced_height   = 24,
                },
                left = 15,
                right = 5,
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = wibox.container.background,
            forced_width = 200,
        },
        -- create_callback = update_tasklist_colors,
        -- update_callback = set_tasklist_colors,
    })

    -- s.mytasklist:connect_signal("widget::updated", update_tasklist_colors(s))

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

-- s.mytasklist = awful.widget.tasklist

-- Connect to global signals
client.connect_signal("focus", function(c)
    update_tasklist_colors(c.screen)
end)
client.connect_signal("unfocus", function(c)
    update_tasklist_colors(c.screen)
end)
client.connect_signal("property::minimized", function(c)
    set_tasklist_colors(c.screen)
end)
