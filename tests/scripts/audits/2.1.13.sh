#!/bin/bash

# Check if rsync is installed
if dpkg-query -s rsync &>/dev/null; then
    echo "rsync is installed"
    
    # Check if rsync.service is enabled
    if systemctl is-enabled rsync.service 2>/dev/null | grep 'enabled'; then
        echo "rsync.service is enabled"
        exit 1
    else
        echo "rsync.service is not enabled"
    fi

    # Check if rsync.service is active
    if systemctl is-active rsync.service 2>/dev/null | grep '^active'; then
        echo "rsync.service is active"
        exit 1
    else
        echo "rsync.service is not active"
    fi
else
    echo "rsync is not installed"
fi

