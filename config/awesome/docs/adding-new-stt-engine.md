# Adding a New STT Engine to the Dictation System

## Overview

The dictation system uses a modular "Engine Pair" architecture where each STT engine consists of:
- **Container**: The server component running the STT model
- **Client**: A Python script that connects to the container and streams audio

This guide will walk you through adding a new STT engine using OpenAI Whisper as an example.

## System Architecture

```
┌─────────────────────────────────────┐
│         Dictation Widget             │
│     (widgets/dictation.lua)          │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│        Engine Manager                │
│ (widgets/dictation_engine_manager.lua)│
└──────────────┬──────────────────────┘
               │ Reads from
               ▼
┌─────────────────────────────────────┐
│      Engine Definitions              │
│  (widgets/dictation_engines.lua)     │
│  ┌─────────────┬─────────────┐      │
│  │ Moshi       │ Whisper     │      │
│  │ (default)   │ (your new)  │      │
│  └─────────────┴─────────────┘      │
└─────────────────────────────────────┘
```

## Core Files (Required for Production)

### Essential Files
1. **`widgets/dictation.lua`** - Main dictation widget (no changes needed)
2. **`widgets/dictation_engine_manager.lua`** - Engine management logic (no changes needed)
3. **`widgets/dictation_engines.lua`** - Engine definitions (YOU EDIT THIS)
4. **`scripts/dictate_container_client.py`** - Moshi client script
5. **`scripts/your_whisper_client.py`** - Your new client script (YOU CREATE THIS)

### Supporting Files
- **`widgets/microphone.lua`** - Microphone integration
- **`docs/adding-new-stt-engine.md`** - This documentation

### Files NOT Needed (Development/Testing Only)
- `test_*.lua` - Various test scripts
- `phase1_*.md` - Development phase documentation
- `PARALLEL_CHANGE_SWITCH.md` - Migration documentation
- `dictation_test_harness.lua` - Testing infrastructure
- `*.backup-*` - Backup files

## Step-by-Step: Adding Whisper STT

### Step 1: Prepare Your Container

First, ensure you have a Whisper container ready:

```bash
# Example: Build or pull a Whisper container
podman pull ghcr.io/your-org/whisper-stt:latest
# OR build your own
podman build -t localhost/whisper-stt:latest ./whisper-dockerfile/

# Test that it runs
podman run -d --name whisper-stt \
  -p 5456:8000 \
  --device nvidia.com/gpu=all \  # If GPU required
  localhost/whisper-stt:latest

# Verify it's running
podman ps | grep whisper-stt
```

### Step 2: Create Your Client Script

Create a new Python client at `scripts/whisper_client.py`:

```python
#!/usr/bin/env python3
"""
Whisper STT client for dictation widget.
Connects to Whisper container and streams audio.
"""

import asyncio
import argparse
import numpy as np
import sounddevice as sd
import requests
import subprocess
from typing import Optional

class WhisperClient:
    def __init__(self, api_url="http://localhost:5456/v1/audio/transcriptions"):
        self.api_url = api_url
        self.sample_rate = 16000  # Whisper uses 16kHz

    def insert_text(self, text):
        """Insert text at cursor position"""
        subprocess.run(["xdotool", "type", text])

    async def stream_audio(self):
        """Main audio streaming loop"""
        print("🎤 Whisper client started - speak now!")

        # Audio capture setup
        def audio_callback(indata, frames, time, status):
            # Process audio and send to Whisper API
            audio_data = indata.flatten()
            # Convert to appropriate format for Whisper
            response = requests.post(
                self.api_url,
                files={"audio": audio_data.tobytes()},
                data={"response_format": "text"}
            )
            if response.status_code == 200:
                text = response.text
                if text:
                    self.insert_text(text + " ")

        # Start audio stream
        with sd.InputStream(
            samplerate=self.sample_rate,
            channels=1,
            callback=audio_callback
        ):
            await asyncio.Event().wait()  # Run forever

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--api-url", default="http://localhost:5456/v1/audio/transcriptions")
    parser.add_argument("--output", default="auto")
    args = parser.parse_args()

    client = WhisperClient(args.api_url)
    asyncio.run(client.stream_audio())
```

### Step 3: Add Engine Definition

Edit `widgets/dictation_engines.lua` and add your Whisper engine definition:

