#!/bin/bash
#
# Script for logging!

LOG_DIR="$(dirname $(pwd))/logs"
SCRIPT_NAME=$(basename "$0")
LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}_$(date '+%Y%m%d%H%M%S').log"

# LOGGING
if [ ! -z ${LOG_DIR} ]; then
    mkdir -p "$LOG_DIR"
fi

# Function to log messages to both stdout and a log file
log() {
    local log_message="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Append to log file
    echo "[$timestamp] $log_message" >> "$LOG_FILE"

}

# Redirect stdout to the log file
exec > >(while read line; do log "$line"; done)

# Example usage
log "Script started."

# Your main setup logic here

log "Completed."
