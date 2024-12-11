#!/usr/bin/env bash

# Define the group name according to site policy
group_name="sugroup"
pam_file="/etc/pam.d/su"

echo "Starting configuration for the 'su' command group restriction..."

# Check if the group already exists
if grep -q "^${group_name}:" /etc/group; then
    echo "Group '${group_name}' already exists."
else
    echo "Creating group '${group_name}'..."
    groupadd "${group_name}"
    if [[ $? -eq 0 ]]; then
        echo "Group '${group_name}' created successfully."
    else
        echo "ERROR: Failed to create group '${group_name}'. Exiting."
        exit 1
    fi
fi

# Check if the PAM configuration already exists
echo "Checking PAM configuration in ${pam_file}..."
if grep -q "^auth.*pam_wheel.so.*group=${group_name}" "$pam_file"; then
    echo "PAM configuration for group '${group_name}' already exists in ${pam_file}."
else
    echo "Adding PAM configuration to ${pam_file}..."
    echo "auth required pam_wheel.so use_uid group=${group_name}" >> "${pam_file}"
    if [[ $? -eq 0 ]]; then
        echo "PAM configuration added successfully to ${pam_file}."
    else
        echo "ERROR: Failed to update ${pam_file}. Exiting."
        exit 1
    fi
fi

echo "Configuration completed. Ensure that the group '${group_name}' remains empty to comply with the policy."