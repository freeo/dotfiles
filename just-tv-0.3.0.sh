#!/usr/bin/env bash

# just-tv v0.3.0-dev - Interactive recipe selector with file completion
#
# Features:
# - TV interface for recipe selection
# - fzf-powered file completion for parameters
# - Bat syntax highlighting for recipe bodies
# - Module support with auto-detection
# - Local project history (.just_history)
# - Shell history integration
# - Enhanced parameter display
# - Shebang detection and language highlighting

VERSION="0.3.0-dev"

# ============================================================================
# HISTORY FUNCTIONS (Integrated)
# ============================================================================

# Configuration for local history
readonly HISTORY_FILE=".just_history"
readonly MAX_HISTORY_SIZE=1000

# Function to write command to local .just_history file
write_just_history() {
    local cmd="$1"
    local exit_code="${2:-0}"
    local history_file="${PWD}/${HISTORY_FILE}"

    # Create history file if it doesn't exist
    if [[ ! -f "$history_file" ]]; then
        {
            echo "# Just command history for $(basename "$PWD")"
            echo "# Format: timestamp [exit_code] command"
            echo ""
        } > "$history_file"
    fi

    # Write the command with metadata (exit code [0] means success, others mean failure)
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$exit_code] $cmd" >> "$history_file"

    # Rotate if file gets too large
    local line_count=$(wc -l < "$history_file")
    if [[ $line_count -gt $MAX_HISTORY_SIZE ]]; then
        local temp_file="${history_file}.tmp"
        {
            head -n 3 "$history_file"  # Keep header
            tail -n $((MAX_HISTORY_SIZE - 3)) "$history_file"
        } > "$temp_file"
        mv "$temp_file" "$history_file"
    fi
}

# Function to add command to shell history
add_to_shell_history() {
    local cmd="$1"

    # Add to shell history based on shell type
    if [[ -n "$BASH_VERSION" ]]; then
        history -s "$cmd" 2>/dev/null || true
    elif [[ -n "$ZSH_VERSION" ]]; then
        print -s "$cmd" 2>/dev/null || true
        fc -R 2>/dev/null || true
    fi
}

# ============================================================================
# COLOR CONFIGURATION
# ============================================================================

# Core recipe colors
RECIPE_COLOR='\033[0;36m'         # Cyan - recipe names
PARAM_NAME_COLOR='\033[1;33m'     # Yellow - parameter names (with defaults)
REQUIRED_PARAM_COLOR='\033[0;91m' # Light Red - required parameters (no defaults)
DEFAULT_VALUE_COLOR='\033[0;32m'  # Green - default values
DEPENDENCY_COLOR='\033[0;95m'     # Bright Magenta - dependencies

# Module colors (only used when modules detected)
MODULE_HEADER_COLOR='\033[1;37m'  # Bold White - module headers
MODULE_DOCKER_COLOR='\033[0;94m'  # Blue - docker module
MODULE_TEST_COLOR='\033[0;92m'    # Light Green - test module
MODULE_DEPLOY_COLOR='\033[0;93m'  # Yellow - deploy module
MODULE_DEFAULT_COLOR='\033[0;96m' # Light Cyan - other modules

# Module icons (only when modules detected)
if [[ "$NO_ICONS" != "1" ]]; then
    ICON_CORE='🔷'
    ICON_DOCKER='🐳'
    ICON_TEST='🧪'
    ICON_DEPLOY='🚀'
    ICON_MODULE='📦'
else
    ICON_CORE='[core]'
    ICON_DOCKER='[docker]'
    ICON_TEST='[test]'
    ICON_DEPLOY='[deploy]'
    ICON_MODULE='[mod]'
fi

# Preview colors
PREVIEW_TITLE='\033[1;32m'   # Bold Green - Recipe title
DOC_COLOR='\033[0;35m'       # Magenta - doc comments/attributes
ATTR_COLOR='\033[0;94m'      # Light Blue - [doc] attributes
SIGNATURE_COLOR='\033[0;36m' # Cyan - recipe signature
DIM='\033[2m'                # Dim - separators
BOLD='\033[1m'
NC='\033[0m' # No Color

# ============================================================================
# ARGUMENT PARSING
# ============================================================================

JFILE=""
MODULE_FILTER=""
NO_MODULES=false
SHOW_VERSION=false
NO_HISTORY=false

