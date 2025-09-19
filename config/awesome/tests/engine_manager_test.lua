#!/usr/bin/env lua
-- Engine Manager Tests for Dictation System
-- Tests the modularized engine architecture

-- Test framework setup
local test_count = 0
local pass_count = 0
local fail_count = 0

-- Color codes
local colors = {
	green = "\27[32m",
	red = "\27[31m",
	yellow = "\27[33m",
	reset = "\27[0m",
}

-- Test assertions
local function assert_equal(actual, expected, message)
	test_count = test_count + 1
	if actual == expected then
		pass_count = pass_count + 1
		print(string.format("  %s✓%s %s", colors.green, colors.reset, message or "test passed"))
		return true
	else
		fail_count = fail_count + 1
		print(string.format("  %s✗%s %s", colors.red, colors.reset, message or "test failed"))
		print(string.format("    Expected: %s", tostring(expected)))
		print(string.format("    Got: %s", tostring(actual)))
		return false
	end
end

local function assert_true(value, message)
	return assert_equal(value, true, message)
end

local function assert_false(value, message)
	return assert_equal(value, false, message)
end

local function assert_not_nil(value, message)
	test_count = test_count + 1
	if value ~= nil then
		pass_count = pass_count + 1
		print(string.format("  %s✓%s %s", colors.green, colors.reset, message or "not nil"))
		return true
	else
		fail_count = fail_count + 1
		print(string.format("  %s✗%s %s - value was nil", colors.red, colors.reset, message or "test failed"))
		return false
	end
end

local function assert_match(str, pattern, message)
	test_count = test_count + 1
	if string.match(str, pattern) then
		pass_count = pass_count + 1
		print(string.format("  %s✓%s %s", colors.green, colors.reset, message or "pattern matched"))
		return true
	else
		fail_count = fail_count + 1
		print(string.format("  %s✗%s %s", colors.red, colors.reset, message or "pattern not matched"))
		print(string.format("    String: %s", str))
		print(string.format("    Pattern: %s", pattern))
		return false
	end
end

local function describe(suite_name, tests)
	print(string.format("\n%s%s%s", colors.yellow, suite_name, colors.reset))
	tests()
end

-- Mock Engine Definitions
local function create_mock_engines()
	return {
		moshi = {
			container = {
				name = "moshi-stt",
				image = "localhost/moshi-stt:cuda",
				port_mapping = "5455:8080",
				readiness_check = {
					method = "log",
					pattern = "ASR loop is now receiving",
					timeout = 10,
				},
			},
			client = {
				script = "/path/to/dictate_container_client.py",
				args = { "--url", "ws://localhost:5455/api/asr-streaming", "--output", "auto" },
				python_required = true,
				python_cmd = "/usr/bin/python3",
			},
			metadata = {
				display_name = "Moshi STT",
				description = "WebSocket-based STT",
				supported_languages = { "en" },
				requires_gpu = true,
			},
		},
		whisper = {
			container = {
				name = "whisper-stt",
				image = "localhost/whisper:latest",
				port_mapping = "5456:8000",
				readiness_check = {
					method = "http",
					endpoint = "http://localhost:5456/health",
					timeout = 15,
				},
			},
			client = {
				script = "/path/to/whisper_client.py",
				args = { "--api-url", "http://localhost:5456/v1/transcriptions" },
				python_required = true,
				python_cmd = "/usr/bin/python3",
			},
			metadata = {
				display_name = "OpenAI Whisper",
				description = "Multi-language STT",
				supported_languages = { "en", "es", "fr", "de", "zh" },
				requires_gpu = false,
			},
		},
	}
end

