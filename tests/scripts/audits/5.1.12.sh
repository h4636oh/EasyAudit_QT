#!/usr/bin/env bash

# Check for weak Key Exchange Algorithms in the SSH configuration
kex_output=$(sshd -T 2>/dev/null | grep -Pi 'kexalgorithms\h+([^#\n\r]+,)?(diffie-hellman-group1-sha1|diffie-hellman-group14-sha1|diffie-hellman-group-exchange-sha1)\b')

# Function to evaluate the output
check_kex_algorithms() {
    echo "Auditing Key Exchange Algorithms..."
    if [[ -z "$kex_output" ]]; then
        echo "No weak Key Exchange Algorithms detected. Configuration is secure."
    else
        echo "Warning: Weak Key Exchange Algorithms detected!"
        echo "$kex_output"
        echo "Please update your SSH configuration to remove these algorithms."
        exit 1
    fi
}

# Execute the audit check
check_kex_algorithms