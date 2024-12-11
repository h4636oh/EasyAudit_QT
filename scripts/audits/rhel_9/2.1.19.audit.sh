#!/bin/bash

# This script audits the presence and status of xinetd services.
# It checks if xinetd is installed, and if it is, ensures its service is not enabled or active.

# Function to check if xinetd package is installed
function check_xinetd_installed {
    if rpm -q xinetd &>/dev/null; then
        echo "xinetd package is installed."
        return 0
    else
        echo "xinetd package is not installed."
        return 1
    fi
}

# Function to check if xinetd.service is enabled
function check_xinetd_service_enabled {
    if systemctl is-enabled xinetd.service 2>/dev/null | grep -q 'enabled'; then
        echo "xinetd.service is enabled."
        return 0
    else
        echo "xinetd.service is not enabled."
        return 1
    fi
}

# Function to check if xinetd.service is active
function check_xinetd_service_active {
    if systemctl is-active xinetd.service 2>/dev/null | grep -q '^active'; then
        echo "xinetd.service is active."
        return 0
    else
        echo "xinetd.service is not active."
        return 1
    fi
}

# Audit xinetd and its service status
check_xinetd_installed
installed=$?

if [ $installed -eq 0 ]; then
    # xinetd is installed, check if its service is enabled and active
    check_xinetd_service_enabled
    enabled=$?
    check_xinetd_service_active
    active=$?
    
    if [ $enabled -eq 0 ] || [ $active -eq 0 ]; then
        echo "Audit failed: xinetd.service is enabled or active when it should not be."
        # Prompt the user to take manual action if needed
        echo "Please ensure xinetd services are stopped and masked if they are not needed."
        exit 1
    else
        echo "Audit passed: xinetd.service is neither enabled nor active."
    fi
else
    echo "Audit passed: xinetd package is not installed."
fi

exit 0