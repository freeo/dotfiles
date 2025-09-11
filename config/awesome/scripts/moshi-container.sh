#!/usr/bin/bash

# Moshi STT Container Management Wrapper
# Provides process-like interface for podman container management
# Compatible with AwesomeWM dictation widget expectations

set -euo pipefail

CONTAINER_NAME="moshi-stt"
PIDFILE="/tmp/moshi-container.pid"
LOGFILE="/tmp/moshi-container.log"

# Helper function to get container state
get_container_state() {
    podman ps -a --format "{{.Names}} {{.State}}" 2>/dev/null | grep "^${CONTAINER_NAME} " | awk '{print $2}' || echo "missing"
}

# Helper function to get a pseudo-PID for compatibility
get_pseudo_pid() {
    if [[ -f "$PIDFILE" ]]; then
        cat "$PIDFILE"
    else
        echo ""
    fi
}

# Helper function to set pseudo-PID
set_pseudo_pid() {
    # Use container's main process PID inside the container
    local container_pid
    container_pid=$(podman inspect "$CONTAINER_NAME" --format '{{.State.Pid}}' 2>/dev/null || echo "")
    if [[ -n "$container_pid" && "$container_pid" != "0" ]]; then
        echo "$container_pid" > "$PIDFILE"
        echo "$container_pid"
    else
        # Fallback: use a timestamp-based pseudo PID for compatibility
        local pseudo_pid=$((10000 + $(date +%s) % 50000))
        echo "$pseudo_pid" > "$PIDFILE"
        echo "$pseudo_pid"
    fi
}

# Helper function to clear pseudo-PID
clear_pseudo_pid() {
    rm -f "$PIDFILE"
}

# Helper function to check if container is actually running
is_container_running() {
    local state
    state=$(get_container_state)
    [[ "$state" == "running" ]]
}

# Wait for container to be ready for connections
wait_for_readiness() {
    local max_wait=30
    local count=0
    
    echo "🔄 Waiting for ASR to warm up..."
    
    while [ $count -lt $max_wait ]; do
        # Check if we can see the "starting asr loop" message in logs
        if podman logs --tail 5 "$CONTAINER_NAME" 2>/dev/null | grep -q "starting asr loop"; then
            echo "✅ ASR warmed up and ready"
            return 0
        fi
        
        # Also check if container is still running
        if ! is_container_running; then
            echo "❌ Container stopped during startup" >&2
            return 1
        fi
        
        sleep 1
        count=$((count + 1))
        
        # Show progress dots
        if [ $((count % 5)) -eq 0 ]; then
            echo "⏳ Still warming up... (${count}s)"
        fi
    done
    
    echo "⚠️ Timeout waiting for ASR readiness, but container is running"
    return 0  # Continue anyway - might still work
}

# Start the container and return PID-like identifier
cmd_start() {
    echo "🚀 Starting Moshi STT server with GPU acceleration..."
    
    local state
    state=$(get_container_state)
    
    case "$state" in
        "running")
            echo "✅ Container already running"
            # Still wait for readiness in case it just started
            wait_for_readiness
            get_pseudo_pid
            return 0
            ;;
        "exited"|"created")
            if podman start "$CONTAINER_NAME" >/dev/null 2>&1; then
                echo "✅ STT container started"
                set_pseudo_pid
                
                # Wait for the ASR to be ready before returning
                if wait_for_readiness; then
                    echo "✅ STT server ready on port 5455"
                else
                    echo "⚠️ STT server started but readiness unclear"
                fi
            else
                echo "❌ Failed to start container" >&2
                return 1
            fi
            ;;
        "missing")
            echo "❌ Container not found. Please create it first." >&2
            return 1
            ;;
        *)
            echo "❌ Container in unexpected state: $state" >&2
            return 1
            ;;
    esac
}

# Stop the container
cmd_stop() {
    echo "🛑 Stopping STT server..."
    
    if is_container_running; then
        if podman stop "$CONTAINER_NAME" >/dev/null 2>&1; then
            echo "✅ STT server stopped"
            clear_pseudo_pid
        else
            echo "❌ Failed to stop container" >&2
            return 1
        fi
    else
        echo "✅ Container already stopped"
        clear_pseudo_pid
    fi
}

