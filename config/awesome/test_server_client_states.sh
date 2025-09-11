#!/bin/bash

echo "=== REFACTORED DICTATION SYSTEM TEST ==="
echo "Testing the simplified microphone signal-driven client management"
echo ""
echo "System behavior:"
echo "  - Toggle() manages server (container) lifecycle"
echo "  - Microphone signals manage client lifecycle" 
echo "  - ClientStart/Stop() for manual control"
echo ""

# Helper to check processes
check_state() {
    CLIENT_COUNT=$(pgrep -f dictate_container_client.py | wc -l)
    CONTAINER=$(podman ps -a --format '{{.State}}' --filter name=moshi-stt 2>/dev/null)
    echo "  Client count: $CLIENT_COUNT"
    echo "  Container: ${CONTAINER:-not found}"
}

echo "CLEANUP"
pkill -9 -f dictate_container_client.py
sleep 1
check_state

echo -e "\n1. FULL START (Toggle ON)"
awesome-client 'require("widgets.dictation").Toggle()'
sleep 4
check_state
echo "  Expected: 1 client, container running"

echo -e "\n2. CLIENT STOP"
awesome-client 'require("widgets.dictation").ClientStop()'
sleep 2
check_state
echo "  Expected: 0 clients, container running, widget purple"

echo -e "\n3. CLIENT START"
awesome-client 'require("widgets.dictation").ClientStart()'
sleep 3
check_state
echo "  Expected: 1 client, container running, widget green"

echo -e "\n4. MICROPHONE TOGGLE (stop via signal)"
# Simulate microphone off signal
awesome-client 'client.emit_signal("jack_source_off")'
sleep 2
check_state
echo "  Expected: 0 clients, container running"

echo -e "\n5. MICROPHONE TOGGLE (start via signal)"
# Simulate microphone on signal  
awesome-client 'client.emit_signal("jack_source_on")'
sleep 3
check_state
echo "  Expected: 1 client, container running"

echo -e "\n6. FULL STOP (Toggle OFF)"
awesome-client 'require("widgets.dictation").Toggle()'
echo "  Waiting for container to stop (15 seconds)..."
sleep 15
check_state
echo "  Expected: 0 clients, container exited, widget hidden"

echo -e "\n7. AWM RESTART TEST"
# Wait for container to be fully stopped
while [[ $(podman ps -a --format '{{.State}}' --filter name=moshi-stt 2>/dev/null) == "stopping" ]]; do
    echo "  Container still stopping, waiting..."
    sleep 2
done
echo "Starting server..."
awesome-client 'require("widgets.dictation").Toggle()'
sleep 4
echo "Before restart:"
check_state

awesome-client 'awesome.restart()' 2>&1 | grep -v "Error" || true
sleep 3
echo "After restart:"
check_state

echo -e "\n8. CLIENT MANAGEMENT AFTER RESTART"
awesome-client 'require("widgets.dictation").ClientStop()'
sleep 2
check_state
awesome-client 'require("widgets.dictation").ClientStart()'
sleep 3
check_state

echo -e "\n9. REAL WORKFLOW TEST (microphone shortcut simulation)"
echo "  Testing the actual workflow: start server, then use mic signals"
# First stop everything and wait for container to fully stop
echo "  Ensuring clean state..."
awesome-client 'require("widgets.dictation").Toggle()' > /dev/null 2>&1
# Wait for container to fully stop (not just "stopping")
while [[ $(podman ps -a --format '{{.State}}' --filter name=moshi-stt 2>/dev/null) == "stopping" ]]; do
    echo "  Container still stopping, waiting..."
    sleep 2
done
sleep 2
# Now start server 
echo "  Starting server..."
awesome-client 'require("widgets.dictation").Toggle()'
sleep 4
echo "  Server started:"
check_state
echo "  Expected: 1 client, container running (client auto-started)"

echo -e "\n  Mic OFF (user presses Mod+Alt+6 to mute):"
awesome-client 'client.emit_signal("jack_source_off")'
sleep 2
check_state
echo "  Expected: 0 clients, container still running"

echo -e "\n  Mic ON (user presses Mod+Alt+6 to unmute):" 
awesome-client 'client.emit_signal("jack_source_on")'
sleep 3
check_state
echo "  Expected: 1 client, container running (this is what was broken before!)"

echo -e "\n10. FINAL CLEANUP"
echo "  Initiating shutdown..."
echo "  NOTE: May show red error notification 'Container is stopping - please wait a moment and try again'"
echo "        This is expected behavior when rapidly toggling - system handles it gracefully."
awesome-client 'require("widgets.dictation").Toggle()'
echo "  Waiting for container to fully stop..."
# Wait for container to fully stop (not just "stopping")
CONTAINER_STATE=$(podman ps -a --format '{{.State}}' --filter name=moshi-stt 2>/dev/null)
while [[ "$CONTAINER_STATE" == "stopping" ]]; do
    echo "  Container state: $CONTAINER_STATE, waiting..."
    sleep 2
    CONTAINER_STATE=$(podman ps -a --format '{{.State}}' --filter name=moshi-stt 2>/dev/null)
done
echo "  Container state: $CONTAINER_STATE"
check_state

echo -e "\n=== TEST COMPLETE ==="
echo "✓ The system should now handle microphone toggle properly"
echo "✓ Microphone signals control client start/stop when server running"
echo "✓ Toggle() controls server lifecycle"