# Implementation Plan: Microphone Border Sync Fix & Client-Only Management

## Executive Summary

This document provides a complete implementation plan to fix two critical issues in the Moshi-STT dictation system:

1. **Microphone Border Color Sync Issue**: Window border colors don't stay green when microphone is active during dictation after window focus changes
2. **Client-Only Connection Management**: Add ability to connect/disconnect client independently from full dictation toggle, tied to microphone state

## Problem Analysis

### Issue 1: Microphone Border Color Desync

**Current Behavior:**
- Dictation starts → Microphone turns on → Border becomes green
- User changes window focus → Border resets to purple (incorrect)
- Microphone is still actually on, but border doesn't reflect this
- Manual microphone toggle fixes the color until next window change

**Root Cause:**
Two separate systems manage microphone state:
1. **Signal System**: `microphone_toggle.sh` monitors PulseAudio events and emits `jack_source_on/off` signals
2. **Border System**: `/dev/widgets/microphone.lua` listens to signals but may have focus-change handlers that override signal-based coloring

**Technical Details:**
- Dictation widget calls `microphone.On()` → PulseAudio state changes
- `microphone_toggle.sh` detects change → emits `jack_source_on` signal  
- Both `/dev/widgets/microphone.lua` and `/widgets/dictation.lua` listen to these signals
- Window focus changes trigger border color reevaluation that ignores current signal state

### Issue 2: Client-Only Management Needed

**Current Limitation:**
- `dictation.Toggle()` starts/stops entire system (container + client)
- Microphone toggle is independent of dictation system
- No way to connect client to running server without full system toggle

**Desired Behavior:**
- Keep container running continuously when needed
- Connect/disconnect client separately tied to microphone state
- When microphone activates AND server is running → start client automatically
- When microphone deactivates → disconnect client (reduce server load)
- Maintain full decoupling - microphone should work without dictation

## System Architecture Overview

### Current File Structure
```
/home/freeo/dotfiles/config/awesome/
├── widgets/
│   ├── dictation.lua                 # Main dictation system
│   ├── microphone.lua                # Microphone controls + border management
│   └── microphone_toggle.sh          # PulseAudio monitor script
├── dev/widgets/
│   └── microphone.lua                # Alternative border management (check both)
└── scripts/
    └── dictate_container_client.py   # Container client script
```

### Signal Flow
```
PulseAudio State Change
    ↓
microphone_toggle.sh detects change
    ↓
Emits jack_source_on/off via awesome-client
    ↓
Multiple listeners:
    ├── /widgets/dictation.lua (updates dictation widget)
    ├── /widgets/microphone.lua (updates border colors)
    └── /dev/widgets/microphone.lua (alternative border system)
```

### Container States
- **created**: Container exists but not running
- **running**: Container active and ready for connections  
- **stopping**: Container shutting down
- **exited**: Container fully stopped
- **missing**: Container doesn't exist

## Implementation Plan

### Phase 1: Fix Microphone Border Color Sync

#### Step 1.1: Identify Border Management System
**Location**: `/dev/widgets/microphone.lua` or `/widgets/microphone.lua`

**Tasks:**
1. Find which file contains the actual border color management logic
2. Look for `client.connect_signal("jack_source_on/off")` handlers
3. Identify any `client.connect_signal("focus")` or similar focus change handlers

**Expected Code Pattern:**
```lua
client.connect_signal("jack_source_on", function()
    -- Set border to green
end)

client.connect_signal("focus", function(c)
    -- This might be overriding the microphone state
    -- Check if it respects current microphone state
end)
```

#### Step 1.2: Fix Focus Change Handler
**Problem**: Focus change handlers override signal-based colors

**Solution**: Modify focus change handlers to respect current microphone state

**Implementation:**
```lua
-- Add global microphone state tracking
local microphone_state = {
    is_on = false,
    last_updated = 0
}

-- Update state trackers in signal handlers
client.connect_signal("jack_source_on", function()
    microphone_state.is_on = true
    microphone_state.last_updated = os.time()
    -- Apply green border
end)

client.connect_signal("jack_source_off", function()
    microphone_state.is_on = false
    microphone_state.last_updated = os.time()
    -- Remove green border
end)

-- Fix focus change handler
client.connect_signal("focus", function(c)
    -- Respect current microphone state instead of overriding
    if microphone_state.is_on then
        -- Apply green border - microphone is active
    else
        -- Apply normal border - microphone is off
    end
end)
```

#### Step 1.3: Add State Persistence
**Ensure signal state persists across:**
- Window focus changes
- Widget reloads
- AwesomeWM configuration reloads

### Phase 2: Implement Client-Only Connection Management

#### Step 2.1: Add Container State Detection Function
**Location**: `/widgets/dictation.lua`

**Function**: `DictationController:get_container_state(callback)`
```lua
function DictationController:get_container_state(callback)
    awful.spawn.easy_async_with_shell(
        "podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^moshi-stt'",
        function(stdout, stderr, reason, exit_code)
            local state = "missing"
            if stdout and stdout:match("moshi%-stt") then
                local state_match = stdout:match("moshi%-stt%s+(%S+)")
                if state_match then
                    state = state_match:lower()
                end
            end
            callback(state)
        end
    )
end
```

#### Step 2.2: Add Client-Only Start/Stop Functions
**Add to `DictationController`:**

