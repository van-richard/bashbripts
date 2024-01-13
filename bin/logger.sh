#!/bin/bash
#
# Script for logging!

LOG_DIR="logs"
SCRIPT_NAME=$(basename "$0")
LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}_$(date '+%Y%m%d%H%M%S').log"

# LOGGING
mkdir -p "$LOG_DIR"
log() {
    local log_message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') $SCRIPT_NAME: $log_message" | tee -a "$LOG_FILE"
}

