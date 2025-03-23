#!/bin/bash

# Default installation paths
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

# Function to check if PiHole is installed (either natively or in Docker)
check_pihole() {
    # Check for native PiHole installation
    if command -v pihole &> /dev/null; then
        echo -e "${GREEN}Found native PiHole installation${NC}"
        return 0
    fi

    # Check for PiHole Docker container
    if command -v docker &> /dev/null; then
        if docker ps --format '{{.Names}}' | grep -q "pihole"; then
            echo -e "${GREEN}Found PiHole running in Docker${NC}"
            return 0
        fi
    fi

    echo -e "${RED}PiHole is not installed (neither natively nor in Docker). Please install PiHole first.${NC}"
    exit 1
}

# Main installation process
main() {
    check_root
    check_pihole

    echo -e "${YELLOW}PiHole Block Correlation Installer${NC}"
    echo "----------------------------------------"

    # Ask for script installation path
    read -p "Enter script installation path [$DEFAULT_SCRIPT_PATH]: " script_path
    script_path=${script_path:-$DEFAULT_SCRIPT_PATH}

    # Create directory if it doesn't exist
    script_dir=$(dirname "$script_path")
    if [ ! -d "$script_dir" ]; then
        mkdir -p "$script_dir"
    fi

    # Copy the script
    echo -e "${YELLOW}Copying script to $script_path...${NC}"
    cp correlate_blockings.py "$script_path"
    chmod +x "$script_path"

    # Copy and enable service
    echo -e "${YELLOW}Setting up systemd service...${NC}"
    cp correlate_blockings.service "$DEFAULT_SERVICE_PATH"
    
    # Reload systemd and enable service
    systemctl daemon-reload
    systemctl enable correlate_blockings.service
    systemctl start correlate_blockings.service

    # Check service status
    if systemctl is-active --quiet correlate_blockings.service; then
        echo -e "${GREEN}Installation completed successfully!${NC}"
        echo -e "${GREEN}Service is running.${NC}"
    else
        echo -e "${RED}Service failed to start. Check status with:${NC}"
        echo "systemctl status correlate_blockings.service"
    fi
}

# Run main function
main 