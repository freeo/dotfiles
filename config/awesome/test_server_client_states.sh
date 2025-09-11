#!/bin/bash

echo "=== SERVER/CLIENT STATE TEST ==="
echo "Testing widget, server, and client coordination"
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

echo -e "\n4. CLIENT TOGGLE (stop)"
awesome-client 'require("widgets.dictation").ToggleClient()'
sleep 2
check_state
echo "  Expected: 0 clients, container running"

echo -e "\n5. CLIENT TOGGLE (start)"
awesome-client 'require("widgets.dictation").ToggleClient()'
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

echo -e "\n9. FINAL CLEANUP"
awesome-client 'require("widgets.dictation").Toggle()'
echo "  Waiting for shutdown..."
sleep 15
check_state

echo -e "\n=== TEST COMPLETE ==="