#!/usr/bin/env bash

# Run the sshd configuration check for the Banner directive
banner_output=$(sshd -T 2>/dev/null | grep -Pi '^banner\h+\/\H+')

# Function to display banner audit results
display_banner_audit() {
    if [[ -z "$banner_output" ]]; then
        echo "No Banner directive found in the main SSH configuration."
    else
        echo "Banner Directive Found:"
        echo "$banner_output"
    fi
}

# Check for Match block settings for a specific user
match_block_user="sshuser"
match_output=$(sshd -T -C user="$match_block_user" 2>/dev/null | grep -Pi '^banner\h+\/\H+')

# Display results for the main sshd configuration
display_banner_audit

# Display results for the Match block configuration
if [[ -n "$match_output" ]]; then
    echo "Match Block Banner Configuration for user '$match_block_user':"
    echo "$match_output"
else
    echo "No Match block Banner configuration detected for user '$match_block_user'."
    exit 1
fi