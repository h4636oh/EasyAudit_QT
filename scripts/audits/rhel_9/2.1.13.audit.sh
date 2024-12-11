#!/bin/bash

# 2.1.13 Ensure rsync services are not in use (Automated)

# Check if rsync-daemon package is installed
if rpm -q rsync-daemon &> /dev/null; then
    echo "The rsync-daemon package is installed. Please review if it's required as a dependency."
    exit 1
else
    echo "The rsync-daemon package is not installed."
    
    # Check if rsyncd.socket and rsyncd.service are enabled
    if systemctl is-enabled rsyncd.socket rsyncd.service 2>/dev/null | grep -q 'enabled'; then
        echo "rsyncd.socket and/or rsyncd.service are enabled. Please stop and mask them if they are not required."
        exit 1
    else
        echo "rsyncd.socket and rsyncd.service are not enabled."
    fi
    
    # Check if rsyncd.socket and rsyncd.service are active
    if systemctl is-active rsyncd.socket rsyncd.service 2>/dev/null | grep -q '^active'; then
        echo "rsyncd.socket and/or rsyncd.service are active. Please ensure they are stopped and masked if not required."
        exit 1
    else
        echo "rsyncd.socket and rsyncd.service are not active."
    fi
fi

exit 0

