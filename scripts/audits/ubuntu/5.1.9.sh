#!/usr/bin/env bash

# Check the main SSH configuration for GSSAPIAuthentication
gssapi_output=$(sshd -T 2>/dev/null | grep -i 'gssapiauthentication')

# Function to display the audit results for the main configuration
check_gssapi_main() {
    echo "Main SSH Configuration:"
    if [[ -z "$gssapi_output" ]]; then
        echo "GSSAPIAuthentication setting not found."
    else
        echo "$gssapi_output"
        if echo "$gssapi_output" | grep -iq 'no'; then
            echo "GSSAPIAuthentication is set to 'no' (correct)."
        else
            echo "Warning: GSSAPIAuthentication is not set to 'no'."
        fi
    fi
}

# Check the Match block settings for a specific user
match_block_user="sshuser"
match_output=$(sshd -T -C user="$match_block_user" 2>/dev/null | grep -i 'gssapiauthentication')

# Function to display the audit results for Match block configuration
check_gssapi_match() {
    echo -e "\nMatch Block Configuration for user '$match_block_user':"
    if [[ -z "$match_output" ]]; then
        echo "No GSSAPIAuthentication setting found in the Match block for user '$match_block_user'."
    else
        echo "$match_output"
        if echo "$match_output" | grep -iq 'no'; then
            echo "GSSAPIAuthentication is set to 'no' (correct) for user '$match_block_user'."
        else
            echo "Warning: GSSAPIAuthentication is not set to 'no' for user '$match_block_user'."
            exit 1
        fi
    fi
}

# Execute the audit checks
check_gssapi_main
check_gssapi_match