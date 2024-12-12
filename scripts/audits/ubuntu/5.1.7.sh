#!/usr/bin/env bash

# Check the main sshd configuration for ClientAliveInterval and ClientAliveCountMax
client_alive_output=$(sshd -T 2>/dev/null | grep -Pi '(clientaliveinterval|clientalivecountmax)')

# Function to display the audit results
display_audit_results() {
    echo "Main SSH Configuration:"
    if [[ -z "$client_alive_output" ]]; then
        echo "No ClientAlive settings found in the main configuration."
    else
        echo "$client_alive_output"
        # Verify that both values are greater than zero
        echo "$client_alive_output" | while read -r line; do
            setting=$(echo "$line" | awk '{print $1}')
            value=$(echo "$line" | awk '{print $2}')
            if [[ $value -gt 0 ]]; then
                echo "  - $setting is set to $value (valid)"
            else
                echo "  - $setting is set to $value (INVALID: Should be greater than zero)"
                exit 1
            fi
        done
    fi
}

# Check for Match block settings for a specific user
match_block_user="sshuser"
match_output=$(sshd -T -C user="$match_block_user" 2>/dev/null | grep -Pi '(clientaliveinterval|clientalivecountmax)')

# Display results for the main configuration
display_audit_results

# Display results for the Match block configuration
echo -e "\nMatch Block Configuration for user '$match_block_user':"
if [[ -z "$match_output" ]]; then
    echo "No ClientAlive settings found in the Match block for user '$match_block_user'."
else
    echo "$match_output"
    echo "$match_output" | while read -r line; do
        setting=$(echo "$line" | awk '{print $1}')
        value=$(echo "$line" | awk '{print $2}')
        if [[ $value -gt 0 ]]; then
            echo "  - $setting is set to $value (valid)"
        else
            echo "  - $setting is set to $value (INVALID: Should be greater than zero)"
            exit 1
        fi
    done
fi