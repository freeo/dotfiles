-- Dictation Test Harness
-- Allows switching between old (hardcoded) and new (engine-based) implementations
-- for testing and verification

local test_harness = {}

-- Test the new engine manager without modifying existing code
function test_harness.test_engine_manager()
    print("\n=== Testing New Engine Manager ===")

    -- Load the engine manager
    local EngineManager = require("widgets.dictation_engine_manager")
    local em = EngineManager.new()

    -- Test setting engine
    local ok, msg = em:set_engine("moshi")
    print("Set engine to moshi: " .. tostring(ok) .. " - " .. tostring(msg))

    -- Display configuration
    em:debug_print()

    -- Test all methods
    print("\nTesting methods:")
    print("  Container name: " .. tostring(em:get_container_name()))
    print("  Check command: " .. tostring(em:get_container_check_cmd()))
    print("  Start command: " .. tostring(em:get_container_start_cmd()))
    print("  Stop command: " .. tostring(em:get_container_stop_cmd()))
    print("  Client command: " .. tostring(em:get_client_cmd()))

    local readiness = em:get_readiness_check()
    if readiness then
        print("  Readiness type: " .. readiness.type)
        print("  Readiness pattern: " .. tostring(readiness.pattern))
    end

    print("\n=== Engine Manager Test Complete ===")
    return em
end

-- Compare old vs new implementation outputs
function test_harness.compare_implementations()
    print("\n=== Comparing Old vs New Implementation ===")

    -- Old implementation values (hardcoded in current dictation.lua)
    local old = {
        container_name = "moshi-stt",
        container_check = "podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^moshi-stt'",
        container_start = "podman start moshi-stt",
        container_stop = "podman stop --time 0 moshi-stt",
        client_script = "/home/freeo/dotfiles/config/awesome/scripts/dictate_container_client.py",
        readiness_pattern = "ASR loop is now receiving"
    }

    -- New implementation values
    local EngineManager = require("widgets.dictation_engine_manager")
    local em = EngineManager.new()
    em:set_engine("moshi")

    local new = {
        container_name = em:get_container_name(),
        container_check = em:get_container_check_cmd(),
        container_start = em:get_container_start_cmd(),
        container_stop = em:get_container_stop_cmd(),
        client_script = em:get_client_cmd(),
        readiness_pattern = em:get_readiness_check() and em:get_readiness_check().pattern
    }

    -- Compare values
    local all_match = true
    for key, old_val in pairs(old) do
        local new_val = new[key]

        -- Special handling for client script (new includes python path)
        if key == "client_script" then
            if new_val and new_val:match(old_val) then
                print(string.format("  ✓ %s matches (contains expected script)", key))
            else
                print(string.format("  ✗ %s MISMATCH!", key))
                print(string.format("    Old: %s", old_val))
                print(string.format("    New: %s", tostring(new_val)))
                all_match = false
            end
        else
            if old_val == new_val then
                print(string.format("  ✓ %s matches", key))
            else
                print(string.format("  ✗ %s MISMATCH!", key))
                print(string.format("    Old: %s", old_val))
                print(string.format("    New: %s", tostring(new_val)))
                all_match = false
            end
        end
    end

    if all_match then
        print("\n✓✓✓ SUCCESS: New implementation produces identical outputs! ✓✓✓")
    else
        print("\n✗✗✗ WARNING: Some values don't match - review differences ✗✗✗")
    end

    print("\n=== Comparison Complete ===")
    return all_match
end

-- Test container operations (safe - just checks, doesn't start/stop)
function test_harness.test_container_operations()
    print("\n=== Testing Container Operations (Read-Only) ===")

    local EngineManager = require("widgets.dictation_engine_manager")
    local em = EngineManager.new()
    em:set_engine("moshi")

    -- Check container status using the command
    local awful = require("awful")
    local check_cmd = em:get_container_check_cmd()

    print("Running container check: " .. check_cmd)

    awful.spawn.easy_async_with_shell(check_cmd, function(stdout, stderr, reason, exit_code)
        if stdout and stdout ~= "" then
            print("Container status: " .. stdout)
        else
            print("Container not found or not running")
        end
    end)
end

-- Switch to using new implementation (creates a modified dictation module)
function test_harness.create_new_implementation()
    print("\n=== Creating New Implementation Module ===")

    -- This creates a new module that uses the engine manager
    -- without modifying the original dictation.lua

    local dictation_new = {}

    -- Copy the existing module structure but use engine manager
    local EngineManager = require("widgets.dictation_engine_manager")
    local engine_manager = EngineManager.new()
    engine_manager:set_engine("moshi")

    -- Store reference for testing
    dictation_new.engine_manager = engine_manager

    -- Expose same API as original but using engine manager
    dictation_new.get_container_name = function()
        return engine_manager:get_container_name()
    end

    dictation_new.get_container_check_cmd = function()
        return engine_manager:get_container_check_cmd()
    end

    dictation_new.get_client_cmd = function()
        return engine_manager:get_client_cmd()
    end

    print("New implementation module created")
    print("Access via: require('widgets.dictation_test_harness').dictation_new")

    return dictation_new
end

-- Store the new implementation
test_harness.dictation_new = nil

-- Initialize function
function test_harness.init()
    test_harness.dictation_new = test_harness.create_new_implementation()
    return test_harness
end

return test_harness