```lua
-- Add this AFTER the moshi definition, BEFORE the validation function

engines.whisper = {
    -- Container configuration
    container = {
        name = "whisper-stt",
        image = "localhost/whisper-stt:latest",
        port_mapping = "5456:8000",

        -- How to check if container is ready
        readiness_check = {
            method = "http",  -- Use HTTP health check
            endpoint = "http://localhost:5456/health",
            timeout = 15  -- Whisper models can be slow to load
        },

        -- Container lifecycle commands
        commands = {
            check = "podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^whisper-stt'",
            start = "podman start whisper-stt",
            stop = "podman stop --time 0 whisper-stt",
            logs = "podman logs whisper-stt --tail 50"
        }
    },

    -- Client configuration
    client = {
        -- Path to your client script
        script = "/home/freeo/dotfiles/config/awesome/scripts/whisper_client.py",

        -- Arguments to pass
        args = {
            "--api-url", "http://localhost:5456/v1/audio/transcriptions",
            "--output", "auto"
        },

        -- Python environment
        python_required = true,
        python_cmd = "/home/freeo/.local/share/mise/installs/python/3.11.6/bin/python",

        -- Startup delay (Whisper may need more time)
        startup_delay = 1.0
    },

    -- Engine metadata
    metadata = {
        display_name = "OpenAI Whisper",
        description = "Accurate multi-language speech recognition",
        supported_languages = {"en", "es", "fr", "de", "zh", "ja", "ko", "ar"},
        requires_gpu = true,  -- Depends on your model
        protocol = "rest",
        audio_format = {
            sample_rate = 16000,
            channels = 1,
            format = "int16"
        }
    }
}
```

### Step 4: Test Your Engine

```bash
# 1. Verify engine is registered
awesome-client '
  local engines = require("widgets.dictation_engines")
  local list = engines.list()
  print("Available engines: " .. table.concat(list, ", "))
'
# Should show: Available engines: moshi, whisper

# 2. Test engine manager can load it
awesome-client '
  local EM = require("widgets.dictation_engine_manager")
  local em = EM.new()
  local ok, msg = em:set_engine("whisper")
  print("Set whisper: " .. tostring(ok) .. " - " .. msg)
  print("Container: " .. em:get_container_name())
'

# 3. Currently, switching engines requires editing dictation.lua
# Future enhancement: Add runtime switching
```

### Step 5: Switch to Your New Engine (Temporary)

To test your Whisper engine, temporarily modify the engine selection in `widgets/dictation.lua`:

```lua
-- Around line 52, change:
engine_manager:set_engine("moshi")
-- To:
engine_manager:set_engine("whisper")
```

Then reload:
```bash
awesome-client 'package.loaded["widgets.dictation"] = nil; require("widgets.dictation")'
awesome-client 'require("widgets.dictation").Toggle()'
```

## Understanding the Engine Definition

### Container Section

```lua
container = {
    name = "whisper-stt",           -- Container name in podman
    image = "...",                  -- Image to use if creating
    port_mapping = "5456:8000",     -- Host:Container port mapping

    readiness_check = {
        method = "log" or "http",   -- How to check if ready
        pattern = "...",            -- For log method: string to find
        endpoint = "...",           -- For http method: URL to check
        timeout = 15                -- Seconds to wait
    },

    commands = {                    -- Podman commands
        check = "...",              -- Check if container exists
        start = "...",              -- Start container
        stop = "...",               -- Stop container (use --time 0)
        logs = "..."                -- View logs for debugging
    }
}
```

### Client Section

```lua
client = {
    script = "/full/path/to/client.py",    -- Your client script
    args = {...},                           -- Command line arguments
    python_required = true,                 -- Uses Python?
    python_cmd = "/path/to/python",         -- Python interpreter
    startup_delay = 1.0                     -- Seconds to wait before starting
}
```

### Metadata Section

```lua
metadata = {
    display_name = "...",           -- User-friendly name
    description = "...",            -- Brief description
    supported_languages = {...},    -- Language codes
    requires_gpu = true/false,      -- GPU requirement
    protocol = "websocket"/"rest",  -- Connection type
    audio_format = {                -- Audio requirements
        sample_rate = 16000,        -- Hz
        channels = 1,               -- Mono/stereo
        format = "int16"            -- Data format
    }
}
```

## Container Lifecycle Integration

The dictation widget manages your container's lifecycle automatically:

1. **Check**: Uses `commands.check` to see if container exists
2. **Start**: If exited/stopped, runs `commands.start`
3. **Ready**: Waits for readiness using your `readiness_check`
4. **Client**: Launches your client script with specified args
5. **Stop**: When done, stops client then container with `commands.stop`

## Testing Your Integration

### Basic Functionality Test