# Force kill the container
cmd_kill() {
    echo "🛑 Force killing STT server..."
    
    if podman kill "$CONTAINER_NAME" >/dev/null 2>&1; then
        echo "✅ STT server force killed"
    else
        echo "⚠️ Container may not be running"
    fi
    clear_pseudo_pid
}

# Check status (return 0 if running, 1 if not - like kill -0)
cmd_status() {
    if is_container_running; then
        return 0
    else
        return 1
    fi
}

# Show detailed status information
cmd_info() {
    echo "=== Moshi STT Server Status ==="
    local state
    state=$(get_container_state)
    
    case "$state" in
        "running")
            echo "✅ Container: RUNNING"
            echo "📡 API: ws://localhost:5455/api/asr-streaming"
            echo "🆔 Pseudo-PID: $(get_pseudo_pid)"
            echo ""
            echo "=== GPU Usage ==="
            podman exec "$CONTAINER_NAME" nvidia-smi --query-gpu=name,memory.used,memory.total,utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo "❌ Could not query GPU"
            ;;
        "exited"|"created")
            echo "🛑 Container: STOPPED"
            podman ps -a --format "table {{.Names}} {{.Status}}" | grep "^${CONTAINER_NAME}"
            clear_pseudo_pid
            ;;
        "missing")
            echo "❌ Container: NOT CREATED"
            echo "💡 Run container creation command first"
            clear_pseudo_pid
            ;;
        *)
            echo "❓ Container: UNKNOWN STATE ($state)"
            ;;
    esac
}

# Get logs (recent)
cmd_logs() {
    echo "📋 Recent STT server logs:"
    if is_container_running || [[ "$(get_container_state)" == "exited" ]]; then
        podman logs --tail 20 "$CONTAINER_NAME" 2>/dev/null || echo "❌ Could not retrieve logs"
    else
        echo "❌ Container not found or never started"
    fi
}

# Follow live logs (for streaming output compatibility)
cmd_logs_follow() {
    if is_container_running; then
        # This is the key function for awesome widget compatibility
        # It should output server status messages that the widget can parse
        podman logs -f "$CONTAINER_NAME" 2>&1
    else
        echo "❌ Container not running"
        return 1
    fi
}

# Cleanup any stopped/orphaned containers
cmd_cleanup() {
    echo "🧹 Cleaning up STT containers..."
    
    # Stop if running
    if is_container_running; then
        echo "🛑 Stopping running container..."
        podman stop "$CONTAINER_NAME" >/dev/null 2>&1 || true
    fi
    
    # Remove if exists
    if [[ "$(get_container_state)" != "missing" ]]; then
        echo "🗑️ Removing container..."
        podman rm "$CONTAINER_NAME" >/dev/null 2>&1 || true
    fi
    
    clear_pseudo_pid
    echo "✅ Cleanup complete"
}

# Get pseudo-PID for compatibility with widget
cmd_pid() {
    if is_container_running; then
        get_pseudo_pid
    else
        return 1
    fi
}

# Main command dispatch
case "${1:-}" in
    "start")
        cmd_start
        ;;
    "stop")
        cmd_stop
        ;;
    "kill")
        cmd_kill
        ;;
    "status")
        cmd_status
        ;;
    "info")
        cmd_info
        ;;
    "logs")
        cmd_logs
        ;;
    "logs-follow")
        cmd_logs_follow
        ;;
    "cleanup")
        cmd_cleanup
        ;;
    "pid")
        cmd_pid
        ;;
    *)
        echo "Usage: $0 {start|stop|kill|status|info|logs|logs-follow|cleanup|pid}"
        echo ""
        echo "Commands:"
        echo "  start       - Start the STT container"
        echo "  stop        - Gracefully stop the STT container"
        echo "  kill        - Force kill the STT container"
        echo "  status      - Check if container is running (exit code only)"
        echo "  info        - Show detailed status information"
        echo "  logs        - Show recent container logs"
        echo "  logs-follow - Follow container logs (for widget integration)"
        echo "  cleanup     - Remove stopped containers"
        echo "  pid         - Get pseudo-PID for compatibility"
        echo ""
        echo "Widget Integration:"
        echo "  This script provides process-like interface for AwesomeWM dictation widget"
        exit 1
        ;;
esac