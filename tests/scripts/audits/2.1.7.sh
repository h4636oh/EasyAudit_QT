#!/bin/bash

# Check if slapd is installed
if dpkg-query -s slapd &>/dev/null; then
    echo "slapd is installed"
    
    # Check if slapd.service is enabled
    enabled_service=$(systemctl is-enabled slapd.service 2>/dev/null | grep 'enabled')
    if [ -n "$enabled_service" ]; then
        echo "slapd.service is enabled"
        exit 1
    else
        echo "slapd.service is not enabled"
    fi

    # Check if slapd.service is active
    active_service=$(systemctl is-active slapd.service 2>/dev/null | grep '^active')
    if [ -n "$active_service" ]; then
        echo "slapd.service is active"
        exit 1
    else
        echo "slapd.service is not active"
    fi
else
    echo "slapd is not installed"
fi

