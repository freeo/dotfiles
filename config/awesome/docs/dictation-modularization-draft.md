# Dictation System Modularization Draft

## Core Insight

Each STT system is fundamentally different:
- **Moshi**: WebSocket + msgpack protocol on port 5455
- **Whisper**: REST API, different audio format
- **DeepGram**: Different WebSocket protocol
- **Local models**: May use pipes or shared memory

**Conclusion**: We need to treat container + client as an inseparable **Engine Pair**.

## Proposed Architecture

```
┌─────────────────────────────────────────────┐
│            Dictation Widget (UI)             │
│         (Unchanged - Already Modular)        │
└─────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────┐
│           Engine Manager (NEW)               │
│   - Manages engine pairs                     │
│   - Switches between engines                 │
│   - Provides unified interface               │
└─────────────────────────────────────────────┘
                      │
        ┌─────────────┴──────────────┐
        ▼                            ▼
┌──────────────────┐        ┌──────────────────┐
│  Moshi Engine    │        │  Whisper Engine  │
│  ├─ Container    │        │  ├─ Container    │
│  └─ Client       │        │  └─ Client       │
└──────────────────┘        └──────────────────┘
```

## Engine Pair Abstraction

### Engine Definition Structure
```lua
-- widgets/dictation_engines.lua (NEW FILE)
local engines = {}

engines.moshi = {
    -- Container configuration
    container = {
        name = "moshi-stt",
        image = "localhost/moshi-stt:cuda",
        port_mapping = "5455:8080",
        readiness_check = {
            method = "log",
            pattern = "ASR loop is now receiving",
            timeout = 10
        }
    },

    -- Client configuration
    client = {
        script = "/home/freeo/dotfiles/config/awesome/scripts/dictate_container_client.py",
        args = {
            "--url", "ws://localhost:5455/api/asr-streaming",
            "--output", "auto"
        },
        python_required = true,
        python_cmd = "/home/freeo/.local/share/mise/installs/python/3.11.6/bin/python"
    },

    -- Engine metadata
    metadata = {
        display_name = "Moshi STT",
        description = "High-performance WebSocket-based STT",
        supported_languages = {"en"},
        requires_gpu = true
    }
}

engines.whisper = {
    container = {
        name = "whisper-stt",
        image = "localhost/whisper:latest",
        port_mapping = "5456:8000",
        readiness_check = {
            method = "http",
            endpoint = "http://localhost:5456/health",
            timeout = 15
        }
    },

    client = {
        script = "/home/freeo/dotfiles/config/awesome/scripts/whisper_client.py",
        args = {
            "--api-url", "http://localhost:5456/v1/audio/transcriptions",
            "--output", "auto"
        },
        python_required = true,
        python_cmd = "/home/freeo/.local/share/mise/installs/python/3.11.6/bin/python"
    },

    metadata = {
        display_name = "OpenAI Whisper",
        description = "Accurate multi-language STT",
        supported_languages = {"en", "es", "fr", "de", "zh"},
        requires_gpu = false
    }
}

return engines
```

### Engine Manager
```lua
-- widgets/dictation_engine_manager.lua (NEW FILE)
local EngineManager = {}
EngineManager.__index = EngineManager

function EngineManager.new()
    local self = setmetatable({}, EngineManager)
    self.engines = require("widgets.dictation_engines")
    self.current_engine = nil
    self.current_engine_name = nil
    return self
end

function EngineManager:set_engine(engine_name)
    if not self.engines[engine_name] then
        return false, "Unknown engine: " .. engine_name
    end

    -- If switching engines, stop current one
    if self.current_engine_name and self.current_engine_name ~= engine_name then
        self:stop_current_engine()
    end

    self.current_engine = self.engines[engine_name]
    self.current_engine_name = engine_name
    return true
end

function EngineManager:get_container_name()
    if not self.current_engine then
        return nil
    end
    return self.current_engine.container.name
end

function EngineManager:get_container_check_cmd()
    local name = self:get_container_name()
    if not name then return nil end

    return string.format(
        "podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^%s'",
        name
    )
end

function EngineManager:get_container_start_cmd()
    local name = self:get_container_name()
    if not name then return nil end

    return string.format("podman start %s", name)
end

function EngineManager:get_client_cmd()
    if not self.current_engine then return nil end

    local client = self.current_engine.client
    local cmd_parts = {}

    if client.python_required then
        table.insert(cmd_parts, client.python_cmd)
    end

    table.insert(cmd_parts, client.script)

    for _, arg in ipairs(client.args or {}) do
        table.insert(cmd_parts, arg)
    end

    return table.concat(cmd_parts, " ")
end

function EngineManager:get_readiness_check()
    if not self.current_engine then return nil end

    local check = self.current_engine.container.readiness_check

    if check.method == "log" then
        return {
            type = "log_pattern",
            pattern = check.pattern,
            timeout = check.timeout or 10
        }
    elseif check.method == "http" then
        return {
            type = "http_check",
            endpoint = check.endpoint,
            timeout = check.timeout or 10
        }
    end

    return nil
end

return EngineManager
```

## Modified DictationController

