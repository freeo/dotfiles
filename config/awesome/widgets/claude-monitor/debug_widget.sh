#!/bin/bash

echo "=== Claude Widget Debug Script ==="
echo "Time: $(date)"
echo

# Test 1: Check if Python script exists
script_path="/home/freeo/dotfiles/config/awesome/widgets/claude-monitor/claude_kpi_direct.py"
echo "1. Checking if Python script exists:"
if [ -f "$script_path" ]; then
    echo "✓ Script exists: $script_path"
    echo "   Permissions: $(ls -la "$script_path")"
else
    echo "✗ Script NOT found: $script_path"
fi
echo

# Test 2: Test Python execution
echo "2. Testing Python execution:"
echo "Command: python3 '$script_path' --widget"
echo "Output:"
python3 "$script_path" --widget 2>&1
echo "Exit code: $?"
echo

# Test 3: Test with mock script
mock_script="/home/freeo/dotfiles/config/awesome/widgets/claude-monitor/test_mock.py"
echo "3. Testing with mock script:"
if [ -f "$mock_script" ]; then
    echo "Command: python3 '$mock_script' --widget"
    echo "Output:"
    python3 "$mock_script" --widget 2>&1
    echo "Exit code: $?"
else
    echo "✗ Mock script not found: $mock_script"
fi
echo

# Test 4: Test JSON output
echo "4. Testing JSON output:"
echo "Command: python3 '$script_path' --json"
echo "Output:"
python3 "$script_path" --json 2>&1
echo "Exit code: $?"
echo

# Test 5: Check Python and dependencies
echo "5. Python environment check:"
echo "Python version: $(python3 --version 2>&1)"
echo "Python path: $(which python3)"
echo

# Test 6: Check log file
log_file="/tmp/claude_widget_debug.log"
echo "6. Debug log check:"
if [ -f "$log_file" ]; then
    echo "Log file exists: $log_file"
    echo "Recent entries:"
    tail -10 "$log_file" 2>/dev/null || echo "Could not read log file"
else
    echo "No debug log found: $log_file"
fi
echo

echo "=== Debug Complete ==="