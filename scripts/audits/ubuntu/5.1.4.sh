#!/usr/bin/env bash

# Run the sshd configuration check
audit_output=$(sshd -T 2>/dev/null | grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+')

# Function to display audit results
audit_result() {
    if [[ -z "$audit_output" ]]; then
        echo "No AllowUsers, AllowGroups, DenyUsers, or DenyGroups directives found."
        echo "Review the SSH configuration for site-specific policies."
    else
        echo "Audit Results:"
        echo "$audit_output"
        echo "Verify that the users/groups listed follow the local site policy."
    fi
}

# Check if match block test is needed
match_block_user="sshuser"
match_output=$(sshd -T -C user="$match_block_user" 2>/dev/null | grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+')

# Display results for main sshd configuration
audit_result

# Display results for match block if applicable
if [[ -n "$match_output" ]]; then
    echo "Match Block Configuration for user '$match_block_user':"
    echo "$match_output"
else
    echo "No Match block settings detected for user '$match_block_user'."
    exit 1
fi