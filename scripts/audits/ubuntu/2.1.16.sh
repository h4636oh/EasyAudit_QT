#!/bin/bash

# Check if tftpd-hpa is installed
if dpkg-query -s tftpd-hpa &>/dev/null; then
    echo "tftpd-hpa is installed"
    
    # Check if tftpd-hpa.service is enabled
    if systemctl is-enabled tftpd-hpa.service 2>/dev/null | grep 'enabled'; then
        echo "tftpd-hpa.service is enabled"
        exit 1
    else
        echo "tftpd-hpa.service is not enabled"
    fi

    # Check if tftpd-hpa.service is active
    if systemctl is-active tftpd-hpa.service 2>/dev/null | grep '^active'; then
        echo "tftpd-hpa.service is active"
        exit 1
    else
        echo "tftpd-hpa.service is not active"
    fi
else
    echo "tftpd-hpa is not installed"
fi

