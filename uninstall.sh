#!/bin/bash

# Default paths
DEFAULT_SCRIPT_PATH="/opt/pihole/correlate_blockings.py"
DEFAULT_SERVICE_PATH="/etc/systemd/system/correlate_blockings.service"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${RED}Please run as root (use sudo)${NC}"
        exit 1
    fi
}

# Main uninstallation process
main() {
    check_root

    echo -e "${YELLOW}PiHole Block Correlation Uninstaller${NC}"
    echo "----------------------------------------"

    # Stop and disable the service
    echo -e "${YELLOW}Stopping and disabling service...${NC}"
    systemctl stop correlate_blockings.service
    systemctl disable correlate_blockings.service
    systemctl daemon-reload

    # Remove service file
    if [ -f "$DEFAULT_SERVICE_PATH" ]; then
        echo -e "${YELLOW}Removing service file...${NC}"
        rm "$DEFAULT_SERVICE_PATH"
    else
        echo -e "${YELLOW}Service file not found at $DEFAULT_SERVICE_PATH${NC}"
    fi

    # Remove script file
    if [ -f "$DEFAULT_SCRIPT_PATH" ]; then
        echo -e "${YELLOW}Removing script file...${NC}"
        rm "$DEFAULT_SCRIPT_PATH"
    else
        echo -e "${YELLOW}Script file not found at $DEFAULT_SCRIPT_PATH${NC}"
    fi

    echo -e "${GREEN}Uninstallation completed successfully!${NC}"
}

# Run main function
main 