local awful = require("awful")

local clientstate = {}

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

-- Minimize and move to the first of all minimized clients (all after last visible client)
function clientstate.MinimizeSorted()
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    local focused = client.focus
    -- awmlog("\n\nwindow id: " .. focused.window .. " name: " .. focused.name .." icon_name: " .. focused.icon_name )
    awmlog("\n\nwindow id: " .. focused.window .. " name: " .. focused.name )
    -- local focused_id = awful.client.idx(focused).num
    local focused_id = focused.window
    awmlog(awful.client.idx(focused))
    -- awmlog("focused index: " .. focused_index_col)
    local clients = awful.screen.focused().selected_tag:clients()
    if focused and clients then
        -- local clients = client.get()

        table.sort(clients, function(c1, c2)
            return c1.x < c2.x
        end)

        awmlog("Initial Sort")
        for i, v in ipairs(clients) do
            awmlog(i .. " " .. v.window .. " x:" .. v.x .. " w:" .. v.width .. " " .. tostring(v.minimized) .. " " .. v.name)
        end

        -- awmlog(clients)
        local t = awful.screen.focused().selected_tag
        awmlog("tag name: " .. t.name)
        awmlog("column_count: " .. t.column_count)
        awmlog("master_count: " .. t.master_count)

        -- local swappedOnce = false
        local skippedFocusedClient = false


        for i, c in ipairs(clients) do
            awmlog(i .. " " .. c.window .. " x:" .. c.x .. " w:" .. c.width .. " " .. c.name)

            if c.window == focused_id then
                skippedFocusedClient = true
                awmlog("this is the focused client")
                goto continue
            end

            if not skippedFocusedClient then
                awmlog("skip early item")
                goto continue
            end

            if i == #clients and not c.minimized then
                awmlog("last item")
                awful.client.swap.byidx(1, focused)
                break
            end

            if not c.minimized then
                awmlog("not minimized! swap")
                awful.client.swap.byidx(1, focused)
                -- swappedOnce = true
            elseif c.minimized then
                awmlog("found minimized! break")
                -- XXX DONE: test: for good measure! one last swap. Introduced this, because there seem to be edge cases
                -- nope, this garbles the order completely. Not a quick fix.
                -- awful.client.swap.byidx(1, focused)
                break
            end
            ::continue::
        end
    end
    focused.minimized = true
    focused.x = 5000
    focused.width = 1

    clients = awful.screen.focused().selected_tag:clients()

    table.sort(clients, function(c1, c2)
        return c1.x < c2.x
    end)

    awmlog("Final State")
    for i, v in ipairs(clients) do
        awmlog(i .. " " .. v.window .. " x:" .. v.x .. " w:" .. v.width .. " " .. tostring(v.minimized) .. " " .. v.name)
    end
    awmlog("---------------\n")

end


-- hidden clients management
-- https://stackoverflow.com/questions/39192955/how-to-focus-on-specific-client-window
function clientstate.focus_client_by_number(number)
    awmlog("---start focus--- number: ".. tostring(number) .. "---------\n")
    awmlog(awful.mouse.screen)

    local cc = {}
    for _, c in ipairs(client.get()) do
        if awful.widget.tasklist.filter.currenttags(c, mouse.screen) then
            cc[#cc + 1] = c
            awmlog(c)
            awmlog("  minimized: " .. tostring(c.minimized))
            if c.active then
                awmlog("  focused")
            end
        end
    end
    awmlog("cc")
    awmlog(cc)
    -- guard: less clients than key pressed
    if number > # cc then
        return
    end

    local new_focused = cc[number]

    if not new_focused.minimized then
        new_focused:activate()
        return
        -- assumes visible clients are sorted, ignores minimized clients, which must come after the visible ones

    elseif new_focused.minimized then

        -- activate() only works after deminimize!
        new_focused.minimized = false
        new_focused:activate()

        local clients = GetClients()

        -- all clients must be maximized, otherwise swap.byidx doesn't work
        local minState = {}
        -- local positions = {}
        for i, v in ipairs(clients) do
            minState[i] = v.minimized
            v.minimized = false
            awmlog(i ..": min: " .. tostring(v.minimized) .. " minState: " .. tostring(minState[i]) .. " " .. v.window .. " x:" .. v.x .. " w:" .. v.width .. " " .. " " .. v.name)
        end

        for i = number, 2, -1 do
            local min1= minState[i]
            local min0 = minState[i-1]
            awmlog("min1: ".. tostring(min1) .. " min0: ".. tostring(min0))
            if not minState[i-1] then
                awmlog("first visible client reached, don't swap anything")
                break
            end
            awmlog("i:" .. i)
            -- always refresh clients on every loop! otherwise second loop will already ignore the correct client
            clients = GetClients()
            local c1 = clients[i]
            local c0 = clients[i-1]
            -- awmlog("c0:" .. tostring(c0.minimized) .. " c:" .. tostring(c.minimized))
            awmlog("minState")
            awmlog(minState)
            if min0 and not min1 then
                awmlog("SWAPPING [".. string.sub(c1.name, 1,7) .. " and " .. string.sub(c0.name, 1, 7) .. "]" )
                awmlog("swapping...")
                awful.client.swap.byidx(-1, c1)
                -- swap the state
                minState[i] = min0
                minState[i-1] = min1
            end
            awmlog("client:")
            awmlog(clients[i])
        end

        -- apply final minState to a fresh list of clients
        clients = GetClients()
        for i, v in ipairs(clients) do
            v.minimized = minState[i]
            awmlog(i ..": min: " .. tostring(v.minimized) .. " " .. v.window .. " x:" .. v.x .. " w:" .. v.width .. " " .. " " .. string.sub(v.name,1,20))
        end
    end
end

return clientstate
