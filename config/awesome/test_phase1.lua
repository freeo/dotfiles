#!/usr/bin/env lua
-- Phase 1 Test Script
-- Tests the new engine infrastructure without modifying existing code

print("===========================================")
print("    PHASE 1: Engine Infrastructure Test")
print("===========================================")

-- Add awesome widgets path
package.path = package.path .. ";/home/freeo/dotfiles/config/awesome/?.lua"

-- Test 1: Load engine definitions
print("\n[TEST 1] Loading Engine Definitions")
local engines = require("widgets.dictation_engines")
print("✓ Loaded dictation_engines.lua")

local engine_list = engines.list()
print("Available engines: " .. table.concat(engine_list, ", "))

-- Test 2: Validate moshi engine
print("\n[TEST 2] Validating Moshi Engine")
local moshi = engines.get("moshi")
if moshi then
	print("✓ Found moshi engine")
	local valid, msg = engines.validate(moshi)
	if valid then
		print("✓ Moshi engine is valid")
	else
		print("✗ Moshi engine validation failed: " .. msg)
	end
else
	print("✗ Moshi engine not found")
end

-- Test 3: Load engine manager
print("\n[TEST 3] Loading Engine Manager")
local EngineManager = require("widgets.dictation_engine_manager")
print("✓ Loaded dictation_engine_manager.lua")

-- Test 4: Create and configure engine manager
print("\n[TEST 4] Configuring Engine Manager")
local em = EngineManager.new()
print("✓ Created engine manager instance")

local ok, msg = em:set_engine("moshi")
if ok then
	print("✓ Set engine to moshi: " .. msg)
else
	print("✗ Failed to set engine: " .. msg)
end

-- Test 5: Compare with hardcoded values
print("\n[TEST 5] Comparing with Current Implementation")
print("=" .. string.rep("=", 40))

-- These are the hardcoded values from current dictation.lua
local current_values = {
	container_name = "moshi-stt",
	check_pattern = "grep '%^moshi%-stt'",
	start_cmd = "podman start moshi-stt",
	stop_cmd = "podman stop --time 0 moshi-stt",
	client_script = "dictate_container_client.py",
	readiness = "ASR loop is now receiving",
}

-- Get values from engine manager
local new_values = {
	container_name = em:get_container_name(),
	check_cmd = em:get_container_check_cmd(),
	start_cmd = em:get_container_start_cmd(),
	stop_cmd = em:get_container_stop_cmd(),
	client_cmd = em:get_client_cmd(),
	readiness = em:get_readiness_check(),
}

-- Detailed comparison
local matches = 0
local total = 0

-- Container name
total = total + 1
if new_values.container_name == current_values.container_name then
	matches = matches + 1
	print(string.format("✓ Container name: %s", new_values.container_name))
else
	print(
		string.format("✗ Container name mismatch: %s vs %s", new_values.container_name, current_values.container_name)
	)
end

-- Check command (look for pattern)
total = total + 1
if new_values.check_cmd and new_values.check_cmd:match(current_values.check_pattern) then
	matches = matches + 1
	print("✓ Check command contains correct pattern")
else
	print("✗ Check command mismatch")
end

-- Start command
total = total + 1
if new_values.start_cmd == current_values.start_cmd then
	matches = matches + 1
	print(string.format("✓ Start command: %s", new_values.start_cmd))
else
	print(string.format("✗ Start command mismatch: %s vs %s", new_values.start_cmd, current_values.start_cmd))
end

-- Stop command
total = total + 1
if new_values.stop_cmd == current_values.stop_cmd then
	matches = matches + 1
	print(string.format("✓ Stop command: %s", new_values.stop_cmd))
else
	print(string.format("✗ Stop command mismatch: %s vs %s", new_values.stop_cmd, current_values.stop_cmd))
end

-- Client script
total = total + 1
if new_values.client_cmd and new_values.client_cmd:match(current_values.client_script) then
	matches = matches + 1
	print("✓ Client command contains correct script")
else
	print("✗ Client script not found in command")
end

-- Readiness pattern
total = total + 1
if new_values.readiness and new_values.readiness.pattern == current_values.readiness then
	matches = matches + 1
	print(string.format("✓ Readiness pattern: %s", new_values.readiness.pattern))
else
	print("✗ Readiness pattern mismatch")
end

-- Summary
print("\n" .. string.rep("=", 45))
print(string.format("COMPATIBILITY: %d/%d checks passed", matches, total))

if matches == total then
	print("\n✅ SUCCESS: New implementation is 100% compatible!")
	print("   The engine manager produces identical outputs.")
else
	print("\n⚠️  WARNING: Some compatibility issues detected")
	print("   Review the differences above")
end

-- Test 6: List all generated commands
print("\n[TEST 6] Generated Commands")
print("=" .. string.rep("=", 40))
print("Container check:")
print("  " .. (new_values.check_cmd or "nil"))
print("\nContainer start:")
print("  " .. (new_values.start_cmd or "nil"))
print("\nContainer stop:")
print("  " .. (new_values.stop_cmd or "nil"))
print("\nClient launch:")
print("  " .. (new_values.client_cmd or "nil"))

-- Test 7: Engine metadata
print("\n[TEST 7] Engine Metadata")
local metadata = em:get_engine_metadata()
if metadata then
	print("Display name: " .. (metadata.display_name or "N/A"))
	print("Description: " .. (metadata.description or "N/A"))
	print("GPU required: " .. tostring(metadata.requires_gpu))
	print("Protocol: " .. (metadata.protocol or "N/A"))
	if metadata.supported_languages then
		print("Languages: " .. table.concat(metadata.supported_languages, ", "))
	end
end

print("\n===========================================")
print("         PHASE 1 TEST COMPLETE")
print("===========================================")
print("\nNext steps:")
print("1. Review the test results above")
print("2. If all tests pass, proceed to integration")
print("3. Use the switch commands (see documentation)")

return true