```bash
# 1. Start your container manually
podman start whisper-stt

# 2. Check it's detected
podman ps | grep whisper-stt

# 3. Test with widget
awesome-client 'require("widgets.dictation").Toggle()'

# 4. Check logs if issues
podman logs whisper-stt --tail 50
tail -f /home/freeo/wb/awm_dict.log  # If debug enabled
```

### Debugging Common Issues

1. **Container not found**: Check `container.name` matches exactly
2. **Client won't start**: Verify Python path and script permissions
3. **No transcription**: Check ports, API endpoints, audio format
4. **Widget wrong color**: Readiness check may be failing

## Best Practices

1. **Container Names**: Use consistent naming: `<engine>-stt`
2. **Ports**: Avoid conflicts, use unique ports per engine
3. **Readiness**: Choose appropriate method (log vs HTTP)
4. **Timeouts**: Be generous for model loading (10-30 seconds)
5. **Stop Time**: Always use `--time 0` for fast stops
6. **Client Scripts**: Keep them simple, handle one protocol
7. **Error Messages**: Log clearly for debugging

## Future Enhancements

Currently, engine switching requires code modification. Future improvements could include:

1. **Runtime Switching**: Add API to switch engines without restart
2. **UI Selection**: Dropdown menu for engine choice
3. **Auto-Detection**: Detect available containers automatically
4. **Parallel Engines**: Run multiple engines simultaneously
5. **Configuration File**: Move engine selection to config file

## Summary

To add a new STT engine:

1. **Prepare container** with your STT service
2. **Write client script** that connects to container
3. **Add engine definition** to `dictation_engines.lua`
4. **Test** using the dictation widget
5. **Switch engines** by modifying the `set_engine()` call

The system handles all lifecycle management - you just provide the container, client, and configuration!

## For Coding Agents: System Peculiarities and Implementation Details

### Critical Design Decisions and Their Rationale

#### 1. The Engine Pair Architecture
**Why**: Different STT systems use incompatible protocols (WebSocket+msgpack vs REST vs gRPC). Attempting to abstract the client layer would create a leaky abstraction.
**Implication**: Each engine MUST have its own client script. Don't try to create a "universal client."

#### 2. Container Name Pattern Matching
**Peculiarity**: The system uses `grep '^container-name'` with escaped hyphens.
```lua
-- The pattern matching is sensitive:
local pattern = container_name:gsub("%-", "%%-")  -- Must escape hyphens
stdout:match(pattern .. "%s+(%S+)")  -- Expects specific format
```
**Gotcha**: Container names with special regex characters need proper escaping.

#### 3. The Parallel Change Switch (Line 40)
**Current State**: `USE_ENGINE_MANAGER = true` but old code remains.
**Why**: Safety during migration. The old hardcoded paths are still present as fallback.
**Warning**: Do NOT remove the old implementation blocks yet - they serve as reference and emergency fallback.

### State Management Quirks

#### 1. Widget Color State Persistence
**Problem**: Colors would reset after xrandr display changes.
**Solution**: The UIManager stores `current_state` and `current_mic_state`, reapplying them in `_update_position()`.
**Pattern**: Always store UI state separately from display state.

#### 2. Container State Detection
**Peculiarity**: States can be "running", "exited", "created", "stopping", "missing".
**Edge Case**: "stopping" state must be handled specially - don't try to start/stop during this state.
```lua
elseif container_state == "stopping" then
    self.callbacks.on_error("Container is stopping - please wait")
    -- Must wait, cannot proceed
```

#### 3. Process Lifecycle Coordination
**Critical**: The system uses multiple timers to handle race conditions:
- `0.2s` delay before starting client (container needs to be fully ready)
- `0.8s` delay in some paths for container initialization
- `1.0s` delay before stopping container (ensures client is dead)

**Never**: Start client immediately after container start - always use delays.

### Hidden Dependencies and Assumptions

#### 1. Python Script Location
**Assumption**: Client scripts are Python and need specific Python interpreter.
**Constraint**: The `python_cmd` must be absolute path to correct Python with all dependencies installed.
```lua
python_cmd = "/home/freeo/.local/share/mise/installs/python/3.11.6/bin/python"
-- This specific Python has: websockets, msgpack, numpy, sounddevice
```

#### 2. Audio Device Access
**Assumption**: The client script can access the default audio input device.
**Potential Issue**: In containerized environments or with PulseAudio/PipeWire, device access may fail.
**Debug**: Check `pactl info` and `arecord -l` if audio capture fails.

#### 3. Text Insertion Tools
**Dependency Chain**: xdotool → X11, ydotool → Wayland, wtype → Wayland, dotool → Universal
**Peculiarity**: The client auto-detects but may fail silently if none available.

