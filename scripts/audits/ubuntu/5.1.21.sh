#!/bin/bash

# Function to check PermitUserEnvironment setting
check_permit_user_environment() {
    local output=$(sshd -T | grep permituserenvironment)
    if [[ "$output" == "permituserenvironment no" ]]; then
        echo "PermitUserEnvironment is correctly set to no"
    else
        echo "PermitUserEnvironment is not correctly set. Current value: $output"
    fi
}

# Function to check PermitUserEnvironment setting with Match directive
check_match_directive() {
    local user=$1
    local output=$(sshd -T -C user="$user" | grep permituserenvironment)
    if [[ "$output" == "permituserenvironment no" ]]; then
        echo "PermitUserEnvironment for user $user is correctly set to no"
    else
        echo "PermitUserEnvironment for user $user is not correctly set. Current value: $output"
    fi
}

# Check PermitUserEnvironment setting
check_permit_user_environment

# Pause for 1 second
sleep 1

# Check PermitUserEnvironment setting for specific user if Match directive is used
USER_TO_CHECK="sshuser"
check_match_directive "$USER_TO_CHECK"

