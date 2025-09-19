#!/usr/bin/env lua
-- Dictation System Unit Tests
-- Compatible with Lua 5.4

-- Test framework setup
local test_count = 0
local pass_count = 0
local fail_count = 0
local current_suite = ""

-- Color codes for output
local colors = {
    green = "\27[32m",
    red = "\27[31m",
    yellow = "\27[33m",
    reset = "\27[0m"
}

-- Test assertion functions
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
    current_suite = suite_name
    print(string.format("\n%s%s%s", colors.yellow, suite_name, colors.reset))
    tests()
end

-- Mock objects for AwesomeWM dependencies
local function create_mocks()
    local mocks = {}

    -- Mock gears
    mocks.gears = {
        timer = {
            start_new = function(timeout, callback)
                -- Immediately call callback for testing
                return { stop = function() end }
            end
        }
    }

    -- Mock awful
    mocks.awful = {
        spawn = {
            easy_async_with_shell = function(cmd, callback)
                -- Mock different commands
                if cmd:match("podman ps") then
                    if cmd:match("moshi%-stt") then
                        -- Simulate container found and running
                        callback("moshi-stt running\n", "", "done", 0)
                    else
                        -- Simulate container not found
                        callback("", "", "done", 1)
                    end
                elseif cmd:match("podman start") then
                    callback("moshi-stt\n", "", "done", 0)
                elseif cmd:match("podman stop") then
                    callback("moshi-stt\n", "", "done", 0)
                else
                    callback("", "", "done", 0)
                end
            end,
            easy_async = function(cmd, callback)
                callback("", "", "done", 0)
            end,
            with_line_callback = function(cmd, callbacks)
                -- Simulate process start
                if callbacks.stdout then
                    callbacks.stdout("Server ready - start speaking!")
                end
                return 12345  -- Mock PID
            end
        },
        screen = {
            focused = function()
                return {
                    geometry = { width = 1920, height = 1080, x = 0, y = 0 },
                    index = 1
                }
            end
        }
    }

    -- Mock wibox
    mocks.wibox = function(args)
        return {
            visible = args.visible or false,
            x = args.x or 0,
            y = args.y or 0,
            width = args.width or 100,
            height = args.height or 40,
            screen = args.screen,
            bg = args.bg,
            setup = function(self, widget) end
        }
    end

    mocks.wibox.widget = {
        textbox = function()
            return { markup = "", text = "" }
        end,
        background = function()
            return { bg = "" }
        end
    }

    mocks.wibox.container = {
        margin = function(widget, l, r, t, b, color)
            return { widget = widget }
        end,
        place = function()
            return {}
        end,
        rotate = function()
            return {}
        end
    }

    mocks.wibox.layout = {
        stack = function()
            return {}
        end
    }

    -- Mock beautiful
    mocks.beautiful = {
        xresources = {
            apply_dpi = function(size) return size end
        }
    }

    -- Mock naughty
    mocks.naughty = {
        notify = function(args)
            -- Just record notification was called
            return { id = 1 }
        end,
        config = {
            presets = {
                normal = {},
                critical = {}
            }
        }
    }

    -- Mock screen signals
    mocks.screen = {
        connect_signal = function(signal, callback) end
    }

    -- Mock client signals
    mocks.client = {
        connect_signal = function(signal, callback) end
    }

    -- Mock microphone module
    mocks.microphone = {
        On = function() end,
        Off = function() end,
        state = { is_on = false }
    }

    return mocks
end

-- Container state parsing tests
describe("Container State Parsing", function()
    local function parse_container_state(stdout)
        local container_state = "missing"
        if stdout and stdout ~= "" then
            if stdout:match("moshi%-stt") then
                local state_match = stdout:match("moshi%-stt%s+(%S+)")
                if state_match then
                    container_state = state_match:lower()
                end
            end
        end
        return container_state
    end

    assert_equal(parse_container_state("moshi-stt running\n"), "running",
        "Should parse running state")
    assert_equal(parse_container_state("moshi-stt exited\n"), "exited",
        "Should parse exited state")
    assert_equal(parse_container_state("moshi-stt created\n"), "created",
        "Should parse created state")
    assert_equal(parse_container_state("moshi-stt stopping\n"), "stopping",
        "Should parse stopping state")
    assert_equal(parse_container_state(""), "missing",
        "Should return missing for empty output")
    assert_equal(parse_container_state("other-container running\n"), "missing",
        "Should return missing for different container")
end)