-- Mock Engine Manager Implementation
local function create_engine_manager(engines)
	local manager = {
		engines = engines,
		current_engine = nil,
		current_engine_name = nil,
	}

	function manager:set_engine(engine_name)
		if not self.engines[engine_name] then
			return false, "Unknown engine: " .. engine_name
		end

		self.current_engine = self.engines[engine_name]
		self.current_engine_name = engine_name
		return true
	end

	function manager:get_container_name()
		if not self.current_engine then
			return nil
		end
		return self.current_engine.container.name
	end

	function manager:get_container_check_cmd()
		local name = self:get_container_name()
		if not name then
			return nil
		end
		return string.format("podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^%s'", name)
	end

	function manager:get_container_start_cmd()
		local name = self:get_container_name()
		if not name then
			return nil
		end
		return string.format("podman start %s", name)
	end

	function manager:get_container_stop_cmd()
		local name = self:get_container_name()
		if not name then
			return nil
		end
		return string.format("podman stop --time 0 %s", name)
	end

	function manager:get_client_cmd()
		if not self.current_engine then
			return nil
		end

		local client = self.current_engine.client
		if not client then
			return ""
		end -- Handle missing client gracefully

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

	function manager:get_readiness_check()
		if not self.current_engine then
			return nil
		end

		local check = self.current_engine.container.readiness_check
		return {
			type = check.method == "log" and "log_pattern" or "http_check",
			pattern = check.pattern,
			endpoint = check.endpoint,
			timeout = check.timeout,
		}
	end

	function manager:get_engine_metadata()
		if not self.current_engine then
			return nil
		end
		return self.current_engine.metadata
	end

	return manager
end

-- Tests
describe("Engine Manager - Basic Operations", function()
	local engines = create_mock_engines()
	local em = create_engine_manager(engines)

	-- Test initial state
	assert_equal(em.current_engine_name, nil, "Should start with no engine")
	assert_equal(em:get_container_name(), nil, "Should return nil container name when no engine")

	-- Test setting valid engine
	local ok, err = em:set_engine("moshi")
	assert_true(ok, "Should successfully set moshi engine")
	assert_equal(em.current_engine_name, "moshi", "Current engine should be moshi")
	assert_equal(em:get_container_name(), "moshi-stt", "Should return moshi container name")

	-- Test switching engines
	ok, err = em:set_engine("whisper")
	assert_true(ok, "Should successfully switch to whisper")
	assert_equal(em.current_engine_name, "whisper", "Current engine should be whisper")
	assert_equal(em:get_container_name(), "whisper-stt", "Should return whisper container name")

	-- Test invalid engine
	ok, err = em:set_engine("nonexistent")
	assert_false(ok, "Should fail for nonexistent engine")
	assert_match(err, "Unknown engine", "Should return unknown engine error")
	assert_equal(em.current_engine_name, "whisper", "Should keep previous engine on failure")
end)

describe("Engine Manager - Command Generation", function()
	local engines = create_mock_engines()
	local em = create_engine_manager(engines)

	-- Test moshi commands
	em:set_engine("moshi")

	local check_cmd = em:get_container_check_cmd()
	assert_match(check_cmd, "podman ps %-a", "Should have podman ps command")
	assert_match(check_cmd, "grep '%^moshi%-stt'", "Should grep for moshi container")

	local start_cmd = em:get_container_start_cmd()
	assert_equal(start_cmd, "podman start moshi-stt", "Should generate correct start command")

	local stop_cmd = em:get_container_stop_cmd()
	assert_equal(stop_cmd, "podman stop --time 0 moshi-stt", "Should generate correct stop command")

	local client_cmd = em:get_client_cmd()
	assert_match(client_cmd, "python3", "Should include python")
	assert_match(client_cmd, "dictate_container_client%.py", "Should include moshi client script")
	assert_match(client_cmd, "5455", "Should include moshi port")
	assert_match(client_cmd, "ws://localhost", "Should include websocket URL")

	-- Test whisper commands
	em:set_engine("whisper")

	check_cmd = em:get_container_check_cmd()
	assert_match(check_cmd, "grep '%^whisper%-stt'", "Should grep for whisper container")

	client_cmd = em:get_client_cmd()
	assert_match(client_cmd, "whisper_client%.py", "Should include whisper client script")
	assert_match(client_cmd, "5456", "Should include whisper port")
	assert_match(client_cmd, "http://localhost", "Should include HTTP URL")
end)

