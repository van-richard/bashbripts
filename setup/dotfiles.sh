#!/bin/bash

# Set to true for testing, false for real operations
TESTING=true

# Paths to template files
TEMPLATE_DIR="$(dirname $(pwd))/templates"
BASH_PROFILE_TEMPLATE="${TEMPLATE_DIR}/bash_profile"
BASHRC_TEMPLATE="${TEMPLATE_DIR}/bashrc"
BASH_ALIASES_TEMPLATE="${TEMPLATE_DIR}/bash_aliases"
VIMRC_TEMPLATE="${TEMPLATE_DIR}/vimrc"
TMUX_CONF_TEMPLATE="${TEMPLATE_DIR}/tmux_conf"

# Paths to Bash startup files
BASH_PROFILE="$HOME/.bash_profile"
BASHRC="$HOME/.bashrc"
BASH_ALIASES="$HOME/.bash_aliases"
VIMRC="$HOME/.vimrc"
TMUX_CONF="$HOME/.tmux.conf"

# Function to load template content
load_template() {
    local template_path="$1"
    cat "$template_path"
}

# Function to check if the file exists
file_exists() {
    local file_path="$1"
    [ -e "$file_path" ]
}

# Function to perform a diff check
perform_diff_check() {
    local file_path="$1"
    local template_content="$2"

    if file_exists "$file_path"; then
        local existing_content
        existing_content=$(cat "$file_path")
        
        # Sort the content of the files before diffing
        local sorted_existing_content=$(sort "$file_path")
        local sorted_template_content=$(sort <(echo "$template_content"))
        diff_result=$(diff <(echo "$sorted_existing_content") <(echo "$sorted_template_content"))
        echo "$diff_result"
    else
        echo "File does not exist"
    fi
}

# Function to write content to file
write_to_file() {
    local content="$1"
    local file_path="$2"
    echo "$content" > "$file_path"
}

# Function to ask the user if they want to exit and check log file
ask_to_exit() {
    read -p "Do you want to exit and check the log file before writing to files? (y/n): " exit_check_log
    case $exit_check_log in
        [Yy]*)
            echo "Exiting. Please check the log file for details: $LOG_FILE"
            exit 0
            ;;
        *)
            echo "Continuing with writing modified content to files..."
            ;;
    esac
}


# Detect the operating system
os=$(uname -s)

case "$os" in
    Linux*)
        echo "Linux OS detected."
        # Add Linux-specific configurations here
        ;;
    Darwin*)
        echo "macOS detected."
        # Add macOS-specific configurations here
        ;;
    *)
        echo "Unsupported operating system: $os"
        exit 1
        ;;
esac

# Load template content
BASH_PROFILE_CONTENT=$(load_template "$BASH_PROFILE_TEMPLATE")
BASHRC_CONTENT=$(load_template "$BASHRC_TEMPLATE")
BASH_ALIASES_CONTENT=$(load_template "$BASH_ALIASES_TEMPLATE")
VIMRC_CONTENT=$(load_template "$VIMRC_TEMPLATE")
TMUX_CONF_CONTENT=$(load_template "$TMUX_CONF_TEMPLATE")

# Perform diff checks
diff_profile=$(perform_diff_check "$BASH_PROFILE" "$BASH_PROFILE_CONTENT")
diff_rc=$(perform_diff_check "$BASHRC" "$BASHRC_CONTENT")
diff_aliases=$(perform_diff_check "$BASH_ALIASES" "$BASH_ALIASES_CONTENT")
diff_vimrc=$(perform_diff_check "$VIMRC" "$VIMRC_CONTENT")
diff_tmux_conf=$(perform_diff_check "$TMUX_CONF" "$TMUX_CONF_CONTENT")

# Print diff checks
echo "Diff check for $BASH_PROFILE:"
echo "$diff_profile"

echo "Diff check for $BASHRC:"
echo "$diff_rc"

echo "Diff check for $BASH_ALIASES:"
echo "$diff_aliases"

echo "Diff check for $VIMRC:"
echo "$diff_vimrc"

echo "Diff check for $TMUX_CONF:"
echo "$diff_tmux_conf"

# Check if there are differences before proceeding
if [ -n "$diff_profile$diff_rc$diff_aliases$diff_vimrc$diff_tmux_conf" ]; then
    echo "There are differences. Prompting to check log file before writing to files."
    ask_to_exit
else
    echo "No differences detected. Exiting."
    exit 0
fi


# Write content to files if the user agrees
read -p "Do you want to write the modified content to files? (y/n): " write_to_files
case $write_to_files in
    [Yy]*)
        if [ "$TESTING" = true ]; then
            echo "Testing Mode: Content not written to files in testing mode."
        else
            write_to_file "$BASH_PROFILE_CONTENT" "$BASH_PROFILE"
            write_to_file "$BASHRC_CONTENT" "$BASHRC"
            write_to_file "$BASH_ALIASES_CONTENT" "$BASH_ALIASES"
            write_to_file "$VIMRC_CONTENT" "$VIMRC"
            write_to_file "$TMUX_CONF_CONTENT" "$TMUX_CONF"
            echo "Bash startup files, Vim configuration, and tmux configuration updated."

        fi
        ;;
    *)
        echo "Modified content not written to files. Exiting."
        ;;
esac

# End script
echo "======== Script Ended ========"