-- Configuration validation tests
describe("Configuration Validation", function()
    local function validate_config(config)
        local required_fields = {
            "container_dictate_script",
            "python_cmd",
            "use_container",
            "timeout",
            "log_file"
        }

        for _, field in ipairs(required_fields) do
            if config[field] == nil then
                return false, "Missing field: " .. field
            end
        end

        if config.timeout <= 0 then
            return false, "Timeout must be positive"
        end

        return true, "Valid"
    end

    local valid_config = {
        container_dictate_script = "/path/to/script.py",
        python_cmd = "/usr/bin/python",
        use_container = true,
        timeout = 10,
        log_file = "/tmp/test.log"
    }

    local ok, msg = validate_config(valid_config)
    assert_true(ok, "Valid config should pass")

    local invalid_config = {
        python_cmd = "/usr/bin/python",
        use_container = true,
        timeout = 10,
        log_file = "/tmp/test.log"
    }

    ok, msg = validate_config(invalid_config)
    assert_false(ok, "Invalid config should fail")
    assert_match(msg, "Missing field", "Should report missing field")

    valid_config.timeout = -1
    ok, msg = validate_config(valid_config)
    assert_false(ok, "Negative timeout should fail")
end)

-- State machine tests
describe("State Transitions", function()
    local State = {
        IDLE = "idle",
        STARTING = "starting",
        RUNNING = "running",
        STOPPING = "stopping"
    }

    local function create_state_machine()
        local machine = {
            state = State.IDLE,
            transitions = {
                [State.IDLE] = { State.STARTING },
                [State.STARTING] = { State.RUNNING, State.IDLE },
                [State.RUNNING] = { State.STOPPING },
                [State.STOPPING] = { State.IDLE }
            }
        }

        function machine:can_transition(to_state)
            local allowed = self.transitions[self.state]
            if not allowed then return false end

            for _, state in ipairs(allowed) do
                if state == to_state then
                    return true
                end
            end
            return false
        end

        function machine:transition(to_state)
            if self:can_transition(to_state) then
                self.state = to_state
                return true
            end
            return false
        end

        return machine
    end

    local sm = create_state_machine()

    assert_equal(sm.state, State.IDLE, "Should start in IDLE")
    assert_true(sm:transition(State.STARTING), "IDLE -> STARTING should work")
    assert_equal(sm.state, State.STARTING, "Should be in STARTING")
    assert_false(sm:transition(State.STOPPING), "STARTING -> STOPPING should fail")
    assert_true(sm:transition(State.RUNNING), "STARTING -> RUNNING should work")
    assert_true(sm:transition(State.STOPPING), "RUNNING -> STOPPING should work")
    assert_true(sm:transition(State.IDLE), "STOPPING -> IDLE should work")
end)

-- Widget positioning tests
describe("Widget Positioning", function()
    local function calculate_position(screen_width, screen_height, widget_width, widget_height)
        local x = (screen_width / 2) - (widget_width / 2)
        local y = screen_height - widget_height
        return x, y
    end

    local x, y = calculate_position(1920, 1080, 130, 40)
    assert_equal(x, 895, "Should center horizontally on 1920px screen")
    assert_equal(y, 1040, "Should position at bottom on 1080px screen")

    x, y = calculate_position(5120, 1440, 130, 40)
    assert_equal(x, 2495, "Should center horizontally on 5120px screen")
    assert_equal(y, 1400, "Should position at bottom on 1440px screen")

    x, y = calculate_position(1366, 768, 130, 40)
    assert_equal(x, 618, "Should center horizontally on 1366px screen")
    assert_equal(y, 728, "Should position at bottom on 768px screen")
end)