describe("Engine Manager - Readiness Checks", function()
	local engines = create_mock_engines()
	local em = create_engine_manager(engines)

	-- Test moshi readiness (log-based)
	em:set_engine("moshi")
	local check = em:get_readiness_check()
	assert_not_nil(check, "Should have readiness check")
	assert_equal(check.type, "log_pattern", "Moshi should use log pattern check")
	assert_equal(check.pattern, "ASR loop is now receiving", "Should have correct pattern")
	assert_equal(check.timeout, 10, "Should have timeout")

	-- Test whisper readiness (HTTP-based)
	em:set_engine("whisper")
	check = em:get_readiness_check()
	assert_not_nil(check, "Should have readiness check")
	assert_equal(check.type, "http_check", "Whisper should use HTTP check")
	assert_equal(check.endpoint, "http://localhost:5456/health", "Should have health endpoint")
	assert_equal(check.timeout, 15, "Should have timeout")
end)

describe("Engine Manager - Metadata", function()
	local engines = create_mock_engines()
	local em = create_engine_manager(engines)

	-- Test moshi metadata
	em:set_engine("moshi")
	local meta = em:get_engine_metadata()
	assert_not_nil(meta, "Should have metadata")
	assert_equal(meta.display_name, "Moshi STT", "Should have display name")
	assert_true(meta.requires_gpu, "Moshi should require GPU")
	assert_equal(#meta.supported_languages, 1, "Moshi should support 1 language")

	-- Test whisper metadata
	em:set_engine("whisper")
	meta = em:get_engine_metadata()
	assert_not_nil(meta, "Should have metadata")
	assert_equal(meta.display_name, "OpenAI Whisper", "Should have display name")
	assert_false(meta.requires_gpu, "Whisper should not require GPU")
	assert_equal(#meta.supported_languages, 5, "Whisper should support 5 languages")
end)

describe("Engine Manager - Edge Cases", function()
	local engines = create_mock_engines()
	local em = create_engine_manager(engines)

	-- Test commands with no engine set
	assert_equal(em:get_container_check_cmd(), nil, "Should return nil with no engine")
	assert_equal(em:get_container_start_cmd(), nil, "Should return nil with no engine")
	assert_equal(em:get_client_cmd(), nil, "Should return nil with no engine")
	assert_equal(em:get_readiness_check(), nil, "Should return nil with no engine")

	-- Test empty engine list
	local empty_em = create_engine_manager({})
	local ok, err = empty_em:set_engine("moshi")
	assert_false(ok, "Should fail with empty engine list")

	-- Test engine with missing fields
	local broken_engines = {
		broken = {
			container = { name = "broken" },
			-- Missing client, metadata, etc.
		},
	}
	local broken_em = create_engine_manager(broken_engines)
	broken_em:set_engine("broken")

	-- Should handle missing fields gracefully
	local cmd = broken_em:get_client_cmd()
	assert_not_nil(cmd, "Should return something even with missing fields")
end)

describe("Backward Compatibility", function()
	-- Test that old config style maps to moshi engine
	local function migrate_old_config(old_config)
		if
			old_config.container_dictate_script
			and old_config.container_dictate_script:match("dictate_container_client%.py")
		then
			return "moshi"
		end
		return "moshi" -- Default
	end

	local old_config = {
		container_dictate_script = "/path/to/dictate_container_client.py",
		python_cmd = "/usr/bin/python3",
		use_container = true,
	}

	local engine_name = migrate_old_config(old_config)
	assert_equal(engine_name, "moshi", "Old config should map to moshi engine")

	-- Test that engine manager can be initialized with old config
	local engines = create_mock_engines()
	local em = create_engine_manager(engines)
	local ok = em:set_engine(migrate_old_config(old_config))
	assert_true(ok, "Should initialize with migrated config")
	assert_equal(em:get_container_name(), "moshi-stt", "Should use moshi container")
end)

-- Print summary
print(string.format("\n%s=== Test Summary ===%s", colors.yellow, colors.reset))
print(string.format("Total tests: %d", test_count))
print(string.format("%sPassed: %d%s", colors.green, pass_count, colors.reset))
print(string.format("%sFailed: %d%s", colors.red, fail_count, colors.reset))

if fail_count == 0 then
	print(string.format("\n%s✓ All engine manager tests passed!%s", colors.green, colors.reset))
	os.exit(0)
else
	print(string.format("\n%s✗ Some tests failed%s", colors.red, colors.reset))
	os.exit(1)
end
