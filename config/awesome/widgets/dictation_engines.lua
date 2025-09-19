-- Dictation Engine Definitions
-- Each engine is a container + client pair that work together
--
-- This file defines all available STT engines without modifying
-- the existing dictation system

local engines = {}

-- Moshi STT Engine (current default)
engines.moshi = {
	-- Container configuration
	container = {
		name = "moshi-stt",
		image = "localhost/moshi-stt:cuda",
		port_mapping = "5455:8080",

		-- How to check if container is ready
		readiness_check = {
			method = "log", -- Check container logs for pattern
			pattern = "ASR loop is now receiving",
			timeout = 10,
		},

		-- Container lifecycle commands
		commands = {
			check = "podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^moshi-stt'",
			start = "podman start moshi-stt",
			stop = "podman stop --time 0 moshi-stt",
			logs = "podman logs moshi-stt --tail 50",
		},
	},

	-- Client configuration
	client = {
		-- Path to the client script
		script = "/home/freeo/dotfiles/config/awesome/scripts/dictate_container_client.py",

		-- Arguments to pass to the client
		args = {
			"--url",
			"ws://localhost:5455/api/asr-streaming",
			"--output",
			"auto",
		},

		-- Python environment
		python_required = true,
		python_cmd = "/home/freeo/.local/share/mise/installs/python/3.11.6/bin/python",

		-- Client startup delay (seconds)
		startup_delay = 0.2,
	},

	-- Engine metadata
	metadata = {
		display_name = "Moshi STT",
		description = "High-performance WebSocket-based STT with GPU acceleration",
		supported_languages = { "en" },
		requires_gpu = true,
		protocol = "websocket",
		audio_format = {
			sample_rate = 24000,
			channels = 1,
			format = "float32",
		},
	},
}

-- Whisper Engine (example for future expansion)
-- Commented out until we have the actual container
--[[
engines.whisper = {
    container = {
        name = "whisper-stt",
        image = "localhost/whisper:latest",
        port_mapping = "5456:8000",

        readiness_check = {
            method = "http",
            endpoint = "http://localhost:5456/health",
            timeout = 15
        },

        commands = {
            check = "podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^whisper-stt'",
            start = "podman start whisper-stt",
            stop = "podman stop --time 0 whisper-stt",
            logs = "podman logs whisper-stt --tail 50"
        }
    },

    client = {
        script = "/home/freeo/dotfiles/config/awesome/scripts/whisper_client.py",
        args = {
            "--api-url", "http://localhost:5456/v1/audio/transcriptions",
            "--output", "auto"
        },
        python_required = true,
        python_cmd = "/home/freeo/.local/share/mise/installs/python/3.11.6/bin/python",
        startup_delay = 0.5
    },

    metadata = {
        display_name = "OpenAI Whisper",
        description = "Accurate multi-language STT model",
        supported_languages = {"en", "es", "fr", "de", "zh", "ja", "ko"},
        requires_gpu = false,
        protocol = "rest",
        audio_format = {
            sample_rate = 16000,
            channels = 1,
            format = "int16"
        }
    }
}
--]]

-- Validation function to ensure engine definitions are complete
function engines.validate(engine)
	if not engine then
		return false, "Engine is nil"
	end
	if not engine.container then
		return false, "Missing container configuration"
	end
	if not engine.container.name then
		return false, "Missing container name"
	end
	if not engine.client then
		return false, "Missing client configuration"
	end
	if not engine.client.script then
		return false, "Missing client script"
	end

	return true, "Valid"
end

-- List available engines
function engines.list()
	local available = {}
	for name, _ in pairs(engines) do
		if type(engines[name]) == "table" then
			table.insert(available, name)
		end
	end
	return available
end

-- Get engine by name
function engines.get(name)
	return engines[name]
end

return engines
