#!/bin/bash

# Check if samba is installed
if dpkg-query -s samba &>/dev/null; then
    echo "samba is installed"
    
    # Check if smbd.service is enabled
    if systemctl is-enabled smbd.service 2>/dev/null | grep 'enabled'; then
        echo "smbd.service is enabled"
        exit 1
    else
        echo "smbd.service is not enabled"
    fi

    # Check if smbd.service is active
    if systemctl is-active smbd.service 2>/dev/null | grep '^active'; then
        echo "smbd.service is active"
        exit 1
    else
        echo "smbd.service is not active"
    fi
else
    echo "samba is not installed"
fi

