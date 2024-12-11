#!/bin/bash

# Function to check if the Avahi package is installed
check_avahi_installed() {
    if rpm -q avahi &> /dev/null; then
        echo "Avahi package is installed."
        return 1
    else
        echo "Avahi package is not installed."
        return 0
    fi
}

# Function to check if avahi-daemon.socket is enabled
check_socket_enabled() {
    if systemctl is-enabled avahi-daemon.socket &> /dev/null; then
        echo "avahi-daemon.socket is enabled."
        return 1
    else
        echo "avahi-daemon.socket is not enabled."
        return 0
    fi
}

# Function to check if avahi-daemon.service is enabled
check_service_enabled() {
    if systemctl is-enabled avahi-daemon.service &> /dev/null; then
        echo "avahi-daemon.service is enabled."
        return 1
    else
        echo "avahi-daemon.service is not enabled."
        return 0
    fi
}

# Function to check if avahi-daemon.socket is active
check_socket_active() {
    if systemctl is-active avahi-daemon.socket &> /dev/null; then
        echo "avahi-daemon.socket is active."
        return 1
    else
        echo "avahi-daemon.socket is not active."
        return 0
    fi
}

# Function to check if avahi-daemon.service is active
check_service_active() {
    if systemctl is-active avahi-daemon.service &> /dev/null; then
        echo "avahi-daemon.service is active."
        return 1
    else
        echo "avahi-daemon.service is not active."
        return 0
    fi
}

# Main audit process
main_audit() {
    check_avahi_installed
    avahi_installed=$?

    # If Avahi is installed, check if the services are enabled or active
    if [ $avahi_installed -eq 1 ]; then
        check_socket_enabled || check_service_enabled
        services_enabled=$?

        check_socket_active || check_service_active
        services_active=$?

        if [ $services_enabled -eq 1 ] || [ $services_active -eq 1 ]; then
            echo "Audit failed: Avahi services are enabled or active."
            exit 1
        fi
    fi

    echo "Audit passed: Avahi is not installed or services are neither enabled nor active."
    exit 0
}

# Run the main audit function
main_audit

# This script performs an audit to determine if the Avahi package is installed and whether its services are enabled or active. If the package is installed, the script checks the status of `avahi-daemon.socket` and `avahi-daemon.service`. The script exits with status `1` if the audit fails and `0` if it passes.