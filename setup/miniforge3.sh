#!/bin/bash
#
# Script to help setup Conda. The default is to download Miniforge.
# First, a `~/Programs` directory is made.
# Second, clone and install miniforge3, installing this to /~Programs/miniforge3
# Last, is to add an conda alias 
#

source shbin/logger.sh

TESTING=true  # Set to true for testing, false for real operations
BASH_ALIASES="$HOME/.bash_aliases"
MINIFORGE_PATH="$HOME/Programs/miniforge3"

# CHECKING IF U HAVE PYTHON ALREADY
check_python() {
    log "Checking if Python is already installed..."
    if command -v python &> /dev/null || command -v python3 &> /dev/null; then
        log "Python is already installed."
        return 0  # Python is installed
    else
        log "Python is not installed."
        return 1  # Python is not installed
    fi
}

# INSTALLING MINIFORGE
install_miniforge() {
    mkdir -p ~/Programs
    cd ~/Programs
    log "A new directory was made!"
    log "Path: $(pwd)"

    os=$(uname -s)

    case "$os" in
        Linux*)
            log "Detected Linux system."
            if [ "$TESTING" = true ]; then
                log "Simulating download of Miniforge for Linux"
            else
                log "Downloading Miniforge for Linux"
                wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O miniforge.sh
                log "Installing Miniforge for Linux"
                if ! bash miniforge.sh -b -p "$HOME/Programs/miniforge3" < miniforge_response.txt; then
                    log "Error: Miniforge installation failed."
                    exit 1
                fi
            fi
            ;;
        Darwin*)
            log "Detected macOS system."
            arch=$(uname -m)
            case "$arch" in
                x86_64)
                    log "Detected x86_64 architecture on macOS."
                    if [ "$TESTING" = true ]; then
                        log "Simulating download of Miniforge for Intel macOS"
                    else
                        log "Downloading Miniforge for Intel macOS"
                        curl -LO https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-x86_64.sh
                        log "Installing Miniforge for Intel macOS"
                        if ! bash Miniforge3-MacOSX-x86_64.sh -b -p "$HOME/Programs/miniforge3" < miniforge_response.txt; then
                            log "Error: Miniforge installation failed."
                            exit 1
                        fi
                    fi
                    ;;
                arm64)
                    log "Detected arm64 architecture on macOS."
                    if [ "$TESTING" = true ]; then
                        log "Simulating download of Miniforge for ARM macOS"
                    else
                        log "Downloading Miniforge for ARM macOS"
                        curl -LO https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh
                        log "Installing Miniforge for ARM macOS"
                        if ! bash Miniforge3-MacOSX-arm64.sh -b -p "$HOME/Programs/miniforge3" < miniforge_response.txt; then
                            log "Error: Miniforge installation failed."
                            exit 1
                        fi
                    fi
                    ;;
                *)
                    log "Unsupported architecture on macOS: $arch"
                    exit 1
                    ;;
            esac
            ;;
        CYGWIN*|MINGW32*|MSYS*|MINGW*)
            log "Detected Windows system."
            if [ "$TESTING" = true ]; then
                log "Simulating download of Miniforge for Windows"
            else
                log "Downloading Miniforge for Windows"
                curl -LO https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-x86_64.exe
                log "Installing Miniforge for Windows"
                if ! bash Miniforge3-Windows-x86_64.exe -b -p "$HOME/Programs/miniforge3" < miniforge_response.txt; then
                    log "Error: Miniforge installation failed."
                    exit 1
                fi
            fi
            ;;
        *)
            log "Unsupported operating system"
            exit 1
            ;;
    esac

    log "Miniforge installed for ${os} ($([[ "$TESTING" == true ]] && echo "simulation" || echo "real"))"
    log "While it's installing, take a look at the GitHub repository!"
}

# MAKING SURE U GET THE NEWEST ONE 
check_miniforge_version() {
    log "Checking Miniforge version..."
    if [ -f "$MINIFORGE_PATH/bin/conda" ]; then
        miniforge_version=$("$MINIFORGE_PATH/bin/conda" --version | awk '{print $2}')
        log "Miniforge version: $miniforge_version"
    else
        log "Error: Miniforge not found at $MINIFORGE_PATH"
    fi
}

# U PROBABLY DON'T
update_miniforge() {
    log "Updating Miniforge..."
    if ! "$MINIFORGE_PATH/bin/conda" update -n base -c defaults conda -y; then
        log "Error: Miniforge update failed."
        exit 1
    fi
}

# ADDING ALIAS 
add_alias_to_bash_aliases() {
    log "Adding alias to ~/.bash_aliases..."
    if [ -f ~/.bash_aliases ]; then
        echo "alias myconda='eval \"($MINIFORGE_PATH/bin/conda shell.bash hook)\"; conda activate'" >> "$BASH_ALIASES"
        log "Alias added. Don't forget to restart your shell or run 'source ~/.bashrc' to apply changes."
    else
        log "Alias file not found! You will need to make one, and add it yourself!"
    fi
}

# Start logging
log "======== Script Started ========"

# Check if Python is already installed
if check_python; then
    log "Skipping Miniforge installation, as Python is already installed."
else
    # Python is not installed, proceed with Miniforge installation
    install_miniforge
fi

# Check Miniforge version
check_miniforge_version

# Update Miniforge to the latest version
update_miniforge

# Add the alias to ~/.bash_aliases
add_alias_to_bash_aliases

# End logging
log "======== Script Ended ========"

