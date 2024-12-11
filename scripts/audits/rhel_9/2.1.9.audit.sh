#!/bin/bash

# This script audits the system to ensure network file system (NFS) services are not in use.

# Function to check if nfs-utils package is installed
check_nfs_utils() {
    rpm -q nfs-utils &> /dev/null
    if [ $? -eq 0 ]; then
        echo "nfs-utils package is installed. Checking further conditions..."
        return 0
    else
        echo "nfs-utils package is not installed."
        return 1
    fi
}

# Function to check if nfs-server.service is enabled
check_nfs_server_enabled() {
    if systemctl is-enabled nfs-server.service 2>/dev/null | grep -q 'enabled'; then
        echo "nfs-server.service is enabled. It should be disabled."
        return 1
    else
        echo "nfs-server.service is not enabled."
        return 0
    fi
}

# Function to check if nfs-server.service is active
check_nfs_server_active() {
    if systemctl is-active nfs-server.service 2>/dev/null | grep -q '^active'; then
        echo "nfs-server.service is active. It should be stopped."
        return 1
    else
        echo "nfs-server.service is not active."
        return 0
    fi
}

# Main audit logic
check_nfs_utils
nfs_installed=$?

if [ $nfs_installed -eq 0 ]; then
    check_nfs_server_enabled
    server_enabled=$?

    check_nfs_server_active
    server_active=$?

    # Check if services are both not enabled and not active
    if [ $server_enabled -eq 0 ] && [ $server_active -eq 0 ]; then
        echo "Audit passed: Network file system services are not in use as required."
        exit 0
    else
        echo "Audit failed: nfs-server.service should be stopped and masked if the nfs-utils package is required for dependencies."
        exit 1
    fi
else
    echo "Audit passed: Network file system services are not in use as nfs-utils is not installed."
    exit 0
fi