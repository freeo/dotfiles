local awful = require("awful")
local sharedtags = require("awesome-sharedtags")

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
