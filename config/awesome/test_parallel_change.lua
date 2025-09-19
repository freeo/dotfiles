#!/usr/bin/env lua
-- Test script for Parallel Change implementation

print("=========================================")
print("    PARALLEL CHANGE TEST")
print("=========================================")

-- Test 1: Old Implementation
print("\n[TEST 1] Testing OLD Implementation")
print("Setting USE_ENGINE_MANAGER = false")

-- Simulate old implementation
local USE_ENGINE_MANAGER = false
local container_name = "moshi-stt" -- Hardcoded
local check_cmd = "podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^moshi-stt'"
local start_cmd = "podman start moshi-stt"
local stop_cmd = "podman stop --time 0 moshi-stt"
local client_script = "/home/freeo/dotfiles/config/awesome/scripts/dictate_container_client.py"

print("  Container: " .. container_name)
print("  Check: " .. check_cmd:sub(1, 50) .. "...")
print("  Start: " .. start_cmd)
print("  Stop: " .. stop_cmd)
print("  Client: " .. client_script:match("([^/]+)$"))

-- Test 2: New Implementation
print("\n[TEST 2] Testing NEW Implementation")
print("Setting USE_ENGINE_MANAGER = true")

-- Load engine manager
package.path = package.path .. ";/home/freeo/dotfiles/config/awesome/?.lua"
local EngineManager = require("widgets.dictation_engine_manager")
local engine_manager = EngineManager.new()
engine_manager:set_engine("moshi")

USE_ENGINE_MANAGER = true
container_name = engine_manager:get_container_name()
check_cmd = engine_manager:get_container_check_cmd()
start_cmd = engine_manager:get_container_start_cmd()
stop_cmd = engine_manager:get_container_stop_cmd()
local client_cmd = engine_manager:get_client_cmd()

print("  Container: " .. (container_name or "nil"))
print("  Check: " .. (check_cmd and check_cmd:sub(1, 50) .. "..." or "nil"))
print("  Start: " .. (start_cmd or "nil"))
print("  Stop: " .. (stop_cmd or "nil"))
print("  Client: " .. (client_cmd and client_cmd:match("([^/]+%.py)") or "nil"))

-- Test 3: Compare outputs
print("\n[TEST 3] Comparing Outputs")
print("=========================================")

local old_values = {
	container = "moshi-stt",
	start = "podman start moshi-stt",
	stop = "podman stop --time 0 moshi-stt",
}

local new_values = {
	container = engine_manager:get_container_name(),
	start = engine_manager:get_container_start_cmd(),
	stop = engine_manager:get_container_stop_cmd(),
}

local all_match = true
for key, old_val in pairs(old_values) do
	local new_val = new_values[key]
	if old_val == new_val then
		print("  ✓ " .. key .. " matches")
	else
		print("  ✗ " .. key .. " MISMATCH!")
		print("    Old: " .. old_val)
		print("    New: " .. tostring(new_val))
		all_match = false
	end
end

if all_match then
	print("\n✅ SUCCESS: Both implementations produce identical results!")
else
	print("\n⚠️  WARNING: Some differences detected")
end

print("\n=========================================")
print("    PARALLEL CHANGE TEST COMPLETE")
print("=========================================")

return true
