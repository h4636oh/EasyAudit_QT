#!/bin/bash

# Function to check UsePAM setting
check_use_pam() {
    local output=$(sshd -T | grep -i usepam)
    if [[ "$output" == "usepam yes" ]]; then
        echo "UsePAM is correctly set to yes"
    else
        echo "UsePAM is not correctly set. Current value: $output"
        exit 1
    fi
}

# Function to check UsePAM setting with Match directive
check_match_directive() {
    local user=$1
    local output=$(sshd -T -C user="$user" | grep -i usepam)
    if [[ "$output" == "usepam yes" ]]; then
        echo "UsePAM for user $user is correctly set to yes"
    else
        echo "UsePAM for user $user is not correctly set. Current value: $output"
        exit 1
    fi
}

# Check UsePAM setting
check_use_pam

# Pause for 1 second
sleep 1

# Check UsePAM setting for specific user if Match directive is used
USER_TO_CHECK="sshuser"
check_match_directive "$USER_TO_CHECK"

