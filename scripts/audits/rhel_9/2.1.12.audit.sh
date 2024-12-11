#!/bin/bash

# Audit script for ensuring rpcbind services are not in use

# Function to check if rpcbind package is installed
check_rpcbind_installed() {
    if rpm -q rpcbind &>/dev/null; then
        echo "rpcbind package is installed."
        return 1
    else
        echo "rpcbind package is not installed."
        return 0
    fi
}

# Function to check if rpcbind.socket and rpcbind.service are enabled
check_rpcbind_services_enabled() {
    if systemctl is-enabled rpcbind.socket rpcbind.service &>/dev/null | grep -q 'enabled'; then
        echo "rpcbind.socket or rpcbind.service is enabled."
        return 1
    else
        echo "rpcbind.socket or rpcbind.service is not enabled."
        return 0
    fi
}

# Function to check if rpcbind.socket and rpcbind.service are active
check_rpcbind_services_active() {
    if systemctl is-active rpcbind.socket rpcbind.service &>/dev/null | grep -q '^active'; then
        echo "rpcbind.socket or rpcbind.service is active."
        return 1
    else
        echo "rpcbind.socket or rpcbind.service is not active."
        return 0
    fi
}

# Main audit logic
main() {
    # Check if rpcbind package is installed
    if ! check_rpcbind_installed; then
        # If installed, check if the socket and services are enabled or active
        if check_rpcbind_services_enabled || check_rpcbind_services_active; then
            # Instructions to the user if package is required as a dependency
            echo "Note: If rpcbind is required as a dependency, ensure it is approved by local site policy."
            echo "Review the policy to verify if stopping and masking the services meets the requirements."
            exit 1
        fi
    fi

    echo "Audit passed: rpcbind services are not in use."
    exit 0
}

# Execute the main function
main