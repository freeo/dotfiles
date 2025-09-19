-- Dictation Engine Manager
-- Manages different STT engine pairs (container + client)
-- Provides a unified interface for the dictation system

local EngineManager = {}
EngineManager.__index = EngineManager

-- Constructor
function EngineManager.new()
	local self = setmetatable({}, EngineManager)

	-- Load engine definitions
	local ok, engines = pcall(require, "widgets.dictation_engines")
	if ok then
		self.engines = engines
	else
		-- Fallback if engines file doesn't exist
		print("WARNING: Could not load dictation_engines, using fallback")
		self.engines = EngineManager._create_fallback_engines()
	end

	self.current_engine = nil
	self.current_engine_name = nil

	return self
end

-- Fallback engine definition (matches current hardcoded values)
function EngineManager._create_fallback_engines()
	return {
		moshi = {
			container = {
				name = "moshi-stt",
				commands = {
					check = "podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^moshi-stt'",
					start = "podman start moshi-stt",
					stop = "podman stop --time 0 moshi-stt",
				},
				readiness_check = {
					method = "log",
					pattern = "ASR loop is now receiving",
					timeout = 10,
				},
			},
			client = {
				script = "/home/freeo/dotfiles/config/awesome/scripts/dictate_container_client.py",
				args = { "--output", "auto" },
				python_required = true,
				python_cmd = "/home/freeo/.local/share/mise/installs/python/3.11.6/bin/python",
				startup_delay = 0.2,
			},
		},
	}
end

-- Set the active engine
function EngineManager:set_engine(engine_name)
	if not engine_name then
		return false, "No engine name provided"
	end

	local engine = self.engines[engine_name] or (self.engines.get and self.engines.get(engine_name))

	if not engine then
		return false, "Unknown engine: " .. tostring(engine_name)
	end

	-- Validate engine definition if validation is available
	if self.engines.validate then
		local valid, msg = self.engines.validate(engine)
		if not valid then
			return false, "Invalid engine configuration: " .. msg
		end
	end

	self.current_engine = engine
	self.current_engine_name = engine_name

	return true, "Engine set to: " .. engine_name
end

-- Get current engine name
function EngineManager:get_current_engine_name()
	return self.current_engine_name
end

-- Get container name for current engine
function EngineManager:get_container_name()
	if not self.current_engine then
		return nil
	end
	return self.current_engine.container and self.current_engine.container.name
end

-- Get container check command
function EngineManager:get_container_check_cmd()
	if not self.current_engine then
		return nil
	end

	-- Use pre-defined command if available
	if self.current_engine.container.commands and self.current_engine.container.commands.check then
		return self.current_engine.container.commands.check
	end

	-- Otherwise construct it
	local name = self:get_container_name()
	if not name then
		return nil
	end

	return string.format("podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^%s'", name)
end

-- Get container start command
function EngineManager:get_container_start_cmd()
	if not self.current_engine then
		return nil
	end

	-- Use pre-defined command if available
	if self.current_engine.container.commands and self.current_engine.container.commands.start then
		return self.current_engine.container.commands.start
	end

	-- Otherwise construct it
	local name = self:get_container_name()
	if not name then
		return nil
	end

	return string.format("podman start %s", name)
end

-- Get container stop command
function EngineManager:get_container_stop_cmd()
	if not self.current_engine then
		return nil
	end

	-- Use pre-defined command if available
	if self.current_engine.container.commands and self.current_engine.container.commands.stop then
		return self.current_engine.container.commands.stop
	end

	-- Otherwise construct it
	local name = self:get_container_name()
	if not name then
		return nil
	end

	return string.format("podman stop --time 0 %s", name)
end

-- Get client command
function EngineManager:get_client_cmd()
	if not self.current_engine then
		return nil
	end

	local client = self.current_engine.client
	if not client then
		return nil
	end

	local cmd_parts = {}

	-- Add python if required
	if client.python_required and client.python_cmd then
		table.insert(cmd_parts, client.python_cmd)
	end

	-- Add script path
	if client.script then
		table.insert(cmd_parts, client.script)
	end

	-- Add arguments
	if client.args then
		for _, arg in ipairs(client.args) do
			table.insert(cmd_parts, arg)
		end
	end

	return table.concat(cmd_parts, " ")
end

-- Get readiness check configuration
function EngineManager:get_readiness_check()
	if not self.current_engine then
		return nil
	end

	local check = self.current_engine.container and self.current_engine.container.readiness_check
	if not check then
		return nil
	end

	return {
		type = check.method == "log" and "log_pattern" or check.method == "http" and "http_check" or "unknown",
		pattern = check.pattern,
		endpoint = check.endpoint,
		timeout = check.timeout or 10,
	}
end

-- Get client startup delay
function EngineManager:get_client_startup_delay()
	if not self.current_engine then
		return 0.2
	end -- Default delay

	return self.current_engine.client and self.current_engine.client.startup_delay or 0.2
end

-- Get engine metadata
function EngineManager:get_engine_metadata()
	if not self.current_engine then
		return nil
	end
	return self.current_engine.metadata
end

-- List available engines
function EngineManager:list_engines()
	if self.engines.list then
		return self.engines.list()
	end

	-- Manual listing for fallback
	local list = {}
	for name, engine in pairs(self.engines) do
		if type(engine) == "table" and engine.container then
			table.insert(list, name)
		end
	end
	return list
end

-- Get engine info for display
function EngineManager:get_engine_info(engine_name)
	local engine = self.engines[engine_name] or (self.engines.get and self.engines.get(engine_name))
	if not engine then
		return nil
	end

	local metadata = engine.metadata or {}

	return {
		name = engine_name,
		display_name = metadata.display_name or engine_name,
		description = metadata.description or "STT Engine",
		container_name = engine.container and engine.container.name,
		requires_gpu = metadata.requires_gpu,
		languages = metadata.supported_languages,
		protocol = metadata.protocol,
	}
end

-- Debug: Print current configuration
function EngineManager:debug_print()
	print("EngineManager Debug Info:")
	print("  Current engine: " .. tostring(self.current_engine_name))
	print("  Available engines: " .. table.concat(self:list_engines(), ", "))

	if self.current_engine then
		print("  Container name: " .. tostring(self:get_container_name()))
		print("  Check command: " .. tostring(self:get_container_check_cmd()))
		print("  Client command: " .. tostring(self:get_client_cmd()))

		local check = self:get_readiness_check()
		if check then
			print("  Readiness: " .. check.type .. " (" .. tostring(check.pattern or check.endpoint) .. ")")
		end
	end
end

return EngineManager
