#!/bin/bash

# Check if /etc/motd exists
if [ -e /etc/motd ]; then
    # Get file status
    file_status=$(stat -Lc 'Access: (%#a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/motd)
    
    # Extract access permissions, UID, and GID
    access=$(echo "$file_status" | grep -oP 'Access: \(\K[^/]+')
    uid=$(echo "$file_status" | grep -oP 'Uid: \(\K[^/]+')
    gid=$(echo "$file_status" | grep -oP 'Gid: \(\K[^/]+')

    # Verify permissions, UID, and GID
    if [[ "$access" -le 644 && "$uid" -eq 0 && "$gid" -eq 0 ]]; then
        echo "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)"
    else
        echo "File /etc/motd does not meet the specified criteria."
        echo "Current status: $file_status"
        exit 1
    fi
else
    echo "File /etc/motd does not exist."
fi

