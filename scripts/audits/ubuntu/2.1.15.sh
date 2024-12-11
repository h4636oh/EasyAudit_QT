#!/bin/bash

# Check if snmpd is installed
if dpkg-query -s snmpd &>/dev/null; then
    echo "snmpd is installed"
    
    # Check if snmpd.service is enabled
    if systemctl is-enabled snmpd.service 2>/dev/null | grep 'enabled'; then
        echo "snmpd.service is enabled"
        exit 1
    else
        echo "snmpd.service is not enabled"
    fi

    # Check if snmpd.service is active
    if systemctl is-active snmpd.service 2>/dev/null | grep '^active'; then
        echo "snmpd.service is active"
        exit 1
    else
        echo "snmpd.service is not active"
    fi
else
    echo "snmpd is not installed"
fi

