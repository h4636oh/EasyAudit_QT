#!/bin/bash

# Check if vsftpd is installed
if dpkg-query -s vsftpd &>/dev/null; then
    echo "vsftpd is installed"
    
    # Check if vsftpd.service is enabled
    enabled_service=$(systemctl is-enabled vsftpd.service 2>/dev/null | grep 'enabled')
    if [ -n "$enabled_service" ]; then
        echo "vsftpd.service is enabled"
        exit 1
    else
        echo "vsftpd.service is not enabled"
    fi

    # Check if vsftpd.service is active
    active_service=$(systemctl is-active vsftpd.service 2>/dev/null | grep '^active')
    if [ -n "$active_service" ]; then
        echo "vsftpd.service is active"
        exit 1
    else
        echo "vsftpd.service is not active"
    fi
else
    echo "vsftpd is not installed"
fi