for arg in "$@"; do
    if [[ "$arg" == "--version" ]] || [[ "$arg" == "-v" ]]; then
        SHOW_VERSION=true
    elif [[ "$arg" == "--module" ]] || [[ "$arg" == "-m" ]]; then
        NEXT_IS_MODULE=true
    elif [[ "$NEXT_IS_MODULE" == true ]]; then
        MODULE_FILTER="$arg"
        NEXT_IS_MODULE=false
    elif [[ "$arg" == "--no-modules" ]]; then
        NO_MODULES=true
    elif [[ "$arg" == "--no-history" ]]; then
        NO_HISTORY=true
    elif [[ "$arg" == "--help" ]] || [[ "$arg" == "-h" ]]; then
        echo "just-tv v${VERSION} - Interactive recipe selector for just"
        echo ""
        echo "Usage: $0 [justfile] [options]"
        echo ""
        echo "Options:"
        echo "  --module, -m MODULE  Show only specified module"
        echo "  --no-modules        Disable module detection"
        echo "  --no-history        Don't write to .just_history"
        echo "  --version, -v       Show version"
        echo "  --help, -h          Show this help"
        echo ""
        echo "Environment:"
        echo "  NO_ICONS=1          Use text labels instead of emoji icons"
        echo ""
        echo "Features:"
        echo "  File completion     Interactive file selection with TV (dot+TAB)"
        echo "  Parameter prompts   Enhanced prompts with path completion"
        echo ""
        echo "Files:"
        echo "  .just_history       Local project command history"
        echo "  .just-tv-last-command  Temp file for shell history integration"
        exit 0
    elif [[ ! "$arg" =~ ^- ]]; then
        JFILE="$arg"
    fi
done

if [[ "$SHOW_VERSION" == true ]]; then
    echo "just-tv v${VERSION}"
    exit 0
fi

# Default to justfile if not specified
JFILE=${JFILE:-"justfile"}

# Check if justfile exists
if [[ ! -f "$JFILE" ]]; then
	echo "Error: Justfile '$JFILE' not found"
	exit 1
fi

# TV is required for the main interface and file completion
if ! command -v tv >/dev/null 2>&1; then
	echo -e "\033[0;31mError: tv (television) not found.\033[0m" >&2
	echo "Install television for the interface: https://github.com/alexpasmantier/television" >&2
	exit 1
fi

# ============================================================================
# MODULE DETECTION
# ============================================================================

HAS_MODULES=false
if [[ "$NO_MODULES" != "true" ]]; then
    HAS_MODULES=$(just --list --list-heading="" --justfile "$JFILE" 2>/dev/null | grep -Eq '^\s*\w+\s+\.\.\.' && echo "true" || echo "false")
fi

# ============================================================================
# TEMP FILE SETUP
# ============================================================================

SELECTION_FILE=$(mktemp /tmp/tv-selection.XXXXXX)
FORMAT_SCRIPT=""
PREVIEW_SCRIPT=""

cleanup() {
	rm -f "$SELECTION_FILE" "$FORMAT_SCRIPT" "$PREVIEW_SCRIPT"
}
trap cleanup EXIT

# ============================================================================
# FORMAT SCRIPT CREATION
# ============================================================================

FORMAT_SCRIPT=$(mktemp /tmp/format.XXXXXX.sh)

if [[ "$HAS_MODULES" == "true" ]]; then
    # Modular formatting
    cat >"$FORMAT_SCRIPT" <<FORMATEOF
#!/usr/bin/env bash
JFILE="\$1"
MODULE_FILTER="\$2"
NO_ICONS="$NO_ICONS"

# Function to get module color
get_module_color() {
    local module="\$1"
    case "\$module" in
        docker) echo '\033[0;94m' ;;
        test|testing) echo '\033[0;92m' ;;
        deploy|deployment) echo '\033[0;93m' ;;
        *) echo '\033[0;96m' ;;
    esac
}

# Function to get module icon
get_module_icon() {
    local module="\$1"
    if [[ "\$NO_ICONS" == "1" ]]; then
        case "\$module" in
            docker) echo '[docker]' ;;
            test|testing) echo '[test]' ;;
            deploy|deployment) echo '[deploy]' ;;
            "") echo '[core]' ;;
            *) echo '[mod]' ;;
        esac
    else
        case "\$module" in
            docker) echo '🐳' ;;
            test|testing) echo '🧪' ;;
            deploy|deployment) echo '🚀' ;;
            "") echo '🔷' ;;
            *) echo '📦' ;;
        esac
    fi
}

