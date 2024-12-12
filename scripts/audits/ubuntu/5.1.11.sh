#!/usr/bin/env bash

# Check the main SSH configuration for IgnoreRhosts
ignorerhosts_output=$(sshd -T 2>/dev/null | grep -i 'ignorerhosts')

# Function to check the main configuration
check_ignorerhosts_main() {
    echo "Main SSH Configuration:"
    if [[ -z "$ignorerhosts_output" ]]; then
        echo "IgnoreRhosts setting not found."
    else
        echo "$ignorerhosts_output"
        if echo "$ignorerhosts_output" | grep -iq 'yes'; then
            echo "IgnoreRhosts is set to 'yes' (correct)."
        else
            echo "Warning: IgnoreRhosts is not set to 'yes'."
        fi
    fi
}

# Check the Match block settings for a specific user
match_block_user="sshuser"
match_output=$(sshd -T -C user="$match_block_user" 2>/dev/null | grep -i 'ignorerhosts')

# Function to check the Match block configuration
check_ignorerhosts_match() {
    echo -e "\nMatch Block Configuration for user '$match_block_user':"
    if [[ -z "$match_output" ]]; then
        echo "No IgnoreRhosts setting found in the Match block for user '$match_block_user'."
    else
        echo "$match_output"
        if echo "$match_output" | grep -iq 'yes'; then
            echo "IgnoreRhosts is set to 'yes' (correct) for user '$match_block_user'."
        else
            echo "Warning: IgnoreRhosts is not set to 'yes' for user '$match_block_user'."
            exit 1
        fi
    fi
}

# Execute the audit checks
check_ignorerhosts_main
check_ignorerhosts_match