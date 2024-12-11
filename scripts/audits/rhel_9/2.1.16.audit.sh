#!/bin/bash

# Description: This script audits if the TFTP server services are not in use.
# It checks if the tftp-server package is not installed or if it is, ensures the tftp services and socket are not enabled or active.

# Function to check if a package is installed
is_package_installed() {
    rpm -q "$1" &>/dev/null
}

# Function to check if TFTP services and sockets are enabled
are_services_enabled() {
    systemctl is-enabled tftp.socket tftp.service 2>/dev/null | grep -qi 'enabled'
}

# Function to check if TFTP services and sockets are active
are_services_active() {
    systemctl is-active tftp.socket tftp.service 2>/dev/null | grep -qi '^active'
}

# Audit process
if is_package_installed "tftp-server"; then
    echo "tftp-server package is installed."
    echo "Checking if tftp.socket and tftp.service are enabled or active..."
    
    if are_services_enabled; then
        echo "Audit Failed: tftp.socket or tftp.service is enabled."
        exit 1
    fi
    
    if are_services_active; then
        echo "Audit Failed: tftp.socket or tftp.service is active."
        exit 1
    fi
    
    # Manual verification prompt if the package is needed for a dependency
    echo "Note: If tftp-server is required as a dependency, ensure the configuration aligns with local policy."
    echo "Ensure the dependent package is approved by local site policy."
    echo "Ensure stopping and masking the service and/or socket meets local site policy."
    exit 0
else
    echo "Audit Passed: tftp-server package is not installed."
    exit 0
fia