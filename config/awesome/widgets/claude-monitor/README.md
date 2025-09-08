# Claude Monitor Widget for AwesomeWM

A comprehensive AwesomeWM widget that displays Claude API usage metrics in the wibar and provides a toggle-able TUI overlay for detailed monitoring.

## Features

### 📊 Wibar Display
- **Cost tracking**: Shows current usage cost in USD
- **Reset timer**: Displays time until usage limit reset
- **Auto-refresh**: Updates every 30 seconds
- **Error handling**: Shows "Claude: Offline" when script fails
- **Silent failures**: No crashes or spam notifications

### 🖥️ TUI Overlay
- **Toggle behavior**: Click once to spawn, click again to show/hide
- **Background process**: TUI keeps running when hidden for instant access
- **Fixed dimensions**: 1200x680 pixels, positioned in upper right corner
- **Floating window**: Always on top, properly positioned
- **Multi-monitor support**: Works across different monitor setups

### 🎨 Visual Design
- **Color-coded text**: White for cost, green for reset time, red for errors
- **Clean layout**: Cost | Reset time format in wibar
- **Themed integration**: Uses AwesomeWM beautiful theme colors where appropriate

## Installation

### Prerequisites
- AwesomeWM window manager
- Python 3 with `claude_monitor` module available
- Kitty terminal emulator
- `claude-monitor` command available in PATH

### Setup

1. **Copy widget files** to your AwesomeWM widgets directory:
   ```
   ~/.config/awesome/widgets/claude-monitor/
   ├── claude-monitor.lua          # Main widget
   ├── claude-tui-simple.lua       # TUI overlay handler  
   ├── claude_kpi_direct.py        # Python script for data
   └── test_mock.py                # Mock data for testing
   ```

2. **Add to your AwesomeWM configuration** (e.g., `rc.lua`):
   ```lua
   -- Require the widget
   local claude_monitor = require("widgets.claude-monitor.claude-monitor")
   
   -- Add to wibar widgets
   claude_monitor(),
   ```

3. **Reload AwesomeWM** with `Mod4+Shift+R`

## Usage

### Wibar Widget
The widget appears in your wibar showing:
```
$4.23 | Reset: 2h 30m
```

### Mouse Interactions
- **Left Click**: Toggle TUI overlay (spawn → show → hide → show...)
- **Right Click**: Manually refresh wibar data

### TUI Overlay
- First left-click spawns the claude-monitor TUI in a 1200x680 window
- Subsequent clicks toggle visibility without respawning
- TUI maintains its state when hidden
- Positioned in upper right corner with 20px margins

## Configuration

### Widget Options
```lua
claude_monitor({
    timeout = 30,          -- Refresh interval in seconds
    use_mock = false,      -- Use mock data instead of real script
    widget_path = "path",  -- Custom path to Python script
    color_cost = "#ffffff", -- Cost text color
    color_reset = "#00ff00", -- Reset time color  
    color_error = "#ff4444"  -- Error text color
})
```

### TUI Dimensions
Edit `claude-tui-simple.lua` to adjust window size:
```lua
c:geometry({
    x = workarea.x + workarea.width - 1200 - 20, -- Width: 1200px
    y = workarea.y + 20,                         -- Height: 680px
    width = 1200,
    height = 680
})
```

## Debugging

### Enable Debug Mode
Set `DEBUG = true` in `claude-monitor.lua` to enable:
- Console logging to `/tmp/claude_widget_debug.log`
- Debug notifications (when enabled)

### Manual Testing
Test TUI functionality without adding to wibar:
```bash
echo 'require("widgets.claude-monitor.claude-tui-simple").toggle()' | awesome-client
```

### Mock Data
Use mock data for testing:
```lua
claude_monitor({use_mock = true})
```

## Files Structure

```
claude-monitor/
├── README.md                    # This documentation
├── claude-monitor.lua           # Main wibar widget
├── claude-tui-simple.lua        # TUI overlay management
├── claude_kpi_direct.py         # Real data script
├── test_mock.py                 # Mock data script
└── test files/                  # Various test scripts
    ├── test_simple_tui.lua
    ├── test_signal_tui.lua
    └── debug_widget.sh
```

## Error Handling

### Common Issues
- **"Claude: Offline"**: Python script failed, check dependencies
- **Widget not appearing**: Check AwesomeWM config syntax with `awesome -k`
- **TUI not spawning**: Ensure `claude-monitor` command exists
- **Crashes**: Check `/tmp/claude_widget_debug.log` with debug enabled

### Safe Failure Mode
The widget is designed to fail gracefully:
- No AwesomeWM crashes from widget errors
- Silent failure with error display in widget
- Automatic fallback to mock data when configured

## Technical Details

### Data Flow
1. `awful.widget.watch` calls Python script every 30 seconds
2. Script output parsed: `"$X.XX | Reset: Xh Xm"`
3. Widget text updated with color coding
4. On failure, timer stops to prevent spam

### TUI Integration  
- Uses client signal handling (`client.connect_signal("manage")`)
- No `awful.rules` manipulation (prevents crashes)
- Window properties set directly on client
- Background process management for quick show/hide

### Multi-Monitor Support
- Fixed pixel dimensions work across all monitors
- Upper right positioning relative to focused screen
- DPI-independent sizing

## License

Part of freeo's AwesomeWM configuration. Use and modify as needed.