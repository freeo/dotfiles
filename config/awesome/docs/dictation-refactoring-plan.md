# Dictation System Refactoring Plan

## Executive Summary

The dictation system is ready for safe refactoring to support multiple STT containers. With 46 passing unit tests and comprehensive documentation, we can proceed with confidence that the existing moshi-stt functionality will remain intact.

## Current Status ✅

### Completed Analysis

- **Modularity Report**: `docs/dictation-modularity-analysis.md`
- **Testing Strategy**: `docs/dictation-testing-strategy.md`
- **Unit Tests**: `tests/dictation_test.lua` (46 tests, 100% passing)
- **Test Runner**: `tests/run_tests.sh`

### Test Coverage

```
✓ Container State Parsing     - 6 tests
✓ Configuration Validation    - 4 tests
✓ State Transitions          - 7 tests
✓ Widget Positioning         - 6 tests
✓ Command Construction       - 6 tests
✓ Color Schemes             - 8 tests
✓ Process Management        - 5 tests
✓ Container Readiness       - 4 tests
```

## Key Findings

### High Coupling Areas (Refactoring Required)

1. **Container name "moshi-stt"** - Hardcoded in 8+ locations
2. **Client script path** - Single path assumes moshi protocol
3. **Readiness detection** - "ASR loop" pattern is moshi-specific

### Well-Modularized Components (No Changes Needed)

1. **UIManager** - Completely container-agnostic
2. **Screen handling** - Independent of STT engine
3. **State machine** - Generic transitions

## Safe Refactoring Approach

### Phase 1: Configuration Abstraction ✅ SAFE

```lua
-- Add to config
config.container_name = "moshi-stt"  -- Make configurable

-- Replace hardcoded references
"grep '^moshi-stt'" → "grep '^" .. config.container_name .. "'"
```

### Phase 2: Engine Registry ✅ SAFE

```lua
-- Create engine configurations
config.engines = {
    moshi = {
        container_name = "moshi-stt",
        client_script = "dictate_container_client.py",
        readiness_pattern = "ASR loop is now receiving"
    },
    whisper = {
        container_name = "whisper-stt",
        client_script = "whisper_client.py",
        readiness_pattern = "Model loaded"
    }
}

-- Current engine selection
config.current_engine = config.engines[config.engine or "moshi"]
```

### Phase 3: Strategy Pattern ✅ SAFE

```lua
-- Extract container operations
local ContainerStrategy = {}

function ContainerStrategy:new(engine_config)
    return setmetatable({config = engine_config}, {__index = self})
end

function ContainerStrategy:get_container_name()
    return self.config.container_name
end

function ContainerStrategy:get_client_command()
    return self.config.client_script
end
```

## Testing Validation

### Before Each Change

```bash
# Run baseline tests
./tests/run_tests.sh --unit-only
# Expected: 46 tests pass
```

### After Each Change

```bash
# Verify no regression
./tests/run_tests.sh --unit-only
# Expected: 46 tests still pass

# Test actual widget
awesome-client 'require("widgets.dictation").Toggle()'
# Expected: Widget works as before
```

## Risk Mitigation

### Backup Points

1. ✅ Current backup: `dictation.lua.backup-xrandr`
2. Create new backup before refactoring:
   ```bash
   cp widgets/dictation.lua widgets/dictation.lua.backup-multi-engine
   ```

### Rollback Procedure

```bash
# If anything breaks
cp widgets/dictation.lua.backup-xrandr widgets/dictation.lua
awesome-client 'awesome.restart()'
```

## Next Steps

### 1. Implement Configuration Abstraction (Low Risk)

- Extract hardcoded "moshi-stt" to config
- Run tests after each extraction
- Test widget functionality

### 2. Add Engine Registry (Low Risk)

- Create engines table in config
- Default to moshi engine
- Maintain backward compatibility

### 3. Test New Container (Medium Risk)

- Add whisper/deepgram configuration
- Test switching between engines
- Verify both work independently

### 4. Documentation Update

- Update user documentation
- Add multi-engine examples
- Document breaking changes (none expected)

## Success Criteria

1. **No Breaking Changes**: Existing moshi-stt setup works without modification
2. **Clean Abstractions**: New containers can be added with config only
3. **Test Coverage**: All tests continue passing
4. **Performance**: No degradation in startup/response time
5. **User Experience**: Seamless engine switching

## Commands Reference

### Testing

```bash
# Run all tests
./tests/run_tests.sh

# Unit tests only
./tests/run_tests.sh --unit-only

# Direct Lua testing
lua5.4 tests/dictation_test.lua
```

### Widget Testing

```bash
# Toggle widget
awesome-client 'require("widgets.dictation").Toggle()'

# Check status
awesome-client 'local d = require("widgets.dictation"); print(vim.inspect(d.GetStatus()))'

# Debug mode
awesome-client 'require("widgets.dictation").SetConfig({debug = true})'
```

### Container Management

```bash
# Check container status
podman ps -a | grep stt

# View container logs
podman logs moshi-stt --tail 50

# Stop container
podman stop --time 0 moshi-stt
```

## Timeline

- **Week 1**: Configuration abstraction (2-4 hours)
- **Week 2**: Engine registry implementation (2-4 hours)
- **Week 3**: Test with second container (4-6 hours)
- **Week 4**: Documentation and polish (2 hours)

Total estimated effort: 10-16 hours

## Conclusion

The dictation system is well-prepared for multi-engine support. With comprehensive tests in place and a clear refactoring path, we can safely extend functionality without risking the current implementation. The modular architecture already in place (UIManager, callbacks, state management) will remain unchanged, ensuring stability.

