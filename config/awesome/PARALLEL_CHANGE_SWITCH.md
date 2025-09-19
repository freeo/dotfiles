# 🔄 Parallel Change Implementation - THE SWITCH

## The Single Line That Controls Everything

In `/home/freeo/dotfiles/config/awesome/widgets/dictation.lua` line 40:

```lua
local USE_ENGINE_MANAGER = false  -- ← THE SWITCH
```

## How to Switch Between Implementations

### Use OLD Implementation (Current Default)

```lua
local USE_ENGINE_MANAGER = false  -- Line 40 in dictation.lua
```

- Uses hardcoded "moshi-stt" values
- Exactly what you've been using
- Zero risk, proven to work

### Use NEW Implementation (Engine Manager)

```lua
local USE_ENGINE_MANAGER = true   -- Line 40 in dictation.lua
```

- Uses engine manager for all commands
- Dynamically generates same values
- Ready for multi-engine support

## Quick Switch Commands

### Switch to OLD Implementation

```bash
# Edit line 40 to false
sed -i '40s/true/false/' widgets/dictation.lua

# Reload AwesomeWM
awesome-client 'awesome.restart()'

# Or just reload the module
awesome-client 'package.loaded["widgets.dictation"] = nil; require("widgets.dictation")'
```

### Switch to NEW Implementation

```bash
# Edit line 40 to true
sed -i '40s/false/true/' widgets/dictation.lua

# Reload AwesomeWM
awesome-client 'awesome.restart()'

# Or just reload the module
awesome-client 'package.loaded["widgets.dictation"] = nil; require("widgets.dictation")'
```

## Testing the Switch

### 1. Check Current Implementation

```bash
# See which implementation is active
grep "^local USE_ENGINE_MANAGER" widgets/dictation.lua

# Check the logs
awesome-client 'require("widgets.dictation").Toggle()'
# Look for "[DICTATION] Using OLD hardcoded implementation"
# or "[DICTATION] Using NEW engine manager implementation"
```

### 2. Test OLD Implementation

```bash
# Set to false
sed -i '40s/true/false/' widgets/dictation.lua
awesome-client 'package.loaded["widgets.dictation"] = nil; require("widgets.dictation")'

# Test dictation
awesome-client 'require("widgets.dictation").Toggle()'
```

### 3. Test NEW Implementation

```bash
# Set to true
sed -i '40s/false/true/' widgets/dictation.lua
awesome-client 'package.loaded["widgets.dictation"] = nil; require("widgets.dictation")'

# Test dictation
awesome-client 'require("widgets.dictation").Toggle()'
```

### 4. Verify Both Work Identically

```bash
# Run parallel test
lua5.4 test_parallel_change.lua

# Should see:
# ✅ SUCCESS: Both implementations produce identical results!
```

## What Changes When You Switch

### With `USE_ENGINE_MANAGER = false` (OLD)

- Container check: Hardcoded `grep '^moshi-stt'`
- Container name: Hardcoded `"moshi-stt"`
- Start command: Hardcoded `"podman start moshi-stt"`
- Stop command: Hardcoded `"podman stop --time 0 moshi-stt"`
- Client script: Hardcoded path

### With `USE_ENGINE_MANAGER = true` (NEW)

- Container check: `engine_manager:get_container_check_cmd()`
- Container name: `engine_manager:get_container_name()`
- Start command: `engine_manager:get_container_start_cmd()`
- Stop command: `engine_manager:get_container_stop_cmd()`
- Client script: `engine_manager:get_client_cmd()`

**Result: Exactly the same commands, different source!**

## Debug Output

When you switch, you'll see in the logs:

```
[DICTATION] Using OLD hardcoded implementation
[HARDCODED] Using hardcoded check command
[HARDCODED] Client pattern: dictate_container_client.py
```

OR

```
[DICTATION] Using NEW engine manager implementation
[ENGINE MANAGER] Using generated check command
[ENGINE MANAGER] Client pattern: dictate_container_client.py
```

## Safety Features

1. **Automatic Fallback**: If engine manager fails to load, automatically falls back to old implementation
2. **Identical Output**: Both produce exactly the same commands
3. **Easy Rollback**: Just change one line back
4. **No Data Loss**: Both use same container and state

## The Implementation Pattern (Parallel Change)

Following Martin Fowler's Parallel Change pattern:

1. ✅ **Expand**: Added new implementation alongside old
2. ✅ **Route**: Single switch controls which path is used
3. ✅ **Test**: Both implementations tested and working
4. ⏳ **Contract**: Can remove old implementation after validation
5. ⏳ **Cleanup**: Future phase after proven stability

## Current Status

- **Default**: `USE_ENGINE_MANAGER = false` (using old implementation)
- **Both work**: Tested and verified identical behavior
- **Ready**: Can switch anytime with one line change

## Quick Test After Switching

```bash
# After changing the switch, test:
awesome-client 'require("widgets.dictation").Toggle()'

# Check container
podman ps -a | grep stt

# View logs (if debug enabled)
tail -f /home/freeo/wb/awm_dict.log
```

## Emergency Rollback

If anything goes wrong:

```bash
# Restore original
cp widgets/dictation.lua.backup-phase2 widgets/dictation.lua
awesome-client 'awesome.restart()'
```

## Summary

**THE SWITCH**: Line 40 in `dictation.lua`

- `false` = Old hardcoded implementation (current)
- `true` = New engine manager implementation (ready)

Both produce identical results. Safe to switch anytime.

