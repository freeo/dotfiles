# Dictation Widget Display Change Analysis

## Problem Summary

When xrandr changes the display configuration, the dictation widget has two main issues:

1. **Fixed Position**: The widget position is calculated once at creation time (line 688-689 in dictation.lua) and never updated
2. **No Screen Change Handling**: The widget doesn't listen for screen geometry changes or reconnect to the new screen configuration
3. **Color State Loss**: The widget may lose its color state during screen changes

## Current Implementation Issues

### 1. Fixed Position Calculation (dictation.lua:686-691)
```lua
self.container = wibox({
    screen = focused,
    x = (focused.geometry.width / 2) - (width / 2),  -- Fixed at creation time
    y = focused.geometry.height - height,             -- Fixed at creation time
    width = width,
    height = height,
    -- ...
})
```

### 2. No Screen Signal Handlers
The widget doesn't connect to any screen-related signals:
- `screen::list` - when screens are added/removed
- `screen::property::geometry` - when screen resolution changes
- `screen::primary_changed` - when primary screen changes
- `screen::arrange` - when screen layout changes

### 3. Test Results

From the monitoring script output:
```
Widget found: visible=false, x=2495, y=1400, w=130, h=40
Associated with screen 1
Current focused screen: 1 (5120x1440 at 0,0)
```

The widget is positioned at x=2495, y=1400 which is centered at the bottom of a 5120x1440 display.
When the display changes to a different resolution, these coordinates become invalid.

## AwesomeWM Screen Signals (v4.3-git)

Available signals for handling display changes:
- `screen.connect_signal("list", fn)` - Screens added/removed
- `screen.connect_signal("property::geometry", fn)` - Screen geometry changes
- `screen.connect_signal("primary_changed", fn)` - Primary screen changes
- `screen:connect_signal("arrange", fn)` - Screen arrangement changes

## Solutions

### Solution 1: Recreate Widget on Screen Changes (Simple)
- Destroy and recreate the widget when screen configuration changes
- Pros: Simple, guaranteed to work
- Cons: May flash/flicker

### Solution 2: Update Position Dynamically (Better)
- Connect to screen signals and update widget position
- Keep reference to screen and recalculate position
- Pros: Smooth, no flickering
- Cons: More complex

### Solution 3: Use Placement API (Best)
- Use awful.placement for dynamic positioning
- Let AwesomeWM handle position updates
- Pros: Most robust, handles all edge cases
- Cons: Requires refactoring

## Test Commands

1. **Start monitoring:**
```bash
awesome-client 'require("test_xrandr_widget")'
tail -f /home/freeo/wb/xrandr_widget_test.log
```

2. **Toggle dictation to see widget:**
```bash
awesome-client 'require("widgets.dictation").Toggle()'
```

3. **Trigger display change:**
- Use your xrandr keybindings (Mod+Ctrl+7/8/9)
- Or manually: `xrandr --output DP-0 --off`

4. **Check widget state after change:**
```bash
grep "Widget found" /home/freeo/wb/xrandr_widget_test.log | tail -5
```

## Next Steps

1. Implement screen change detection in UIManager
2. Add position update method
3. Connect to appropriate signals
4. Test with various display configurations
5. Handle edge cases (screen removal, resolution changes)