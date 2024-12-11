#!/bin/bash

# Initialize a variable to track overall security status
overall_secure=true

# Function to check file permissions and ownership
check_file() {
    local file="$1"

    if [ -e "$file" ]; then
        # Get the file status
        stat_output=$(stat -Lc '%n Access: (%#a/%A) Uid: (%u/%U) Gid: (%g/%G)' "$file")
        echo "$stat_output"

        # Check if permissions are 600 or more restrictive
        permissions=$(stat -c "%a" "$file")
        if [ "$permissions" -le 600 ]; then
            echo "Permissions on $file are secure."
        else
            echo "WARNING: Permissions on $file are not secure! Current permissions: $permissions"
            overall_secure=false
        fi

        # Check if Uid and Gid are 0/root
        uid=$(stat -c "%u" "$file")
        gid=$(stat -c "%g" "$file")
        if [ "$uid" -eq 0 ] && [ "$gid" -eq 0 ]; then
            echo "Ownership of $file is correct (Uid: 0/root, Gid: 0/root)."
        else
            echo "WARNING: Ownership of $file is not correct! Current Uid: $uid, Gid: $gid"
            overall_secure=false
        fi
    else
        echo "$file does not exist."
    fi
}

# Check the specified files
check_file "/etc/security/opasswd"
check_file "/etc/security/opasswd.old"

# Exit with status 1 if any checks failed
if [ "$overall_secure" = false ]; then
    exit 1
else
    echo "*PASS*"
    exit 0
fi