#!/bin/bash

# Function to check PermitRootLogin setting
check_permit_root_login() {
    local output=$(sshd -T | grep permitrootlogin)
    if [[ "$output" == "permitrootlogin no" ]]; then
        echo "PermitRootLogin is correctly set to no"
    else
        echo "PermitRootLogin is not correctly set. Current value: $output"
    fi
}

# Function to check PermitRootLogin setting with Match directive
check_match_directive() {
    local user=$1
    local output=$(sshd -T -C user="$user" | grep permitrootlogin)
    if [[ "$output" == "permitrootlogin no" ]]; then
        echo "PermitRootLogin for user $user is correctly set to no"
    else
        echo "PermitRootLogin for user $user is not correctly set. Current value: $output"
    fi
}

# Check PermitRootLogin setting
check_permit_root_login

# Pause for 1 second
sleep 1

# Check PermitRootLogin setting for specific user if Match directive is used
USER_TO_CHECK="sshuser"
check_match_directive "$USER_TO_CHECK"

