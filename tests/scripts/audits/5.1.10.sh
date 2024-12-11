#!/usr/bin/env bash

# Check the main SSH configuration for HostbasedAuthentication
hostbased_output=$(sshd -T 2>/dev/null | grep -i 'hostbasedauthentication')

# Function to check the main configuration
check_hostbased_main() {
    echo "Main SSH Configuration:"
    if [[ -z "$hostbased_output" ]]; then
        echo "HostbasedAuthentication setting not found."
    else
        echo "$hostbased_output"
        if echo "$hostbased_output" | grep -iq 'no'; then
            echo "HostbasedAuthentication is set to 'no' (correct)."
        else
            echo "Warning: HostbasedAuthentication is not set to 'no'."
        fi
    fi
}

# Check the Match block settings for a specific user
match_block_user="sshuser"
match_output=$(sshd -T -C user="$match_block_user" 2>/dev/null | grep -i 'hostbasedauthentication')

# Function to check the Match block configuration
check_hostbased_match() {
    echo -e "\nMatch Block Configuration for user '$match_block_user':"
    if [[ -z "$match_output" ]]; then
        echo "No HostbasedAuthentication setting found in the Match block for user '$match_block_user'."
    else
        echo "$match_output"
        if echo "$match_output" | grep -iq 'no'; then
            echo "HostbasedAuthentication is set to 'no' (correct) for user '$match_block_user'."
        else
            echo "Warning: HostbasedAuthentication is not set to 'no' for user '$match_block_user'."
            exit 1
        fi
    fi
}

# Execute the audit checks
check_hostbased_main
check_hostbased_match