#!/bin/bash
#
# Script to interactively create Conda environments, either from YAML files or by manually adding packages to the base environment

source shbin/logger.sh

# Directory containing YAML files
YAML_DIR="pybin/conda_envs"

# Testing mode (set to true for simulation, false for real operations)
TESTING=true

# Check if the directory exists
if [ ! -d "$YAML_DIR" ]; then
    echo "Error: Directory $YAML_DIR does not exist."
    exit 1
fi

# List all YAML files in the directory
YAML_FILES=$(find "$YAML_DIR" -type f -name "*.yaml" -or -name "*.yml")

# Check if any YAML files are found
if [ -z "$YAML_FILES" ]; then
    echo "Warning: No YAML files found in $YAML_DIR."
fi

# Display a menu for the user to choose an option
echo "Choose an option:"
echo "1. Create Conda environment from YAML files"
echo "2. Manually add packages to the base environment"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        # Option 1: Create Conda environment from YAML files
        echo "Available Conda Environments:"
        select ENV_NAME in $(basename -a $YAML_FILES | sed 's/\.[^.]*$//'); do
            if [ -n "$ENV_NAME" ]; then
                break
            else
                echo "Invalid selection. Please choose a number from the list."
            fi
        done

        # Get the description for the selected environment
        DESCRIPTION=$(grep -oP "(?<=^description:\s).*$" "$YAML_DIR/$ENV_NAME.yaml" | sed 's/^[[:space:]]*//')

        # Check if the environment already exists
        if conda env list | grep -qE "\b$ENV_NAME\b"; then
            echo "Environment $ENV_NAME already exists. Skipping."
        else
            # Check if testing mode is enabled
            if [ "$TESTING" = true ]; then
                echo "Testing Mode: Simulating Conda environment creation for $ENV_NAME."
            else
                # Create the Conda environment
                conda env create -f "$YAML_DIR/$ENV_NAME.yaml"

                # Check if the environment creation was successful
                if [ $? -eq 0 ]; then
                    echo "Conda environment $ENV_NAME created successfully."
                else
                    echo "Error: Failed to create Conda environment $ENV_NAME from $YAML_DIR/$ENV_NAME.yaml."
                    exit 1
                fi
            fi
        fi

        # Display the description
        if [ -n "$DESCRIPTION" ]; then
            echo -e "\nDescription for $ENV_NAME:\n$DESCRIPTION"
        fi
        ;;

    2)
        # Option 2: Manually add packages to the base environment
        read -p "Enter the names of packages to add to the base environment (space-separated): " packages
        conda install -n base $packages

        # Check if the installation was successful
        if [ $? -eq 0 ]; then
            echo "Packages added to the base environment successfully."
        else
            echo "Error: Failed to add packages to the base environment."
            exit 1
        fi
        ;;

    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

