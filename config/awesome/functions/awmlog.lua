local naughty = require("naughty")

function awmlog(obj)
    -- DEBUG: global variable defined in rc.lua
    if not DEBUG then
        return
    else
        -- Open the file in append mode
        local filename = "/home/freeo/wb/awm/debug.log"
        local file = io.open(filename, "a")

        -- Check if the file was opened successfully
        if file == nil then
            print("Error: Could not open file " .. filename .. " for appending")
            naughty.notify({ title="AWMLOG file error:", text=filename, position="top_middle"})
            return
        end

        local timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time())

        if type(obj) == "table" then
            out = table_to_string(obj, 2)
            file:write(tostring(timestamp) .. ": " .. out .. "\n")
        else
            file:write(tostring(timestamp) .. ": " .. tostring(obj) .. "\n")
        end

        -- DEBUG-META: quick check if awmlog is working
        -- naughty.notify({ title="AWMLOG", text=obj, position="top_middle"})

        file:close()
    end
end

return awmlog

