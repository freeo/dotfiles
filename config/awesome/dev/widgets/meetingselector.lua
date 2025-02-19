local selector = {}

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")



-- Define the items to be displayed in the popup
selector.items = {
    { icon = "/home/freeo/dotfiles/scripts/icons/angrybirds.png", title = "Light", script = "/home/freeo/dotfiles/scripts/mode-light.sh" },
    { icon = "/home/freeo/dotfiles/scripts/icons/terminal.png", title = "Dark", script = "/home/freeo/dotfiles/scripts/mode-dark.sh" },
    -- { icon = "path/to/icon3.png", title = "Item 3", script = "bash /path/to/script3.sh" },
    -- Add more items as needed
}

-- Function to execute selected script
local function execute_script(script)
    awful.spawn.easy_async_with_shell(script, function(stdout, stderr, reason, exit_code)
        -- Handle the output or errors if needed
    end)
end

-- Function to create the popup
function selector.create_popup()
    local popup = awful.popup {
        widget = {
            {
                text = "Select an item:",
                widget = wibox.widget.textbox
            },
            layout = wibox.layout.fixed.vertical,
        },
        ontop = true,
        visible = true,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 8)
        end
    }

    -- Add items to the popup
    for i, item in ipairs(selector.items) do
        local item_widget = wibox.widget {
            {
                {
                    image = item.icon,
                    resize = true,
                    forced_width = 30,
                    widget = wibox.widget.imagebox
                },
                {
                    text = item.title,
                    widget = wibox.widget.textbox
                },
                layout = wibox.layout.fixed.horizontal
            },
            margins = 4,
            widget = wibox.container.margin
        }

        -- Allow selection by mouse click
        item_widget:connect_signal("button::press", function()
            execute_script(item.script)
            popup.visible = false
        end)

        -- Allow selection by keyboard
        awful.keygrabber.run(function(_, key, event)
            if event == "release" then return end
            local index = tonumber(key)
            if index and selector.items[index] then
                execute_script(selector.items[index].script)
                popup.visible = false
                return true
            elseif key == "Escape" then
                popup.visible = false
                return true
            end
        end)

        -- Add the item widget to the popup
        popup.widget:add(item_widget)
    end

    -- Set popup size
    local width = 200 -- Adjust according to your needs
    local height = #selector.items * 40 -- Assuming each item has a height of 40px
    popup:geometry({width = width, height = height})
end

return selector