-- Command construction tests
describe("Command Construction", function()
    local function build_container_check_cmd(container_name)
        return string.format(
            "podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^%s'",
            container_name
        )
    end

    local function build_client_cmd(python_path, script_path)
        return string.format("%s %s --output auto", python_path, script_path)
    end

    local cmd = build_container_check_cmd("moshi-stt")
    assert_match(cmd, "podman ps %-a", "Should have podman ps -a")
    assert_match(cmd, "grep '%^moshi%-stt'", "Should grep for container name")

    cmd = build_container_check_cmd("whisper-stt")
    assert_match(cmd, "grep '%^whisper%-stt'", "Should use provided container name")

    cmd = build_client_cmd("/usr/bin/python3", "/path/to/script.py")
    assert_match(cmd, "/usr/bin/python3", "Should use python path")
    assert_match(cmd, "/path/to/script.py", "Should use script path")
    assert_match(cmd, "%-%-output auto", "Should include output flag")
end)

-- Color scheme tests
describe("Color Schemes", function()
    local color_schemes = {
        listening = {
            background = "#4CAF50",
            margin = "#2E7D32",
            text = "#1B5E20"
        },
        ready_muted = {
            background = "#7e5edc",
            margin = "#5E35B1",
            text = "#311B92"
        },
        starting = {
            background = "#FF9800",
            margin = "#F57C00",
            text = "#FFFFFF"
        },
        error = {
            background = "#F44336",
            margin = "#D32F2F",
            text = "#FFFFFF"
        }
    }

    assert_not_nil(color_schemes.listening, "Should have listening scheme")
    assert_equal(color_schemes.listening.background, "#4CAF50", "Listening should be green")
    assert_not_nil(color_schemes.ready_muted, "Should have muted scheme")
    assert_equal(color_schemes.ready_muted.background, "#7e5edc", "Muted should be purple")
    assert_not_nil(color_schemes.starting, "Should have starting scheme")
    assert_equal(color_schemes.starting.background, "#FF9800", "Starting should be orange")
    assert_not_nil(color_schemes.error, "Should have error scheme")
    assert_equal(color_schemes.error.background, "#F44336", "Error should be red")
end)

-- Process management tests
describe("Process Management", function()
    local function mock_process_manager()
        local pm = {
            processes = {},
            next_pid = 1000
        }

        function pm:start_process(cmd)
            local pid = self.next_pid
            self.next_pid = self.next_pid + 1
            self.processes[pid] = { cmd = cmd, running = true }
            return pid
        end

        function pm:stop_process(pid)
            if self.processes[pid] then
                self.processes[pid].running = false
                return true
            end
            return false
        end

        function pm:is_running(pid)
            return self.processes[pid] and self.processes[pid].running
        end

        return pm
    end

    local pm = mock_process_manager()
    local pid = pm:start_process("test command")

    assert_equal(pid, 1000, "Should return PID")
    assert_true(pm:is_running(pid), "Process should be running")
    assert_true(pm:stop_process(pid), "Should stop process")
    assert_false(pm:is_running(pid), "Process should be stopped")
    assert_false(pm:stop_process(9999), "Should fail for invalid PID")
end)

-- Container readiness detection tests
describe("Container Readiness Detection", function()
    local function is_container_ready(log_output, pattern)
        return log_output:match(pattern) ~= nil
    end

    -- Moshi-specific pattern
    local moshi_pattern = "ASR loop is now receiving"
    assert_true(is_container_ready("ASR loop is now receiving websocket data", moshi_pattern),
        "Should detect moshi readiness")
    assert_false(is_container_ready("Starting server...", moshi_pattern),
        "Should not detect readiness prematurely")

    -- Generic patterns
    local whisper_pattern = "Model loaded"
    assert_true(is_container_ready("Model loaded successfully", whisper_pattern),
        "Should detect whisper readiness")

    local generic_pattern = "Ready"
    assert_true(is_container_ready("Server Ready for connections", generic_pattern),
        "Should detect generic readiness")
end)

-- Print test summary
print(string.format("\n%s=== Test Summary ===%s", colors.yellow, colors.reset))
print(string.format("Total tests: %d", test_count))
print(string.format("%sPassed: %d%s", colors.green, pass_count, colors.reset))
print(string.format("%sFailed: %d%s", colors.red, fail_count, colors.reset))

if fail_count == 0 then
    print(string.format("\n%s✓ All tests passed!%s", colors.green, colors.reset))
    os.exit(0)
else
    print(string.format("\n%s✗ Some tests failed%s", colors.red, colors.reset))
    os.exit(1)
end