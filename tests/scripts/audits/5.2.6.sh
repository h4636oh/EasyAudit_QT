#!/usr/bin/env bash

echo "Starting audit to ensure sudo caching timeout is no more than 15 minutes..."

# Define sudoers files to check
sudoers_files=("/etc/sudoers" "/etc/sudoers.d/*")

# Check for configured timestamp_timeout in sudoers files
echo "Checking for timestamp_timeout settings in sudoers files..."
configured_timeout=$(grep -roP "timestamp_timeout=\K[0-9]*" "${sudoers_files[@]}" 2>/dev/null)

if [[ -n "$configured_timeout" ]]; then
    echo "Configured timestamp_timeout values found:"
    echo "$configured_timeout"
    if [[ $configured_timeout -le 15 ]]; then
        echo "All timestamp_timeout values are within the acceptable range (15 minutes or less)."
    else
        echo "WARNING: Some timestamp_timeout values exceed 15 minutes. Please review:"
        echo "$configured_timeout"
    fi
else
    echo "No explicit timestamp_timeout configuration found in sudoers files."
    echo "Checking the default timestamp timeout..."
    default_timeout=$(sudo -V | grep -oP "Authentication timestamp timeout: \K[0-9]+")
    if [[ $default_timeout -le 15 ]]; then
        echo "Default timestamp timeout is within the acceptable range (15 minutes or less): $default_timeout minutes."
    else
        echo "WARNING: Default timestamp timeout exceeds 15 minutes: $default_timeout minutes."
        echo "Consider explicitly setting 'Defaults timestamp_timeout=15' in the sudoers file."
    fi
fi

echo "Audit completed."