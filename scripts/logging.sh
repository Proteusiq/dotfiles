#!/bin/bash
# Logging and progress utilities

# Colors (must be defined before use)
readonly RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m' CYAN='\033[0;36m' BOLD='\033[1m' DIM='\033[2m' NC='\033[0m'

# =============================================================================
# Logging Functions
# =============================================================================
# Levels: step (always), log (v>=1), info (v>=1), debug (v>=2)
# Errors and warnings always shown

log_step()  { echo -e "${GREEN}$*${NC}" | tee -a "$LOG_FILE"; }
log()       { [[ $VERBOSITY -ge 1 ]] && echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $*${NC}" | tee -a "$LOG_FILE" || echo "$*" >> "$LOG_FILE"; }
log_error() { echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*${NC}" | tee -a "$LOG_FILE" >&2; }
log_warn()  { echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $*${NC}" | tee -a "$LOG_FILE"; }
log_info()  { [[ $VERBOSITY -ge 1 ]] && echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $*${NC}" | tee -a "$LOG_FILE" || echo "INFO: $*" >> "$LOG_FILE"; }
log_debug() { [[ $VERBOSITY -ge 2 ]] && echo -e "${BLUE}[DEBUG] $*${NC}" | tee -a "$LOG_FILE" || true; }

# =============================================================================
# Progress Spinner
# =============================================================================

SPINNER_PID=""

spin() {
    local chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local i=0
    tput civis 2>/dev/null  # hide cursor
    while true; do
        printf "\r  ${BLUE}%s${NC}  " "${chars:$i:1}"
        i=$(( (i + 1) % ${#chars} ))
        sleep 0.1
    done
}

start_spinner() {
    [[ $VERBOSITY -ge 1 || "$DRY_RUN" == true ]] && return
    if [[ -t 1 ]]; then
        spin &
        SPINNER_PID=$!
        disown
    fi
}

stop_spinner() {
    if [[ -n "$SPINNER_PID" ]]; then
        kill "$SPINNER_PID" 2>/dev/null
        wait "$SPINNER_PID" 2>/dev/null
        printf "\r      \r"
        tput cnorm 2>/dev/null  # show cursor
        SPINNER_PID=""
    fi
}

# =============================================================================
# Command Execution Helpers
# =============================================================================

# Run command with spinner in quiet mode, full output in verbose
run_quiet() {
    [[ "$DRY_RUN" == true ]] && { dry_run_msg "Would run: $*"; return 0; }
    if [[ $VERBOSITY -ge 1 ]]; then
        "$@"
    else
        start_spinner
        "$@" >> "$LOG_FILE" 2>&1
        local rc=$?
        stop_spinner
        return $rc
    fi
}

# Execute with debug logging
execute() {
    log_debug "Executing: $*"
    [[ "$DRY_RUN" == true ]] && { [[ $VERBOSITY -ge 1 ]] && echo "[DRY RUN] Would execute: $*"; return 0; }
    "$@"
}

dry_run_msg() { [[ "$DRY_RUN" == true && $VERBOSITY -ge 1 ]] && echo "[DRY RUN] $*" || true; }

has_cmd() { command -v "$1" &>/dev/null; }
