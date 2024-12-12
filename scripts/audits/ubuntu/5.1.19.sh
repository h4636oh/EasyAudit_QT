#!/bin/bash

# Function to check PermitEmptyPasswords setting
check_permit_empty_passwords() {
    local output=$(sshd -T | grep permitemptypasswords)
    if [[ "$output" == "permitemptypasswords no" ]]; then
        echo "PermitEmptyPasswords is correctly set to no"
    else
        echo "PermitEmptyPasswords is not correctly set. Current value: $output"
    fi
}

# Function to check PermitEmptyPasswords setting with Match directive
check_match_directive() {
    local user=$1
    local output=$(sshd -T -C user="$user" | grep permitemptypasswords)
    if [[ "$output" == "permitemptypasswords no" ]]; then
        echo "PermitEmptyPasswords for user $user is correctly set to no"
    else
        echo "PermitEmptyPasswords for user $user is not correctly set. Current value: $output"
    fi
}

# Check PermitEmptyPasswords setting
check_permit_empty_passwords

# Pause for 1 second
sleep 1

# Check PermitEmptyPasswords setting for specific user if Match directive is used
USER_TO_CHECK="sshuser"
check_match_directive "$USER_TO_CHECK"

