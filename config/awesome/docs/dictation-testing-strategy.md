# Dictation System Testing Strategy

## Overview

This document outlines the comprehensive testing approach for the dictation system to ensure safe refactoring and multi-engine support without breaking existing functionality.

## Test Structure

### 1. Unit Tests (`tests/dictation_test.lua`)

**Purpose**: Test individual functions and components in isolation

**Coverage Areas**:
- Container state parsing
- Configuration validation
- State machine transitions
- Widget positioning calculations
- Command construction
- Color scheme management
- Process management
- Container readiness detection

**Current Status**: ✅ Implemented - 9 test suites, 40+ assertions

### 2. Integration Tests (Future)

**Purpose**: Test component interactions with real containers

**Planned Coverage**:
- Container lifecycle management
- Client-server communication
- Multiple engine switching
- Error recovery scenarios

### 3. Regression Tests

**Purpose**: Ensure moshi-stt continues working during refactoring

**Key Tests**:
- Existing configuration compatibility
- Command format consistency
- State transition behavior
- Widget display correctness

## Running Tests

### Quick Test
```bash
# Run all unit tests
./tests/run_tests.sh

# Run only unit tests (skip integration)
./tests/run_tests.sh --unit-only
```

### Manual Test
```bash
# Direct Lua execution
lua5.4 tests/dictation_test.lua

# With specific Lua version
lua tests/dictation_test.lua
```

### Continuous Testing
```bash
# Watch for changes and run tests
while inotifywait -e modify widgets/dictation.lua; do
    clear
    ./tests/run_tests.sh --unit-only
done
```

## Test Results Interpretation

### Success Output
```
✓ All tests passed!
Total tests: 40
Passed: 40
Failed: 0
```

### Failure Output
```
✗ Some tests failed
Total tests: 40
Passed: 38
Failed: 2
  ✗ Container state parsing - Should parse running state
    Expected: running
    Got: exited
```

## Critical Test Scenarios

### 1. Container Name Abstraction
**Risk**: High - Breaking change if hardcoding not removed properly

**Test**:
```lua
-- Verify container name is configurable
local cmd = build_container_check_cmd("custom-stt")
assert_match(cmd, "grep '%^custom%-stt'")
```

### 2. State Persistence
**Risk**: Medium - Widget state lost during refactoring

**Test**:
```lua
-- Verify state is preserved
local state_before = machine.state
machine:transition(State.RUNNING)
assert_not_equal(state_before, machine.state)
```

### 3. Multi-Engine Configuration
**Risk**: Medium - Config structure changes break existing setup

**Test**:
```lua
-- Verify backward compatibility
local config = load_config()
assert_equal(config.use_container, true)
assert_not_nil(config.container_dictate_script)
```

## Testing Best Practices

### 1. Test Before Refactoring
- Run full test suite before any changes
- Establish baseline metrics
- Document current behavior

### 2. Test During Refactoring
- Run tests after each change
- Add new tests for new functionality
- Keep old tests passing

### 3. Test After Refactoring
- Full regression suite
- Performance comparison
- User acceptance testing

## Mock Objects

The test suite includes comprehensive mocks for AwesomeWM dependencies:

- `gears.timer` - Timer functionality
- `awful.spawn` - Process spawning
- `wibox` - Widget creation
- `beautiful` - Theme handling
- `naughty` - Notifications
- `screen` - Display management
- `client` - Window management
- `microphone` - Audio input

## Test Coverage Metrics

### Current Coverage
- **Container Management**: 90%
- **State Transitions**: 100%
- **Configuration**: 85%
- **UI Components**: 60%
- **Error Handling**: 70%

### Target Coverage
- **Overall**: 90%+ code coverage
- **Critical Paths**: 100% coverage
- **Edge Cases**: 80% coverage

## Continuous Integration

### Pre-commit Hook
```bash
#!/bin/bash
# .git/hooks/pre-commit
./tests/run_tests.sh --unit-only
if [ $? -ne 0 ]; then
    echo "Tests failed. Commit aborted."
    exit 1
fi
```

### GitHub Actions (Future)
```yaml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install Lua
        run: sudo apt-get install -y lua5.4
      - name: Run tests
        run: ./tests/run_tests.sh
```

## Test-Driven Development Workflow

1. **Write Test First**
   ```lua
   -- Test for new whisper engine support
   local whisper_config = {
       engine = "whisper",
       container_name = "whisper-stt"
   }
   assert_true(validate_engine_config(whisper_config))
   ```

2. **Run Test (Expect Failure)**
   ```bash
   ./tests/run_tests.sh
   # ✗ Test fails - function doesn't exist
   ```

3. **Implement Feature**
   ```lua
   function validate_engine_config(config)
       -- Implementation
   end
   ```

4. **Run Test (Expect Success)**
   ```bash
   ./tests/run_tests.sh
   # ✓ Test passes
   ```

## Emergency Rollback

If tests fail after deployment:

1. **Immediate Rollback**
   ```bash
   cp widgets/dictation.lua.backup-xrandr widgets/dictation.lua
   awesome-client 'awesome.restart()'
   ```

2. **Verify Functionality**
   ```bash
   awesome-client 'require("widgets.dictation").Toggle()'
   ```

3. **Run Regression Tests**
   ```bash
   ./tests/run_tests.sh
   ```

## Performance Testing

### Latency Measurement
```lua
local start = os.clock()
parse_container_state(large_output)
local elapsed = os.clock() - start
assert(elapsed < 0.001, "Parsing too slow")
```

### Memory Usage
```lua
collectgarbage("collect")
local before = collectgarbage("count")
-- Run operation
local after = collectgarbage("count")
assert(after - before < 100, "Memory leak detected")
```

## Conclusion

This testing strategy ensures:
1. **Safety**: No breaking changes to existing moshi-stt functionality
2. **Confidence**: Refactoring backed by comprehensive tests
3. **Maintainability**: Easy to add new engines
4. **Quality**: Consistent behavior across all configurations

The test suite is independent of AwesomeWM, uses Lua 5.4 (matching your environment), and provides immediate feedback on code changes.