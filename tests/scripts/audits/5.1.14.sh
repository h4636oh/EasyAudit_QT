#!/usr/bin/env bash

# Function to check LogLevel in the general configuration
check_loglevel() {
    echo "Checking SSH LogLevel in the main configuration..."
    loglevel_output=$(sshd -T 2>/dev/null | grep -i loglevel)

    if [[ "$loglevel_output" =~ loglevel\ (verbose|info) ]]; then
        echo "LogLevel is correctly set: $loglevel_output"
    else
        echo "Warning: LogLevel is not set to VERBOSE or INFO."
        echo "Current setting: $loglevel_output"
    fi
}

# Function to check LogLevel in a Match block for a specific user
check_loglevel_for_user() {
    local user=$1
    echo "Checking SSH LogLevel for user '$user' in a Match block..."
    match_output=$(sshd -T -C user="$user" 2>/dev/null | grep -i loglevel)

    if [[ "$match_output" =~ loglevel\ (verbose|info) ]]; then
        echo "LogLevel for user '$user' is correctly set: $match_output"
    else
        echo "Warning: LogLevel for user '$user' is not set to VERBOSE or INFO."
        echo "Current setting: $match_output"
        exit 1
    fi
}

# Main audit checks
check_loglevel
check_loglevel_for_user "sshuser"  # Example user for the Match block check