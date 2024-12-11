#!/usr/bin/env bash

echo "Starting audit for PAM wheel group configuration..."

# Define the PAM file to check
pam_file="/etc/pam.d/su"

# Check for the pam_wheel.so configuration
echo "Checking PAM configuration in $pam_file..."
pam_config=$(grep -Pi '^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h+(?:[^#\n\r]+\h+)?((?!\2)(use_uid\b|group=\H+\b))\h+(?:[^#\n\r]+\h+)?((?!\1)(use_uid\b|group=\H+\b))(\h+.*)?$' "$pam_file" 2>/dev/null)

if [[ -n "$pam_config" ]]; then
    echo "PAM configuration found:"
    echo "$pam_config"
    group_name=$(echo "$pam_config" | grep -oP 'group=\K\H+')
    if [[ -n "$group_name" ]]; then
        echo "Group specified in configuration: $group_name"
        echo "Checking if the group contains any users..."
        
        # Check the group for users
        group_entry=$(grep "^${group_name}:" /etc/group)
        if [[ -n "$group_entry" ]]; then
            users=$(echo "$group_entry" | cut -d: -f4)
            if [[ -z "$users" ]]; then
                echo "The group '$group_name' does not contain any users. This is compliant."
            else
                echo "WARNING: The group '$group_name' contains the following users:"
                echo "$users"
                echo "Please remove all users from the group to comply with the policy."
            fi
        else
            echo "ERROR: Group '$group_name' not found in /etc/group."
        fi
    else
        echo "ERROR: No group specified in the PAM configuration."
    fi
else
    echo "No valid PAM wheel configuration found in $pam_file."
fi

echo "Audit completed."