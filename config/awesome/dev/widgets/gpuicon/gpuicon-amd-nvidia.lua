local gpuicon = {}

local awful = require("awful")
local wibox = require("wibox")

local awmlog = require("functions.awmlog")

local function update_icon(widget)
    awful.spawn.easy_async_with_shell("/home/freeo/dotfiles/config/awesome/widgets/gpuicon/check_gpu.sh", function(stdout, stderr, reason, exit_code)
        -- awmlog("gpuicon: update_icon:")
        -- awmlog(stdout)
        -- awmlog(stderr)
        -- awmlog(reason)
        -- awmlog(exit_code)
        local icon_path = stdout:gsub("\n", "")
        -- awmlog(icon_path)
        widget:set_image(icon_path)
    end)

end

-- Create the widget
gpuicon.widget = wibox.widget {
    widget = wibox.widget.imagebox,
    resize = true
}

-- Update the icon on startup
update_icon(gpuicon.widget)

function gpuicon.init()
    -- awmlog("gpuicon: init")
    update_icon(gpuicon.widget)
end



return gpuicon
