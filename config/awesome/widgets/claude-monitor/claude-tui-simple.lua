local awful = require("awful")

local claude_tui_widget = {}

-- Track the current popup client
local current_client = nil
local waiting_for_client = false

-- Function to show claude-monitor TUI (spawn if needed, show if hidden)
function claude_tui_widget.show()
    -- If client exists but hidden, just show it
    if current_client and current_client.valid then
        if current_client.hidden then
            current_client.hidden = false
            current_client:emit_signal("request::activate", "key.unminimize", {raise = true})
            print("Claude TUI shown")
        else
            current_client:emit_signal("request::activate", "key.unminimize", {raise = true})
            print("Claude TUI focused")
        end
        return
    end

    -- Client doesn't exist, spawn new one
    waiting_for_client = true
    awful.spawn("kitty --class=claude-monitor-tui --title='Claude Monitor' -e claude-monitor")
    print("Claude TUI spawned")
end

-- Function to hide the claude-monitor TUI (don't kill, just hide)
function claude_tui_widget.hide()
    if current_client and current_client.valid then
        current_client.hidden = true
        print("Claude TUI hidden")
    end
end

-- Function to kill/close the claude-monitor TUI completely
function claude_tui_widget.kill()
    if current_client and current_client.valid then
        current_client:kill()
        current_client = nil
    end
    waiting_for_client = false
    print("Claude TUI killed")
end

-- Function to toggle the claude-monitor TUI popup
function claude_tui_widget.toggle()
    if current_client and current_client.valid then
        if current_client.hidden then
            claude_tui_widget.show()  -- Show if hidden
        else
            claude_tui_widget.hide()  -- Hide if visible
        end
    else
        claude_tui_widget.show()  -- Spawn if doesn't exist
    end
end

-- Signal handler for new clients - minimal processing
local function handle_new_client(c)
    if not waiting_for_client then return end
    if c.class ~= "claude-monitor-tui" then return end
    
    waiting_for_client = false
    current_client = c
    
    -- Just make it floating and position in upper right - no fancy calculations
    c.floating = true
    c.ontop = true
    
    -- Simple upper right positioning
    local screen = awful.screen.focused()
    local workarea = screen.workarea
    
    c:geometry({
        x = workarea.x + workarea.width - 1200 - 20, -- Fixed 1200px width, 20px margin
        y = workarea.y + 20,                         -- 20px from top
        width = 1200,                                -- Fixed width
        height = 680                                 -- Fixed height
    })
    
    -- Focus it
    c:emit_signal("request::activate", "mouse_enter", {raise = true})
    
    -- Clean up when closed
    c:connect_signal("unmanage", function()
        if current_client == c then
            current_client = nil
        end
    end)
    
    print("Claude TUI positioned: 1200x680 in upper right")
end

-- Initialize - connect to client signals
function claude_tui_widget.init()
    client.connect_signal("manage", handle_new_client)
    print("Claude TUI simple version initialized")
end

return claude_tui_widget