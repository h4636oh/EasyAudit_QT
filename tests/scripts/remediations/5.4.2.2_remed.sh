#!/bin/bash

echo "Starting remediation process..."

# Set the root user's GID to 0
echo "Setting the root user's GID to 0..."
usermod -g 0 root

# Check if the root user's GID is set correctly
root_gid=$(id -g root)
if [[ "$root_gid" -eq 0 ]]; then
    echo "Root user's GID is now set to 0."
else
    echo "Failed to set root user's GID to 0."
fi

# Set the root group's GID to 0
echo "Setting the root group's GID to 0..."
groupmod -g 0 root

# Check if the root group's GID is set correctly
root_group_gid=$(getent group root | cut -d: -f3)
if [[ "$root_group_gid" -eq 0 ]]; then
    echo "Root group's GID is now set to 0."
else
    echo "Failed to set root group's GID to 0."
fi

# Find users with GID 0 and remove or reassign them
echo "Checking for users with GID 0 other than root..."
awk -F: '{if($4 == 0 && $1 != "root") print $1}' /etc/passwd | while read user; do
    echo "User $user has GID 0. Proceeding to reassign or remove them."

    # Option 1: Remove the user (uncomment to enable this option)
    # userdel -r $user
    # echo "User $user removed."

    # Option 2: Assign a new GID (e.g., 1001) to the user
    new_gid=1001
    usermod -g "$new_gid" "$user"
    echo "User $user's GID has been changed to $new_gid."
done

echo "Remediation process complete."