```lua
function DictationController:start_client_only()
    -- Only start client, don't manage container
    if self.client_process_pid then
        return -- Client already running
    end
    
    -- Check if container is running first
    self:get_container_state(function(state)
        if state == "running" then
            self:_start_container_client()
        else
            -- Container not running, can't start client
            if config.debug then
                print("DEBUG: Cannot start client - container not running")
            end
        end
    end)
end

function DictationController:stop_client_only()
    -- Only stop client, leave container running
    if not self.client_process_pid then
        return -- Client not running
    end
    
    -- Terminate client process
    local cmd = string.format("kill -TERM %d", self.client_process_pid)
    awful.spawn(cmd)
    
    -- Update state
    self.is_running = false
    self.client_process_pid = nil
end

function DictationController:is_client_running()
    return self.client_process_pid ~= nil and self.is_running
end
```

#### Step 2.3: Modify Signal Handlers for Auto-Client Connection
**Location**: Microphone signal handlers in `/widgets/dictation.lua`

**Current:**
```lua
client.connect_signal("jack_source_on", function()
    -- Only updates widget state
end)
```

**Enhanced:**
```lua
client.connect_signal("jack_source_on", function()
    microphone_state.is_on = true
    microphone_state.last_checked = os.time()
    
    -- Auto-connect client if server is running and not in full dictation mode
    if not controller.is_running and not controller.client_process_pid then
        controller:get_container_state(function(state)
            if state == "running" then
                controller:start_client_only()
            end
        end)
    end
    
    -- Update widget if dictation is running
    if controller.is_running then
        ui:update_status("ready", true)
    end
end)

client.connect_signal("jack_source_off", function()
    microphone_state.is_on = false
    microphone_state.last_checked = os.time()
    
    -- Auto-disconnect client to reduce server load
    if controller.client_process_pid and not controller.is_running then
        controller:stop_client_only()
    end
    
    -- Update widget if dictation is running  
    if controller.is_running then
        ui:update_status("ready", false)
    end
end)
```

#### Step 2.4: Add Public API Functions
**Add to module exports:**

```lua
function dictation.StartClientOnly()
    controller:start_client_only()
end

function dictation.StopClientOnly()
    controller:stop_client_only()
end

function dictation.IsClientRunning()
    return controller:is_client_running()
end

function dictation.GetContainerState(callback)
    controller:get_container_state(callback)
end
```

#### Step 2.5: Separate Process Tracking
**Modify `DictationController` to track:**
- `self.process_pid`: Full dictation mode process
- `self.client_process_pid`: Client-only mode process
- `self.is_running`: Full dictation active
- `self.client_only_mode`: Client-only active

### Phase 3: Integration & Configuration

#### Step 3.1: Add Configuration Options
```lua
local config = {
    -- Existing options...
    auto_client_on_mic = true,  -- Auto-start client when mic activates
    client_only_mode = false,   -- Enable client-only features
    debug_client_mgmt = false,  -- Debug client management
}
```

#### Step 3.2: Add Keybinding Support
**Example keybinding for client-only toggle:**
```lua
awful.keyboard.append_global_keybindings({
    awful.key({modkey, "Shift"}, "Prior", function()
        dictation.ToggleClientOnly()
    end, {description = "Toggle dictation client only", group = "dictation"}),
})
```

## Testing Plan

### Test Case 1: Border Color Sync
1. Start dictation → Verify green border
2. Change window focus → Verify border stays green  
3. Stop dictation → Verify border returns to normal
4. Manual microphone toggle → Verify colors work correctly
5. Change focus during manual microphone on → Verify green persists

### Test Case 2: Client-Only Management
1. Start container manually
2. Toggle microphone on → Verify client auto-connects
3. Toggle microphone off → Verify client disconnects  
4. Verify container stays running
5. Test without container running → Verify no errors
6. Test full dictation mode → Verify doesn't interfere with client-only

### Test Case 3: Decoupling Verification
1. Use microphone without any server → Should work normally
2. Start dictation (full mode) → Should work as before
3. Mix client-only and full modes → Should handle gracefully

## Risk Assessment

### Low Risk
- Border color fix (isolated change)
- Configuration additions
- API additions

### Medium Risk  
- Signal handler modifications (test thoroughly)
- Process tracking changes (ensure no PID conflicts)

### High Risk
- Focus change handler modifications (could affect other border behaviors)
- Auto-client connection logic (could cause unexpected connections)

## Rollback Plan

1. Keep backup copies of modified files
2. Add feature flags to disable new functionality
3. Ensure original `dictation.Toggle()` behavior is preserved
4. Test that microphone works independently if dictation is broken

## Implementation Order

1. **Fix border color sync first** (higher priority, isolated issue)
2. **Add container state detection** (foundation for client management)  
3. **Implement client-only functions** (core functionality)
4. **Add signal handler enhancements** (integration)
5. **Add configuration and API** (polish)
6. **Comprehensive testing** (validation)

## Files to Modify

### Primary Files
- `/home/freeo/dotfiles/config/awesome/widgets/dictation.lua`
- `/home/freeo/dotfiles/config/awesome/widgets/microphone.lua` (or `/dev/widgets/microphone.lua`)

### Verification Files
- Main AwesomeWM config file (for signal handler verification)
- Keybinding configuration files

### New Files
None required - all functionality fits in existing structure.

## Success Criteria

### Border Fix Success
- Green border persists through window changes when microphone active
- Manual microphone toggle works correctly  
- No regression in existing border functionality

### Client Management Success
- Can start/stop client independently of container
- Microphone activation auto-connects client when server running
- Microphone deactivation disconnects client
- Full dictation mode works unchanged
- No interference between modes

This plan provides a complete roadmap for implementing both fixes while maintaining system stability and preserving existing functionality.