### Common Pitfalls and Solutions

#### 1. Container Stop Timing
**Problem**: Default podman stop waits 10 seconds.
**Solution**: Always use `--time 0` for immediate stop.
```lua
stop = "podman stop --time 0 container-name"  -- Critical for responsiveness
```

#### 2. Client Duplicate Prevention
**Problem**: Multiple clients can spawn, causing duplicate text.
**Solution**: System uses `pgrep -f script_name.py` before starting.
**Gotcha**: Script name extraction must handle full paths:
```lua
client_script_pattern = client_cmd:match("([^/]+%.py)")  -- Extract just filename
```

#### 3. Readiness Detection Patterns
**Problem**: Different containers have different "ready" indicators.
**Solution**: Two methods supported but patterns must be exact:
- **Log method**: Pattern must match exactly what container outputs
- **HTTP method**: Endpoint must return 200 OK when ready

### Signal Flow and Event Coordination

#### 1. Microphone Integration
**Signals**: `jack_source_on` / `jack_source_off`
**Peculiarity**: These signals come from external `microphone_toggle.sh` script.
**Coordination**: Widget color changes based on both container state AND microphone state.

#### 2. AwesomeWM Screen Signals
**Monitored**: `property::geometry`, `list`, `primary_changed`
**Timing**: Screen changes trigger position updates with stored state reapplication.
**Edge Case**: 8x8 transition state during display switching must be ignored.

#### 3. Container Logs for Readiness
**Pattern**: The system polls container logs looking for readiness pattern.
**Limit**: Maximum 10 checks with 0.5s intervals = 5 seconds timeout.
**Fallback**: After timeout, attempts connection anyway.

### Testing Strategies for New Engines

#### 1. Isolation Testing
```bash
# Test container alone first
podman run --rm -it your-container
# Verify it starts and responds to API calls

# Test client script standalone
python your_client.py --output console
# Should print transcribed text to console
```

#### 2. Integration Points to Verify
- Container name in `podman ps` output matches exactly
- Readiness pattern appears in logs within timeout
- Client script extracts properly with pattern matching
- Stop command completes within 1 second

#### 3. State Transition Testing
Test these sequences:
- Start → Stop → Start (rapid toggling)
- Start while already starting (duplicate prevention)
- Stop during "stopping" state (should be blocked)
- Display change while running (position update)

### Code Patterns to Maintain

#### 1. Logging Pattern
```lua
self:_log("[ENGINE MANAGER] Message")  -- When using new path
self:_log("[HARDCODED] Message")       -- When using old path
```
Maintain these prefixes for debugging which path is active.

#### 2. Nil Checking Pattern
```lua
local cmd = em:get_container_check_cmd()
if not cmd then
    self:_log("ERROR: No container check command available")
    return
end
```
Always check for nil from engine manager methods.

#### 3. Callback Pattern
```lua
self.callbacks.on_starting()  -- Immediate feedback
-- ... async operation ...
self.callbacks.on_start()      -- When actually ready
```
Always provide immediate feedback, then actual state change.

### Constraints and Limitations

1. **No Runtime Engine Switching**: Currently requires code edit and reload
2. **Single Active Engine**: Cannot run multiple STT engines simultaneously
3. **Container Required**: No support for native processes (must be containerized)
4. **Podman Only**: Docker commands would need adaptation
5. **Fixed Widget Position**: Always bottom center, not configurable
6. **No Queue Management**: Rapid toggles may cause race conditions

### Debug Information Locations

When debugging issues, check these in order:
1. `/home/freeo/wb/awm_dict.log` - Main dictation logs (if debug=true)
2. `podman logs container-name` - Container-side issues
3. `awesome stdout/stderr` - Lua errors and print statements
4. `journalctl --user -u awesome` - SystemD logs if applicable
5. Client script output - Often swallowed, add explicit logging

### Memory and Performance Considerations

1. **Widget Recreation**: The widget is created once and reused (not recreated on toggle)
2. **Signal Handlers**: Screen signals remain connected even when widget hidden
3. **Process Cleanup**: Old processes killed on module reload (see lines 902-918)
4. **Timer Cleanup**: Timers self-terminate with `return false`

### The Most Important Non-Obvious Thing

**The client script is killed by name pattern, not PID**. This means:
- Your client script name must be unique
- Don't name it generically like `client.py` or `stt.py`
- The system uses `pgrep -f` which matches the full command line

This is why the pattern extraction is critical:
```lua
client_script_pattern = client_cmd:match("([^/]+%.py)")
```

If this fails, duplicate clients will spawn, causing chaos.