```lua
-- In widgets/dictation.lua
local EngineManager = require("widgets.dictation_engine_manager")

-- In config section
local config = {
    -- NEW: Engine selection
    engine = "moshi",  -- Default engine

    -- DEPRECATED (but kept for backward compatibility)
    container_dictate_script = "...",  -- Will be ignored if engine is set

    -- Rest remains the same
    use_container = true,
    timeout = 10,
    log_file = "/home/freeo/wb/awm_dict.log",
    debug = false,
    client_start_delay = 0.2,
}

-- In DictationController.new()
function DictationController.new()
    local self = setmetatable({}, DictationController)

    -- NEW: Initialize engine manager
    self.engine_manager = EngineManager.new()

    -- Set default engine
    local engine = config.engine or "moshi"
    local ok, err = self.engine_manager:set_engine(engine)
    if not ok then
        print("WARNING: Failed to set engine: " .. err)
        -- Fallback to moshi
        self.engine_manager:set_engine("moshi")
    end

    -- Rest remains the same
    self.process_pid = nil
    self.is_running = false
    self.stopping = false
    self.callbacks = {
        on_starting = function() end,
        on_start = function() end,
        on_stopping = function() end,
        on_stop = function() end,
        on_error = function(msg) end,
    }
    return self
end

-- Modified _start_container_and_client to use engine manager
function DictationController:_start_container_and_client()
    self:_log("Starting container with engine: " .. (self.engine_manager.current_engine_name or "unknown"))

    -- Use engine manager for container check
    local check_cmd = self.engine_manager:get_container_check_cmd()
    if not check_cmd then
        self:_log("ERROR: No container check command available")
        self.callbacks.on_error("Engine not configured properly")
        return
    end

    awful.spawn.easy_async_with_shell(check_cmd, function(stdout, stderr, reason, exit_code)
        -- Parse container state (now using dynamic container name)
        local container_name = self.engine_manager:get_container_name()
        local container_state = "missing"

        if stdout and stdout ~= "" then
            if stdout:match(container_name) then
                local state_match = stdout:match(container_name .. "%s+(%S+)")
                if state_match then
                    container_state = state_match:lower()
                end
            end
        end

        -- Rest of the logic remains the same but uses engine manager
        -- ...
    end)
end
```

## Test Coverage Strategy

### 1. Engine Manager Tests
```lua
-- tests/engine_manager_test.lua
describe("Engine Manager", function()
    local em = EngineManager.new()

    -- Test engine switching
    assert_true(em:set_engine("moshi"), "Should set moshi engine")
    assert_equal(em:get_container_name(), "moshi-stt")

    assert_true(em:set_engine("whisper"), "Should switch to whisper")
    assert_equal(em:get_container_name(), "whisper-stt")

    -- Test command generation
    em:set_engine("moshi")
    local cmd = em:get_client_cmd()
    assert_match(cmd, "dictate_container_client.py")
    assert_match(cmd, "5455")

    -- Test unknown engine
    local ok, err = em:set_engine("unknown")
    assert_false(ok, "Should fail for unknown engine")
    assert_match(err, "Unknown engine")
end)
```

### 2. Backward Compatibility Tests
```lua
describe("Backward Compatibility", function()
    -- Ensure old config still works
    local old_config = {
        container_dictate_script = "/path/to/old/script.py",
        use_container = true
    }

    -- Should default to moshi engine
    local controller = DictationController.new()
    assert_equal(controller.engine_manager.current_engine_name, "moshi")
end)
```

### 3. Integration Tests
```lua
describe("Engine Integration", function()
    -- Test full lifecycle with moshi
    local controller = DictationController.new()
    controller.engine_manager:set_engine("moshi")

    -- Mock container check
    mock_podman_output("moshi-stt running")

    controller:start()
    assert_true(controller.is_running)

    controller:stop()
    assert_false(controller.is_running)
end)
```

## Migration Path

### Phase 1: Add Engine Infrastructure (No Breaking Changes)
1. Create `dictation_engines.lua` with moshi definition
2. Create `dictation_engine_manager.lua`
3. Add comprehensive tests for new modules
4. **Verify**: Current setup still works unchanged

### Phase 2: Integrate Engine Manager (Backward Compatible)
1. Modify `dictation.lua` to use engine manager
2. Keep all old config options working
3. Default to moshi engine
4. **Verify**: All existing tests pass

### Phase 3: Add Second Engine (New Feature)
1. Add whisper engine definition
2. Create whisper client script
3. Test engine switching
4. **Verify**: Both engines work independently

### Phase 4: UI for Engine Selection (Future)
1. Add dropdown or menu for engine selection
2. Save preference to config
3. Hot-swap engines without restart

## Risk Analysis

### Low Risk
- Engine definitions in separate file
- Engine manager as new abstraction layer
- All changes backward compatible

### Medium Risk
- Modifying container detection logic
- Client script launching changes

### Mitigation
- Comprehensive test coverage before each change
- Keep backup of working version
- Test on non-production first

## Success Criteria

1. **Zero Breaking Changes**: Current moshi setup works without any config changes
2. **Clean Separation**: Each engine is self-contained
3. **Easy Addition**: New engines can be added by just adding definition
4. **Test Coverage**: 100% backward compatibility tests pass
5. **Performance**: No degradation in startup time

## Conclusion

This modularization treats container+client as an atomic "Engine Pair", which matches the reality that different STT systems have completely different protocols. The Engine Manager provides the abstraction layer while maintaining full backward compatibility with the current moshi-stt implementation.