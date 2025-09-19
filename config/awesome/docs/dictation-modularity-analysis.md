# Dictation System Modularity Analysis

## Executive Summary

The current dictation system is moderately modular but has significant coupling to the `moshi-stt` container. To support multiple STT engines, we need to extract container-specific logic into a configurable strategy pattern while preserving the existing functionality.

## Current Architecture Analysis

### 1. Tightly Coupled Components

#### Container Name Hardcoding
- **Location**: Lines 140, 156, 186, 195, etc.
- **Issue**: "moshi-stt" is hardcoded throughout
- **Impact**: Cannot switch containers without code changes

```lua
-- Current (coupled):
"podman ps -a --format '{{.Names}} {{.State}}' | grep '^moshi-stt'"

-- Needed (modular):
"podman ps -a --format '{{.Names}} {{.State}}' | grep '^" .. config.container_name .. "'"
```

#### Client Script Path
- **Location**: Line 37
- **Issue**: Single client script path assumes moshi-specific protocol
- **Impact**: Different containers need different client scripts

#### Container Detection Logic
- **Location**: `_start_container_and_client()` function
- **Issue**: ASR readiness detection is moshi-specific
- **Impact**: Other containers may have different readiness indicators

### 2. Well-Modularized Components

#### UIManager
- **Strength**: Completely independent of container specifics
- **Reusability**: 100% - works with any backend

#### Callback System
- **Strength**: Event-driven architecture
- **Reusability**: 100% - container agnostic

#### State Management
- **Strength**: Generic state machine (starting, running, stopping, stopped)
- **Reusability**: 95% - minor adjustments for container-specific states

### 3. Semi-Modular Components

#### DictationController
- **Coupled Parts**:
  - Container name references
  - Client script launching
  - Readiness detection
- **Generic Parts**:
  - Process lifecycle management
  - State transitions
  - Error handling

## Refactoring Requirements

### Phase 1: Configuration Abstraction

```lua
-- Proposed config structure
local config = {
    -- Current engine selection
    engine = "moshi",  -- or "whisper", "deepgram", etc.

    -- Engine-specific configurations
    engines = {
        moshi = {
            container_name = "moshi-stt",
            client_script = "/path/to/moshi_client.py",
            readiness_pattern = "ASR loop is now receiving",
            port = 5455,
            websocket_endpoint = "/api/asr-streaming"
        },
        whisper = {
            container_name = "whisper-stt",
            client_script = "/path/to/whisper_client.py",
            readiness_pattern = "Model loaded",
            port = 5456,
            rest_endpoint = "/v1/audio/transcriptions"
        }
    }
}
```

### Phase 2: Strategy Pattern Implementation

```lua
-- Container strategy interface
local ContainerStrategy = {}
ContainerStrategy.__index = ContainerStrategy

function ContainerStrategy:new(engine_config)
    local self = setmetatable({}, self)
    self.config = engine_config
    return self
end

function ContainerStrategy:get_container_check_cmd()
    return string.format(
        "podman ps -a --format '{{.Names}} {{.State}}' | grep '^%s'",
        self.config.container_name
    )
end

function ContainerStrategy:get_readiness_check()
    return self.config.readiness_pattern
end

function ContainerStrategy:get_client_cmd(python_path)
    return string.format("%s %s", python_path, self.config.client_script)
end
```

## Testing Strategy

### Unit Test Requirements

1. **Container Detection Tests**
   - Mock podman output for various states
   - Verify correct state parsing
   - Test error handling

2. **State Transition Tests**
   - Test all valid state transitions
   - Verify callback invocations
   - Test concurrent operations

3. **Configuration Tests**
   - Verify engine switching
   - Test configuration validation
   - Test default fallbacks

4. **Client Launch Tests**
   - Mock process spawning
   - Verify correct command construction
   - Test PID tracking

### Integration Test Requirements

1. **Container Lifecycle**
   - Start/stop real containers
   - Verify state synchronization
   - Test recovery scenarios

2. **Multi-Engine Support**
   - Switch between engines
   - Verify clean transitions
   - Test concurrent engines

## Risk Assessment

### High Risk Areas
1. **Container name hardcoding** - Breaking change if not abstracted properly
2. **Client script assumptions** - Different protocols need different handling
3. **Readiness detection** - Container-specific patterns

### Low Risk Areas
1. **UIManager changes** - Already fully modular
2. **Callback system** - No changes needed
3. **Screen handling** - Independent of STT engine

## Implementation Plan

### Phase 1: Add Tests (No Breaking Changes)
1. Create comprehensive test suite for current implementation
2. Verify all tests pass with existing code
3. Establish baseline for refactoring

### Phase 2: Configuration Abstraction (Backward Compatible)
1. Add engine configuration structure
2. Default to "moshi" engine
3. Replace hardcoded values with config lookups

### Phase 3: Strategy Pattern (Backward Compatible)
1. Implement ContainerStrategy class
2. Create MoshiStrategy subclass
3. Migrate logic to strategy methods

### Phase 4: Multi-Engine Support (New Feature)
1. Add WhisperStrategy (or other)
2. Implement engine switching
3. Test concurrent engines

## Test Coverage Goals

- **Unit Tests**: 90% code coverage
- **Integration Tests**: All critical paths
- **Regression Tests**: Existing moshi functionality
- **Performance Tests**: Latency and resource usage

## Compatibility Matrix

| Component | Current Coupling | Target Modularity | Breaking Change Risk |
|-----------|-----------------|-------------------|---------------------|
| UIManager | 0% | 0% | None |
| DictationController | 60% | 10% | Medium |
| Config | 80% | 0% | Low |
| Client Scripts | 100% | 100% (by design) | None |

## Conclusion

The system requires moderate refactoring to support multiple STT engines. The main challenges are:

1. Abstracting container-specific hardcoding
2. Creating a plugin architecture for client scripts
3. Maintaining backward compatibility

With proper testing in place, we can safely refactor while ensuring the current moshi-stt implementation continues to work perfectly.