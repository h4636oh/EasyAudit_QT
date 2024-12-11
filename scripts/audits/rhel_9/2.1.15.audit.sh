#!/bin/bash

# Purpose: Audit the system to ensure that telnet-server is not installed, 
# and telnet.socket is neither enabled nor active if installed for dependencies.

# Check if the telnet-server package is installed
telnet_installed=$(rpm -q telnet-server)
if [[ $telnet_installed != "package telnet-server is not installed" ]]; then
    echo "Audit: telnet-server package is installed. Checking dependencies..."

    # Check if telnet.socket is enabled
    if systemctl is-enabled telnet.socket 2>/dev/null | grep -q 'enabled'; then
        echo "Audit Failed: telnet.socket is enabled."
        exit 1
    fi

    # Check if telnet.socket is active
    if systemctl is-active telnet.socket 2>/dev/null | grep -q '^active'; then
        echo "Audit Failed: telnet.socket is active."
        exit 1
    fi

    echo "Audit Note: Ensure the dependent package is approved by local site policy."
    echo "Ensure stopping and masking the service and/or socket meets local site policy."
    exit 0
    
else
    echo "Audit Passed: telnet-server package is not installed."
    exit 0
fi
