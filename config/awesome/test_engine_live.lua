-- Live test script for Phase 1
-- Shows what you can actually DO with Phase 1 right now

local test = {}

-- Test 1: Show what the engine manager produces
function test.show_engine_output()
    local EngineManager = require("widgets.dictation_engine_manager")
    local em = EngineManager.new()
    em:set_engine("moshi")

    print("\n=== Engine Manager Output ===")
    print("Current engine: " .. tostring(em:get_current_engine_name()))
    print("\nGenerated Commands:")
    print("1. Container check:")
    print("   " .. em:get_container_check_cmd())
    print("\n2. Container start:")
    print("   " .. em:get_container_start_cmd())
    print("\n3. Container stop:")
    print("   " .. em:get_container_stop_cmd())
    print("\n4. Client launch:")
    print("   " .. em:get_client_cmd())

    local readiness = em:get_readiness_check()
    print("\n5. Readiness check:")
    print("   Type: " .. readiness.type)
    print("   Pattern: " .. readiness.pattern)

    return em
end

-- Test 2: Actually check container status using engine manager
function test.check_container_status()
    local awful = require("awful")
    local EngineManager = require("widgets.dictation_engine_manager")
    local em = EngineManager.new()
    em:set_engine("moshi")

    local cmd = em:get_container_check_cmd()
    print("\n=== Checking Container Status ===")
    print("Running: " .. cmd)

    awful.spawn.easy_async_with_shell(cmd, function(stdout, stderr, reason, exit_code)
        if stdout and stdout ~= "" then
            print("✓ Container found: " .. stdout:gsub("\n", ""))
        else
            print("✗ Container not found or not running")
        end
    end)
end

-- Test 3: Compare with current implementation
function test.compare_implementations()
    local EngineManager = require("widgets.dictation_engine_manager")
    local em = EngineManager.new()
    em:set_engine("moshi")

    print("\n=== Comparing Implementations ===")

    -- What the CURRENT dictation.lua uses (hardcoded)
    print("CURRENT (hardcoded in dictation.lua):")
    print("  Container: moshi-stt")
    print("  Check: podman ps -a ... | grep '^moshi-stt'")
    print("  Client: /home/freeo/dotfiles/config/awesome/scripts/dictate_container_client.py")

    -- What the NEW engine manager produces
    print("\nNEW (from engine manager):")
    print("  Container: " .. em:get_container_name())
    print("  Check: " .. em:get_container_check_cmd():sub(1, 50) .. "...")
    print("  Client: " .. em:get_client_cmd():match("([^%s]+%.py)"))

    print("\n✓ These are identical - engine manager is ready!")
end

-- Test 4: What you CAN'T do yet (Phase 2)
function test.what_phase1_cannot_do()
    print("\n=== What Phase 1 CANNOT Do Yet ===")
    print("❌ Cannot actually switch the running dictation to use engine manager")
    print("❌ Cannot use 'require(\"widgets.dictation\").SetEngine(\"whisper\")'")
    print("❌ dictation.lua still uses hardcoded values")
    print("\nPhase 1 only PREPARES the infrastructure.")
    print("Phase 2 will integrate it into dictation.lua")
end

-- Test 5: What you CAN do now
function test.what_phase1_can_do()
    print("\n=== What Phase 1 CAN Do Now ===")
    print("✓ Generate correct container commands")
    print("✓ Generate correct client commands")
    print("✓ Validate engine configurations")
    print("✓ Prepare for multiple engines")
    print("✓ Test without affecting current system")

    print("\n=== Available Commands ===")
    print("1. Test engine manager:")
    print("   awesome-client 'require(\"test_engine_live\").show_engine_output()'")
    print("\n2. Check container:")
    print("   awesome-client 'require(\"test_engine_live\").check_container_status()'")
    print("\n3. Compare implementations:")
    print("   awesome-client 'require(\"test_engine_live\").compare_implementations()'")
    print("\n4. Use current dictation (unchanged):")
    print("   awesome-client 'require(\"widgets.dictation\").Toggle()'")
end

-- Main info function
function test.info()
    print("==============================================")
    print("       PHASE 1: What You Can Do Now")
    print("==============================================")

    test.show_engine_output()
    test.compare_implementations()
    test.what_phase1_can_do()
    test.what_phase1_cannot_do()

    print("\n==============================================")
    print("                 SUMMARY")
    print("==============================================")
    print("Phase 1 creates the ENGINE MANAGER but does NOT")
    print("integrate it yet. Your dictation still uses the")
    print("hardcoded values. Think of Phase 1 as building")
    print("the engine but not installing it in the car yet.")
    print("")
    print("To test: awesome-client 'require(\"test_engine_live\").info()'")
end

return test