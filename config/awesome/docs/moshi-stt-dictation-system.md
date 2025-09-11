# Moshi-STT Dictation System Documentation

## Overview

The Moshi-STT Dictation System is a containerized speech-to-text solution integrated with AwesomeWM. It provides real-time voice dictation that directly types text at your cursor position, completely independent of the original nerd-dictation project.

**Latest Updates:**
- Enhanced state management with proper "stopping" visual feedback
- Container lifecycle monitoring ensures widget only disappears when container fully stops
- Fixed duplicate notification issues
- Improved timing for immediate visual feedback on start/stop actions

## Architecture Components

### 1. Container: `moshi-stt`
- **Image**: `localhost/moshi-stt:cuda`
- **Port Mapping**: Container port 8080 → Host port 5455
- **Service**: Runs the Kyutai Moshi server for speech recognition
- **Management**: Controlled via podman commands
- **State Management**: Can be in states: created, running, stopping, exited

### 2. AwesomeWM Widget: `dictation.lua`
Located at: `/home/freeo/dotfiles/config/awesome/widgets/dictation.lua`

**Key Features:**
- Pure Lua + podman integration (no shell wrapper scripts)
- Container lifecycle management with state monitoring
- Visual HUD display with immediate state feedback
- Microphone integration with signal coordination
- State-aware error handling with duplicate prevention
- Proper start/stop timing with container readiness detection

**Core Components:**
- `DictationController`: Manages container and client process lifecycle with state monitoring
- `UIManager`: Handles the visual widget display with 5 distinct states
- Container detection and startup logic with proper state handling
- Client process management with duplicate prevention
- Container lifecycle monitoring for accurate widget state

### 3. Container Client: `dictate_container_client.py`
Located at: `/home/freeo/dotfiles/config/awesome/scripts/dictate_container_client.py`

**This is a completely new, standalone script** - NOT part of nerd-dictation!

**Key Features:**
- WebSocket connection to container at `ws://localhost:5455/api/asr-streaming`
- Audio capture using sounddevice library
- Real-time text output to cursor using xdotool/ydotool/wtype/dotool
- Message protocol using msgpack
- No server management - purely a client

## How It Works

### 1. Activation Flow

```
User presses keybinding (Prior/PageUp)
    ↓
dictation.Toggle() called
    ↓
DictationController:start()
    ↓
🟠 Orange "starting..." widget appears IMMEDIATELY
    ↓
Container detection via podman ps -a
    ↓
Container state check
    ├─ If "exited/created/stopping": Start container
    ├─ If "running": Use existing
    └─ If "missing": Show error
    ↓
Wait for container readiness (ASR loop detection)
    ↓
Launch Python client script
    ↓
Client connects to WebSocket
    ↓
🟢 Green "dictate" widget when "Server ready" detected
    ↓
Speech → Text → Cursor
```

### 1b. Deactivation Flow

```
User presses keybinding (Prior/PageUp) again
    ↓
dictation.Toggle() called
    ↓
DictationController:stop()
    ↓
🟠 Deep orange "stopping..." widget appears IMMEDIATELY
    ↓
Client process terminated
    ↓
Container stop command issued
    ↓
Monitor container state until "exited"
    ↓
Widget disappears when container fully stopped
```

### 2. Container Detection

The system uses `awful.spawn.easy_async_with_shell()` to run:
```bash
podman ps -a --format '{{.Names}} {{.State}}' 2>/dev/null | grep '^moshi-stt'
```

This detects if the container exists and its current state.

### 3. Client-Server Communication

**WebSocket Protocol:**
- Client sends: Audio chunks as msgpack-encoded messages
- Server sends: 
  - `Ready` messages (server ready)
  - `Word` messages (transcribed words)
  - `Step` messages (VAD/pause detection)
  - `EndWord` messages (word boundaries)

**Audio Format:**
- Sample rate: 24000 Hz
- Channels: 1 (mono)
- Block size: 1920 samples (80ms)
- Format: float32

### 4. Text Output

The client immediately inserts transcribed words at the cursor position using:
- **xdotool** (X11 - most common)
- **ydotool** (Wayland)
- **wtype** (Wayland alternative)
- **dotool** (Universal)

## Visual Status Indicators

The widget displays different colors based on state:

| State | Color | Description |
|-------|-------|-------------|
| Starting | Orange (#FF9800) | Container is starting up |
| Stopping | Deep Orange (#FF5722) | Container is stopping |
| Ready (Muted) | Purple (#7e5edc) | Container ready, microphone muted |
| Listening | Green (#4CAF50) | Actively transcribing speech |
| Inactive | Light Purple (#9D6DCA) | System not running |
| Error | Red (#F44336) | Error occurred |

**State Timing:**
- Orange appears **immediately** when PageUp is pressed (start)
- Deep orange appears **immediately** when PageUp is pressed (stop)  
- Green appears when client connects and receives "Server ready"
- Widget disappears only when container reaches "exited" state

## Configuration

In `dictation.lua`:
```lua
local config = {
    container_dictate_script = "/home/freeo/dotfiles/config/awesome/scripts/dictate_container_client.py",
    python_cmd = "/home/freeo/.local/share/mise/installs/python/3.11.6/bin/python",
    use_container = true,
    debug = false,
    log_file = "/home/freeo/wb/awm_dict.log"
}
```

## Relationship to Nerd-Dictation

**This system is COMPLETELY INDEPENDENT of nerd-dictation!**

- No nerd-dictation code is used
- No nerd-dictation server management
- No nerd-dictation voice activity detection
- The only similarity is the concept of voice-to-text-at-cursor

The original `just_dictate.py` script from nerd-dict-fork is NOT USED when `use_container = true`.

## Container Management Commands

```bash
# Start container
podman start moshi-stt

# Stop container  
podman stop moshi-stt

# Check status
podman ps -a | grep moshi-stt

# View logs
podman logs moshi-stt

# Create container (if needed)
podman run -d --name moshi-stt \
  -p 5455:8080 \
  --device nvidia.com/gpu=all \
  localhost/moshi-stt:cuda
```

## Python Dependencies

Required for the client script:
- websockets
- msgpack  
- numpy
- sounddevice

Install via:
```bash
pip install websockets msgpack numpy sounddevice
```

## Debugging

Enable debug mode in `dictation.lua`:
```lua
debug = true
```

Check logs:
```bash
tail -f /home/freeo/wb/awm_dict.log
```

Test client directly:
```bash
python /home/freeo/dotfiles/config/awesome/scripts/dictate_container_client.py --output console
```

## Key Differences from Original Design

1. **No Server Management**: Container handles the server
2. **Simplified Client**: Just connects and streams
3. **Direct WebSocket**: No intermediate protocols
4. **Container-based**: Isolated, GPU-accelerated environment
5. **Pure Lua Control**: No bash wrapper scripts needed

## Success Indicators

When working correctly, you'll see:
1. Orange widget appears (starting)
2. Container starts within 2-3 seconds
3. Widget turns green (listening) or purple (muted)
4. Speech is transcribed in real-time
5. Text appears at cursor position immediately
6. Widget disappears when toggled off

This is a clean, container-based STT solution that leverages the power of the Moshi server in an isolated environment while providing seamless integration with your desktop environment.