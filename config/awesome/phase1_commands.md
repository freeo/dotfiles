# Phase 1 - Switching Commands

## Quick Status Check

```bash
# Verify Phase 1 installation
lua5.4 test_phase1.lua

# Expected output: "COMPATIBILITY: 6/6 checks passed"
# ✅ SUCCESS: New implementation is 100% compatible!
```

## Testing Commands (No Changes to Current System)

### 1. Test New Engine Manager (Read-Only)
```bash
# Test engine manager without affecting current setup
awesome-client '
  local EngineManager = require("widgets.dictation_engine_manager")
  local em = EngineManager.new()
  em:set_engine("moshi")
  em:debug_print()
'
```

### 2. Compare Old vs New
```bash
# Compare outputs to ensure compatibility
awesome-client '
  local EngineManager = require("widgets.dictation_engine_manager")
  local em = EngineManager.new()
  em:set_engine("moshi")

  print("Current (hardcoded): moshi-stt")
  print("New (engine manager): " .. tostring(em:get_container_name()))
  print("Match: " .. tostring(em:get_container_name() == "moshi-stt"))
'
```

### 3. Verify Current Widget Still Works
```bash
# Test that existing dictation is unaffected
awesome-client 'require("widgets.dictation").Toggle()'

# Check status
awesome-client 'local d = require("widgets.dictation").GetStatus(); print(vim.inspect(d))'
```

## Switching Between Implementations

### Use Old Implementation (Current/Default)
```bash
# This is what you're using now - no changes needed
awesome-client 'require("widgets.dictation").Toggle()'
```

### Test New Implementation (Without Integration)
```bash
# Create a test instance using engine manager
awesome-client '
  local EngineManager = require("widgets.dictation_engine_manager")
  local em = EngineManager.new()
  em:set_engine("moshi")

  -- Get commands that WOULD be used
  print("Container check: " .. em:get_container_check_cmd())
  print("Client command: " .. em:get_client_cmd())

  -- These are identical to current implementation
'
```

### Verify Engine Files Exist
```bash
# Check that new files are in place
ls -la widgets/dictation_engine*.lua

# Expected:
# widgets/dictation_engines.lua
# widgets/dictation_engine_manager.lua
```

### Run Complete Test Suite
```bash
# Ensure nothing is broken
./tests/run_tests.sh

# Expected: 94 tests pass (46 core + 48 engine)
```

## Container Status Commands (Safe)

```bash
# Check if moshi container exists
podman ps -a | grep moshi-stt

# View container logs
podman logs moshi-stt --tail 20

# These work with both old and new implementation
```

## Rollback Commands (If Needed)

```bash
# Remove new files (doesn't affect current system)
rm widgets/dictation_engines.lua
rm widgets/dictation_engine_manager.lua

# Current dictation.lua is unchanged and will continue working
```

## Phase 1 Verification Checklist

Run these in order to confirm Phase 1 success:

1. **New files created** ✓
   ```bash
   ls widgets/dictation_engine*.lua
   ```

2. **Tests pass** ✓
   ```bash
   lua5.4 test_phase1.lua
   # Should see: "COMPATIBILITY: 6/6 checks passed"
   ```

3. **Current widget works** ✓
   ```bash
   awesome-client 'require("widgets.dictation").Toggle()'
   ```

4. **All unit tests pass** ✓
   ```bash
   ./tests/run_tests.sh --unit-only
   # Should see: 94 tests pass
   ```

## What's Next?

Phase 1 is complete when:
- ✅ New files exist (dictation_engines.lua, dictation_engine_manager.lua)
- ✅ All tests pass
- ✅ Current dictation widget works exactly as before
- ✅ You can query the engine manager without affecting the running system

**Important**: Phase 1 does NOT modify dictation.lua. The current system is completely unchanged. The new files are ready for Phase 2 integration when you're ready.