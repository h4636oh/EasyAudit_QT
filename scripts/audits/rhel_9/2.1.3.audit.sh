#!/bin/bash

# This script audits the system for the presence and status of DHCP server services.
# It checks if the `dhcp-server` package is installed and if the `dhcpd.service` and `dhcpd6.service` are enabled or active.
# The script exits with a status code 0 if the audit passes and 1 if it fails.

# Function to check if the dhcp-server package is installed
audit_dhcp_server_package() {
    if rpm -q dhcp-server &> /dev/null; then
        echo "Audit failed: dhcp-server package is installed."
        return 1
    else
        echo "Audit passed: dhcp-server package is not installed."
        return 0
    fi
}

# Function to check if dhcpd and dhcpd6 services are enabled
audit_dhcp_services_enabled() {
    if systemctl is-enabled dhcpd.service dhcpd6.service 2>/dev/null | grep -q 'enabled'; then
        echo "Audit failed: dhcpd.service or dhcpd6.service is enabled."
        return 1
    else
        echo "Audit passed: dhcpd.service and dhcpd6.service are not enabled."
        return 0
    fi
}

# Function to check if dhcpd and dhcpd6 services are active
audit_dhcp_services_active() {
    if systemctl is-active dhcpd.service dhcpd6.service 2>/dev/null | grep -q '^active'; then
        echo "Audit failed: dhcpd.service or dhcpd6.service is active."
        return 1
    else
        echo "Audit passed: dhcpd.service and dhcpd6.service are not active."
        return 0
    fi
}

# Main audit logic
main_audit() {
    # Check if dhcp-server package is installed
    if audit_dhcp_server_package; then
        exit 0
    else
        # If package is installed, check services' enabled and active status
        if audit_dhcp_services_enabled || audit_dhcp_services_active; then
            echo "The package is installed but the required services are not properly disabled."
            exit 1
        else
            echo "The package is installed due to dependencies, but services are properly controlled."
            exit 0
        fi
    fi
}

# Execute the main audit function
main_audit

# This script performs an audit of the DHCP server services, ensuring that they are neither installed nor running on the system unless required by dependencies and properly controlled. It checks the package status and service status to provide appropriate audit outputs.