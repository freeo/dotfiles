#!/bin/bash
# Test runner for dictation system
# Ensures tests run with correct Lua version and environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$TEST_DIR")"
LUA_VERSION="5.4"

echo -e "${YELLOW}=== Dictation System Test Suite ===${NC}"
echo "Test directory: $TEST_DIR"
echo "Project root: $PROJECT_ROOT"
echo ""

# Check Lua version
check_lua() {
    if command -v lua$LUA_VERSION &> /dev/null; then
        LUA_CMD="lua$LUA_VERSION"
    elif command -v lua &> /dev/null; then
        LUA_CMD="lua"
        # Verify it's the right version
        version=$(lua -v 2>&1 | grep -oE '[0-9]+\.[0-9]+')
        if [[ "$version" != "$LUA_VERSION" ]]; then
            echo -e "${RED}Error: Lua version mismatch. Expected $LUA_VERSION, got $version${NC}"
            echo "Please install Lua $LUA_VERSION or update the LUA_VERSION variable"
            exit 1
        fi
    else
        echo -e "${RED}Error: Lua not found. Please install Lua $LUA_VERSION${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓${NC} Using Lua: $($LUA_CMD -v)"
}

# Run unit tests
run_unit_tests() {
    echo -e "\n${YELLOW}Running Unit Tests...${NC}"
    local all_passed=true

    # Run main dictation tests
    if [[ -f "$TEST_DIR/dictation_test.lua" ]]; then
        echo -e "\n${YELLOW}[1/2] Core Dictation Tests${NC}"
        $LUA_CMD "$TEST_DIR/dictation_test.lua"
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}✓ Core tests passed${NC}"
        else
            echo -e "${RED}✗ Core tests failed${NC}"
            all_passed=false
        fi
    else
        echo -e "${RED}✗ Core test file not found: $TEST_DIR/dictation_test.lua${NC}"
        all_passed=false
    fi

    # Run engine manager tests
    if [[ -f "$TEST_DIR/engine_manager_test.lua" ]]; then
        echo -e "\n${YELLOW}[2/2] Engine Manager Tests${NC}"
        $LUA_CMD "$TEST_DIR/engine_manager_test.lua"
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}✓ Engine manager tests passed${NC}"
        else
            echo -e "${RED}✗ Engine manager tests failed${NC}"
            all_passed=false
        fi
    else
        echo -e "${YELLOW}⚠ Engine manager tests not found (optional)${NC}"
    fi

    if [[ "$all_passed" == "false" ]]; then
        echo -e "\n${RED}✗ Some unit tests failed${NC}"
        exit 1
    fi
}

# Run integration tests (if they exist)
run_integration_tests() {
    if [[ -f "$TEST_DIR/integration_test.lua" ]]; then
        echo -e "\n${YELLOW}Running Integration Tests...${NC}"
        $LUA_CMD "$TEST_DIR/integration_test.lua"
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}✓ Integration tests passed${NC}"
        else
            echo -e "${RED}✗ Integration tests failed${NC}"
            exit 1
        fi
    else
        echo -e "\n${YELLOW}No integration tests found (optional)${NC}"
    fi
}

# Check container status (optional)
check_containers() {
    echo -e "\n${YELLOW}Checking Container Status...${NC}"

    if command -v podman &> /dev/null; then
        container_status=$(podman ps -a --format "table {{.Names}}\t{{.State}}" | grep -E "stt|dictation" || echo "No STT containers found")
        echo "$container_status"
    else
        echo "Podman not available - skipping container check"
    fi
}

# Main execution
main() {
    check_lua
    run_unit_tests
    run_integration_tests
    check_containers

    echo -e "\n${GREEN}=== All Tests Completed Successfully ===${NC}"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --unit-only)
            check_lua
            run_unit_tests
            exit 0
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --unit-only    Run only unit tests"
            echo "  --help         Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
    shift
done

# Run main if no specific options
main