# Function to format parameters
format_params() {
    local recipe="\$1"
    local recipe_name="\$2"
    local signature=\$(just --justfile "\$JFILE" --show "\$recipe" 2>/dev/null | grep "^\${recipe_name}" | head -1)
    local after_recipe=\$(echo "\$signature" | sed -n "s/^\${recipe_name}[[:space:]]*\\(.*\\):/\\1/p")

    if [[ -n "\$after_recipe" ]]; then
        local formatted_params=""
        local first=true

        for item in \$after_recipe; do
            [[ "\$first" == "true" ]] && first=false || formatted_params+=" "

            if [[ "\$item" =~ ^([^=]+)=(.*)$ ]]; then
                param_name="\${BASH_REMATCH[1]}"
                default_val="\${BASH_REMATCH[2]}"
                default_val=\$(echo "\$default_val" | sed "s/[\\"']//g")
                formatted_params+=\$(printf "\\033[1;33m%s\\033[0m:\\033[0;32m%s\\033[0m" "\${param_name}" "\${default_val}")
            elif [[ "\$item" =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]]; then
                if just --list --justfile "\$JFILE" 2>/dev/null | grep -q "^    \$item "; then
                    formatted_params+=\$(printf "\\033[0;95m%s\\033[0m" "\${item}")
                else
                    formatted_params+=\$(printf "\\033[0;91m%s\\033[0m" "\${item}")
                fi
            fi
        done
        echo "\$formatted_params"
    fi
}

SPACING="  "

# Get modules - handle both indented and non-indented module lines
modules=\$(just --list --list-heading="" --justfile "\$JFILE" 2>/dev/null | grep -E '^\\s*\\w+\\s+\\.\\.\\.' | awk '{print \$1}' | sed 's/\\.\\.\\.//')

# Process based on module filter
if [[ -n "\$MODULE_FILTER" ]]; then
    module_path=\$(grep "^mod \$MODULE_FILTER " "\$JFILE" | sed 's/^mod [^ ]* "\\(.*\\)"/\\1/')
    if [[ -f "\$module_path" ]]; then
        grep -E '^[a-zA-Z_][a-zA-Z0-9_-]*.*:' "\$module_path" | while read -r line; do
            recipe=\$(echo "\$line" | sed 's/:.*//' | awk '{print \$1}')
            full_recipe="\${MODULE_FILTER}::\${recipe}"
            if just --justfile "\$JFILE" --show "\$full_recipe" >/dev/null 2>&1; then
                icon=\$(get_module_icon "\$MODULE_FILTER")
                color=\$(get_module_color "\$MODULE_FILTER")
                params=\$(format_params "\$full_recipe" "\$recipe")
                if [[ -n "\$params" ]]; then
                    printf "%s %b%s::\\033[0;36m%s\\033[0m%s%s\\n" "\$icon" "\$color" "\$MODULE_FILTER" "\$recipe" "\$SPACING" "\$params"
                else
                    printf "%s %b%s::\\033[0;36m%s\\033[0m\\n" "\$icon" "\$color" "\$MODULE_FILTER" "\$recipe"
                fi
            fi
        done
    fi
else
    # Show core recipes
    just --list --list-heading="" --justfile "\$JFILE" 2>/dev/null | while IFS= read -r line; do
        # Skip module lines (they contain "...")
        if [[ "\$line" =~ \\.\\.\\.  ]]; then
            continue
        fi
        recipe=\$(echo "\$line" | awk '{print \$1}')
        params=\$(format_params "\$recipe" "\$recipe")
        if [[ -n "\$params" ]]; then
            printf "🔷 \\033[0;36m%s\\033[0m%s%s\\n" "\$recipe" "\$SPACING" "\$params"
        else
            printf "🔷 \\033[0;36m%s\\033[0m\\n" "\$recipe"
        fi
    done

    # Show modules
    for module in \$modules; do
        module_path=\$(grep "^mod \$module " "\$JFILE" | sed 's/^mod [^ ]* "\\(.*\\)"/\\1/')
        if [[ -f "\$module_path" ]]; then
            icon=\$(get_module_icon "\$module")
            color=\$(get_module_color "\$module")
            grep -E '^[a-zA-Z_][a-zA-Z0-9_-]*.*:' "\$module_path" | while read -r line; do
                recipe=\$(echo "\$line" | sed 's/:.*//' | awk '{print \$1}')
                full_recipe="\${module}::\${recipe}"
                if just --justfile "\$JFILE" --show "\$full_recipe" >/dev/null 2>&1; then
                    params=\$(format_params "\$full_recipe" "\$recipe")
                    if [[ -n "\$params" ]]; then
                        printf "%s %b%s::\\033[0;36m%s\\033[0m%s%s\\n" "\$icon" "\$color" "\$module" "\$recipe" "\$SPACING" "\$params"
                    else
                        printf "%s %b%s::\\033[0;36m%s\\033[0m\\n" "\$icon" "\$color" "\$module" "\$recipe"
                    fi
                fi
            done
        fi
    done
fi
FORMATEOF
else
    # Non-modular formatting (classic mode)
    cat >"$FORMAT_SCRIPT" <<FORMATEOF
#!/usr/bin/env bash
JFILE="\$1"

# Icons
NO_ICONS="$NO_ICONS"
if [[ "\$NO_ICONS" == "1" ]]; then
    ICON='[recipe]'
else
    ICON='▶'
fi

# Colors
RECIPE_COLOR='$RECIPE_COLOR'
PARAM_NAME_COLOR='$PARAM_NAME_COLOR'
REQUIRED_PARAM_COLOR='$REQUIRED_PARAM_COLOR'
DEFAULT_VALUE_COLOR='$DEFAULT_VALUE_COLOR'
DEPENDENCY_COLOR='$DEPENDENCY_COLOR'
NC='$NC'

SPACING="  "

just --list --list-heading="" --justfile "\$JFILE" 2>/dev/null | \\
    while IFS= read -r line; do
        recipe=\$(echo "\$line" | awk '{print \$1}')
        signature=\$(just --justfile "\$JFILE" --show "\$recipe" 2>/dev/null | \\
                    grep "^\${recipe}" | head -1)
        after_recipe=\$(echo "\$signature" | sed -n "s/^\${recipe}[[:space:]]*\\(.*\\):/\\1/p")

        if [[ -n "\$after_recipe" ]]; then
            formatted_params=""
            first=true

            for item in \$after_recipe; do
                [[ "\$first" == "true" ]] && first=false || formatted_params+=" "

                if [[ "\$item" =~ ^([^=]+)=(.*)$ ]]; then
                    param_name="\${BASH_REMATCH[1]}"
                    default_val="\${BASH_REMATCH[2]}"
                    default_val=\$(echo "\$default_val" | sed "s/[\"']//g")
                    formatted_params+=\$(printf "%b%s%b:%b%s%b" "\${PARAM_NAME_COLOR}" "\${param_name}" "\${NC}" "\${DEFAULT_VALUE_COLOR}" "\${default_val}" "\${NC}")
                elif [[ "\$item" =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]]; then
                    if just --list --justfile "\$JFILE" 2>/dev/null | grep -q "^    \$item "; then
                        formatted_params+=\$(printf "%b%s%b" "\${DEPENDENCY_COLOR}" "\${item}" "\${NC}")
                    else
                        formatted_params+=\$(printf "%b%s%b" "\${REQUIRED_PARAM_COLOR}" "\${item}" "\${NC}")
                    fi
                fi
            done

            printf "%s %b%s%b%s%s\\n" "\$ICON" "\${RECIPE_COLOR}" "\$recipe" "\${NC}" "\${SPACING}" "\$formatted_params"
        else
            printf "%s %b%s%b\\n" "\$ICON" "\${RECIPE_COLOR}" "\$recipe" "\${NC}"
        fi
    done
FORMATEOF
fi
chmod +x "$FORMAT_SCRIPT"

# ============================================================================
# PREVIEW SCRIPT CREATION
# ============================================================================

PREVIEW_SCRIPT=$(mktemp /tmp/preview.XXXXXX.sh)
cat >"$PREVIEW_SCRIPT" <<PREVIEWEOF
#!/usr/bin/env bash
FULL_LINE="\$1"
JFILE="\$2"

# Early exit if no input
if [[ -z "\$FULL_LINE" ]]; then
    echo "Welcome to just-tv"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Navigate to a recipe to see its details"
    exit 0
fi

# Strip ANSI colors first
NO_COLORS=\$(echo "\$FULL_LINE" | sed 's/\\x1b\\[[0-9;]*m//g')

# Check if there's an icon to strip (emoji, arrow, or [text] format)
if [[ "\$NO_COLORS" =~ ^[🔷🐳🧪🚀📦▶] ]] || [[ "\$NO_COLORS" =~ ^\[[a-z]+\] ]]; then
    # Strip the icon
    CLEAN_LINE=\$(echo "\$NO_COLORS" | sed 's/^[^[:space:]]* //')
else
    # No icon, use as is
    CLEAN_LINE="\$NO_COLORS"
fi

# Extract recipe name (first word, might include module::recipe format)
RECIPE=\$(echo "\$CLEAN_LINE" | awk '{print \$1}')


# Validate recipe name
if [[ -z "\$RECIPE" ]]; then
    echo "Error: No recipe name found in selection"
    echo "DEBUG: Full line was: '\$FULL_LINE'" >&2
    exit 1
fi

# Colors
PREVIEW_TITLE='$PREVIEW_TITLE'
DOC_COLOR='$DOC_COLOR'
ATTR_COLOR='$ATTR_COLOR'
SIGNATURE_COLOR='$SIGNATURE_COLOR'
PARAM_NAME_COLOR='$PARAM_NAME_COLOR'
REQUIRED_PARAM_COLOR='$REQUIRED_PARAM_COLOR'
DEFAULT_VALUE_COLOR='$DEFAULT_VALUE_COLOR'
DEPENDENCY_COLOR='$DEPENDENCY_COLOR'
MODULE_HEADER_COLOR='$MODULE_HEADER_COLOR'
DIM='$DIM'
BOLD='$BOLD'
NC='$NC'

# Check if it's a module recipe
MODULE_NAME=""
RECIPE_NAME=""
if [[ "\$RECIPE" =~ :: ]]; then
    MODULE_NAME=\${RECIPE%%::*}
    RECIPE_NAME=\${RECIPE#*::}
    echo -e "\${MODULE_HEADER_COLOR}\${BOLD}Module: \${MODULE_NAME}\${NC}"
    echo -e "\${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━\${NC}"
else
    RECIPE_NAME="\$RECIPE"
fi

# Get recipe signature to extract parameters
# First check if the recipe exists
if ! just --justfile "\$JFILE" --show "\$RECIPE" >/dev/null 2>&1; then
    echo -e "\${DIM}Recipe not found: \$RECIPE\${NC}"
    # Check if it's a module name without recipe
    if [[ ! "\$RECIPE" =~ :: ]] && grep -q "^mod \$RECIPE " "\$JFILE" 2>/dev/null; then
        echo -e "\${DIM}This appears to be a module name. Please select a specific recipe.\${NC}"
    fi
    exit 0
fi

SIGNATURE=\$(just --justfile "\$JFILE" --show "\$RECIPE" 2>/dev/null | grep "^\${RECIPE_NAME}" | head -1)
PARAMS_STRING=\$(echo "\$SIGNATURE" | sed -n "s/^\${RECIPE_NAME}[[:space:]]*\\(.*\\):/\\1/p")

# Check if this recipe has parameters vs dependencies
# Logic: if signature has params before colon, show them as parameters
# If signature has items after colon only, show them as dependencies
BEFORE_COLON=\$(echo "\$SIGNATURE" | sed -n "s/^\${RECIPE_NAME}[[:space:]]*\\([^:]*\\):.*/\\1/p")
AFTER_COLON=\$(echo "\$SIGNATURE" | sed -n "s/^\${RECIPE_NAME}[^:]*:[[:space:]]*\\(.*\\)$/\\1/p")

# Show parameters if they exist (items before colon)
if [[ -n "\$BEFORE_COLON" ]] && [[ "\$BEFORE_COLON" != "\$AFTER_COLON" ]]; then
    for param in \$BEFORE_COLON; do
        if [[ "\$param" =~ ^([^=]+)=(.*)$ ]]; then
            param_name="\${BASH_REMATCH[1]}"
            default_val="\${BASH_REMATCH[2]}"
            echo -e "\${PARAM_NAME_COLOR}\${param_name}\${NC}=\${DEFAULT_VALUE_COLOR}\${default_val}\${NC}"
        else
            echo -e "\${REQUIRED_PARAM_COLOR}\${param}\${NC}=<required>"
        fi
    done
fi

# Show dependencies if they exist (items after colon)
if [[ -n "\$AFTER_COLON" ]]; then
    for dep in \$AFTER_COLON; do
        # Check if it's a module dependency by looking for module::recipe pattern
        # or if it exists as a regular recipe
        if just --list --justfile "\$JFILE" 2>/dev/null | grep -q "^    \$dep "; then
            echo -e "\${DEPENDENCY_COLOR}→ \${dep}\${NC}"
        else
            # Check if it might be a module recipe by checking module files
            # Look for modules that contain this recipe
            found_module=""
            while IFS= read -r module_line; do
                if [[ "\$module_line" =~ ^mod[[:space:]]+([^[:space:]]+)[[:space:]]+ ]]; then
                    module_name="\${BASH_REMATCH[1]}"
                    module_file=\$(echo "\$module_line" | sed 's/^mod [^ ]* "\\(.*\\)"/\\1/')
                    if [[ -f "\$module_file" ]] && grep -q "^\$dep" "\$module_file"; then
                        found_module="\$module_name"
                        break
                    fi
                fi
            done < <(grep "^mod " "\$JFILE" 2>/dev/null || true)

            if [[ -n "\$found_module" ]]; then
                echo -e "\${DEPENDENCY_COLOR}→ \${found_module}::\${dep}\${NC}"
            else
                echo -e "\${DEPENDENCY_COLOR}→ \${dep}\${NC}"
            fi
        fi
    done
fi

# Only show separator if there were parameters or dependencies
if [[ -n "\$BEFORE_COLON" ]] || [[ -n "\$AFTER_COLON" ]]; then
    echo -e "\${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━\${NC}"
fi

# Get the full recipe content - be very careful here
RECIPE_CONTENT=\$(just --justfile "\$JFILE" --show "\$RECIPE" 2>/dev/null || true)

# If recipe content is empty or looks like an error, handle gracefully
if [[ -z "\$RECIPE_CONTENT" ]] || [[ "\$RECIPE_CONTENT" =~ "error:" ]]; then
    echo -e "\${DIM}Recipe not found: \$RECIPE\${NC}"
    echo -e "\${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━\${NC}"
    echo ""
    echo "This might be:"
    echo "• A module name (try selecting a specific recipe)"
    echo "• An invalid selection"
    echo "• A parsing error"
    exit 0
fi

# Check if recipe has a shebang for bat integration
HAS_SHEBANG=false
SHEBANG_LINE=""
RECIPE_BODY=""
IN_BODY=false
LANG="bash"

while IFS= read -r line; do
    if [[ "\$line" =~ ^[[:space:]]*#!/ ]]; then
        HAS_SHEBANG=true
        SHEBANG_LINE="\$line"
        # Detect language from shebang
        if [[ "\$line" =~ python ]]; then
            LANG="python"
        elif [[ "\$line" =~ node|javascript ]]; then
            LANG="javascript"
        elif [[ "\$line" =~ ruby ]]; then
            LANG="ruby"
        else
            LANG="bash"
        fi
    fi

    if [[ "\$line" =~ ^"\$RECIPE_NAME" ]]; then
        IN_BODY=true
    elif \$IN_BODY; then
        RECIPE_BODY="\${RECIPE_BODY}\${line}\\n"
    fi
done <<< "\$RECIPE_CONTENT"

# Show the recipe definition with appropriate highlighting
if \$HAS_SHEBANG && command -v bat >/dev/null 2>&1; then
    # Show recipe header and attributes/comments first
    echo "\$RECIPE_CONTENT" | while IFS= read -r line; do
        if [[ "\$line" =~ ^# ]] && [[ ! "\$line" =~ ^[[:space:]]*#!/ ]]; then
            echo -e "\${DOC_COLOR}\${line}\${NC}"
        elif [[ "\$line" =~ ^\\[doc ]]; then
            echo -e "\${ATTR_COLOR}\${line}\${NC}"
        elif [[ "\$line" =~ ^"\$RECIPE_NAME" ]]; then
            echo -e "\${SIGNATURE_COLOR}\${line}\${NC}"
            break
        fi
    done

    # Use bat for the recipe body with syntax highlighting
    echo -e "\$RECIPE_BODY" | bat --language="\$LANG" --style=plain --color=always 2>/dev/null || echo -e "\$RECIPE_BODY"
else
    # Fallback to original coloring without bat
    if [[ -n "\$RECIPE_CONTENT" ]]; then
        # If no parameters, skip showing the signature line
        SHOW_SIGNATURE=true
        if [[ -z "\$PARAMS_STRING" ]]; then
            SHOW_SIGNATURE=false
        fi

        echo "\$RECIPE_CONTENT" | while IFS= read -r line; do
            if [[ "\$line" =~ ^# ]] && [[ ! "\$line" =~ ^#!/ ]]; then
                echo -e "\${DOC_COLOR}\${line}\${NC}"
            elif [[ "\$line" =~ ^\\[doc ]]; then
                echo -e "\${ATTR_COLOR}\${line}\${NC}"
            elif [[ "\$line" =~ ^"\$RECIPE_NAME" ]]; then
                if [[ "\$SHOW_SIGNATURE" == "true" ]]; then
                    echo -e "\${SIGNATURE_COLOR}\${line}\${NC}"
                fi
            else
                echo "\$line"
            fi
        done
    fi
fi
PREVIEWEOF
chmod +x "$PREVIEW_SCRIPT"

# ============================================================================
# RUN TV INTERFACE
# ============================================================================

tv \
	--source-command "bash $FORMAT_SCRIPT '$JFILE' '$MODULE_FILTER'" \
	--preview-command "bash $PREVIEW_SCRIPT '{}' '$JFILE'" \
	--ansi \
	>"$SELECTION_FILE"

# Check if selection was made
if [[ ! -s "$SELECTION_FILE" ]]; then
	echo "No selection made"
	exit 0
fi

# ============================================================================
# PROCESS SELECTIONS
# ============================================================================

SELECTIONS=$(cat "$SELECTION_FILE")
SELECTIONS_CLEAN=$(echo "$SELECTIONS" | sed 's/^[^[:space:]]* //' | sed 's/\x1b\[[0-9;]*m//g')
NUM_SELECTIONS=$(echo "$SELECTIONS_CLEAN" | wc -l)

if [[ "$NUM_SELECTIONS" -gt 1 ]]; then
	echo "Selected multiple recipes:"
	echo "$SELECTIONS_CLEAN" | sed 's/^/  - /'
fi

# Get recipe parameters using just --show
get_params() {
	local recipe="$1"
	local recipe_name="${recipe#*::}"
	local signature=$(just --justfile "$JFILE" --show "$recipe" 2>/dev/null | grep "^${recipe_name}" | head -1)

	# Extract parameters that come BEFORE the colon
	# Handles 3 cases:
	# 1. "recipe param1 param2:" (parameters only)
	# 2. "recipe param1 param2: dep1 dep2" (parameters + dependencies)
	# 3. "recipe: dep1 dep2" (dependencies only - no params)
	if [[ "$signature" =~ ^${recipe_name}[[:space:]]+([^:]+): ]]; then
		echo "${BASH_REMATCH[1]}"
	fi
	# If signature is just "recipe:" then no parameters (empty return)
}

# Prompt for parameter
# Enhanced prompt with TV-based file completion (TAB-triggered)
prompt_param() {
	local param="$1"
	local name=""
	local default=""
	local is_required=true

	# Parse parameter format
	if [[ "$param" =~ ^([^=]+)=(.*)$ ]]; then
		name="${BASH_REMATCH[1]}"
		default="${BASH_REMATCH[2]//\"/}"
		is_required=false
	else
		name="$param"
		is_required=true
	fi

	while true; do
		local value=""

		# Create the prompt string with color codes
		local prompt_str=$(echo -e "\033[33m$name\033[0m=")

		# Shell-agnostic TAB completion setup
		if [[ -n "$BASH_VERSION" ]] && command -v bind >/dev/null 2>&1; then
			# Bash with bind available - use TAB interception
			_just_tv_completion() {
				local current_line="${READLINE_LINE}"
				local selected=$(launch_tv_file_completion_with_query "$current_line")
				if [[ -n "$selected" ]]; then
					READLINE_LINE="$selected"
					READLINE_POINT=${#selected}
				fi
			}
			local old_tab_binding=$(bind -p 2>/dev/null | grep '"\\t"' | head -1 || true)
			bind -x '"\t": _just_tv_completion' 2>/dev/null
			# Use read -p for truly non-editable prompt
			read -ep "$prompt_str" value </dev/tty
			if [[ -n "$old_tab_binding" ]]; then
				eval "bind '$old_tab_binding'" 2>/dev/null
			else
				bind '"\t": complete' 2>/dev/null
			fi
		else
			# Zsh or other shells - fall back to pattern detection
			# For zsh, we can't use read -p, so use print -n
			echo -ne "$prompt_str" >&2
			read -e value </dev/tty

			# Post-process: if input starts with . and is short, offer TV completion
			if [[ "$value" =~ ^\..{0,10}$ ]] && [[ "$value" != ".." ]]; then
				echo "Launch file browser? [y/N]: " >&2
				local choice
				read -n 1 choice </dev/tty
				echo "" >&2
				if [[ "$choice" =~ [yY] ]]; then
					local query="${value#.}"  # Remove the leading dot
					local selected=$(launch_tv_file_completion_with_query "$query")
					if [[ -n "$selected" ]]; then
						value="$selected"
					fi
				fi
			fi
		fi

		# Handle default values for optional parameters
		if [[ "$is_required" == "false" ]]; then
			echo "${value:-$default}"
			return 0
		fi

		# Handle required parameters
		if [[ -n "$value" ]]; then
			echo "$value"
			return 0
		else
			echo "This parameter is required!" >&2
		fi
	done
}


# Launch TV for file completion with optional starting query
launch_tv_file_completion_with_query() {
	local query="$1"
	local temp_file=$(mktemp /tmp/tv-file-completion.XXXXXX)

	# If there's a query, filter the find results to show relevant matches first
	if [[ -n "$query" ]]; then
		# Create a source command that prioritizes matches containing the query
		local source_cmd="( find . -type f -o -type d | sed 's|^\./||' | grep -v '^\\.$' | grep \"$query\" | sort; find . -type f -o -type d | sed 's|^\./||' | grep -v '^\\.$' | grep -v \"$query\" | sort ) | head -1000"
		tv \
			--source-command "$source_cmd" \
			--ansi \
			>"$temp_file"
	else
		# Launch TV without query filtering (standard behavior)
		tv \
			--source-command "find . -type f -o -type d | sed 's|^\./||' | grep -v '^\\.$' | sort" \
			--ansi \
			>"$temp_file"
	fi

	# Check if selection was made
	if [[ -s "$temp_file" ]]; then
		local selected=$(cat "$temp_file")
		rm -f "$temp_file"
		echo "$selected"
	else
		rm -f "$temp_file"
		echo ""
	fi
}

# Launch TV for file completion (backward compatibility)
launch_tv_file_completion() {
	launch_tv_file_completion_with_query ""
}

# ============================================================================
# EXECUTE SELECTED RECIPES
# ============================================================================

while IFS= read -r SELECTED; do
	[[ -z "$SELECTED" ]] && continue

	# Strip ANSI color codes first, then check for icons
	SELECTED_NO_COLORS=$(echo "$SELECTED" | sed 's/\x1b\[[0-9;]*m//g')

	# Only strip icon if there's an emoji/icon at the start
	# Icons are typically followed by a space, and recipe names don't start with special chars
	if [[ "$SELECTED_NO_COLORS" =~ ^[🔷🐳🧪🚀📦▶] ]] || [[ "$SELECTED_NO_COLORS" =~ ^\[[a-z]+\] ]]; then
		# Strip the icon (emoji or [text] format)
		SELECTED_CLEAN=$(echo "$SELECTED_NO_COLORS" | sed 's/^[^[:space:]]* //')
	else
		# No icon, just use the version without colors
		SELECTED_CLEAN="$SELECTED_NO_COLORS"
	fi

	# Remove leading/trailing whitespace
	SELECTED_CLEAN=$(echo "$SELECTED_CLEAN" | xargs)

	# Extract recipe name - should be the first word
	RECIPE_NAME=$(echo "$SELECTED_CLEAN" | awk '{print $1}')

	# Build command for this recipe
	CMD="just --justfile='$JFILE' $RECIPE_NAME"
	PARAMS=$(get_params "$RECIPE_NAME")

	# Display recipe signature with colors (like TV interface)
	if [[ -n "$PARAMS" ]]; then
		# Build signature with parameter info
		signature="\033[36m$RECIPE_NAME\033[0m"
		for param in $PARAMS; do
			name=""
			default=""
			is_required=true

			# Parse parameter format
			if [[ "$param" =~ ^([^=]+)=(.*)$ ]]; then
				name="${BASH_REMATCH[1]}"
				default="${BASH_REMATCH[2]//\"/}"
				is_required=false
			else
				name="$param"
				is_required=true
			fi

			if [[ "$is_required" == "true" ]]; then
				signature="$signature \033[33m$name\033[0m=\033[31m<required>\033[0m"
			else
				signature="$signature \033[33m$name\033[0m=\033[90m<$default>\033[0m"
			fi
		done
		echo -e "$signature"
	else
		echo -e "\033[36m$RECIPE_NAME\033[0m"
	fi

	if [[ -n "$PARAMS" ]]; then
		for param in $PARAMS; do
			value=$(prompt_param "$param")

			# Don't display parameter=value again - read -ep already showed it!

			if [[ "$value" =~ \  ]]; then
				CMD="$CMD '$value'"
			else
				CMD="$CMD $value"
			fi
		done
	fi

	# Execute the command and capture exit code
	eval "$CMD"
	EXIT_CODE=$?

	# ========================================================================
	# INTEGRATED HISTORY HANDLING
	# ========================================================================

	# Write to local project history (unless disabled)
	if [[ "$NO_HISTORY" != "true" ]]; then
		write_just_history "$CMD" "$EXIT_CODE"
	fi

	# Add to shell history (for interactive shells)
	add_to_shell_history "$CMD"

	# Also save to temp file for backward compatibility with wrapper functions
	echo "$CMD" >.just-tv-last-command

	# Show exit status only on failure
	if [[ $EXIT_CODE -ne 0 ]]; then
		echo -e "\n\033[0;31m✗ Command failed with exit code: $EXIT_CODE\033[0m"
	fi

done <<<"$SELECTIONS"