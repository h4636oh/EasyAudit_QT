#!/bin/bash

# This script audits that the sudo authentication timeout is configured to be no more than 15 minutes.
# Based on CIS controls and best practices, and the provided instructions.

# Function to check sudo timeout
audit_sudo_timeout() {
    # Default sudo timeout in minutes if not specified (5 minutes)
    default_timeout=5

    # Check if any specific timeout is set in sudoers files
    specified_timeout=$(grep -roP "timestamp_timeout=\\K[0-9]*" /etc/sudoers* 2>/dev/null)

    # If specified timeout is found, use it; otherwise, use the default
    if [[ -n "$specified_timeout" ]]; then
        actual_timeout="$specified_timeout"
    else
        # Checking the default sudo configuration for timeout
        actual_timeout=$(sudo -V | grep "Authentication timestamp timeout:" | awk '{print $4}')
        actual_timeout=${actual_timeout%?} # Remove the trailing 'm'
    fi

    # Compare the actual timeout with 15 minutes
    if (( actual_timeout > 15 )); then
        echo "Audit Failed: Sudo authentication timeout is set to $actual_timeout minutes, which is greater than 15 minutes."
        echo "Please manually update the sudoers file to set 'timestamp_timeout=15'."
        exit 1
    else
        echo "Audit Passed: Sudo authentication timeout is $actual_timeout minutes."
        exit 0
    fi
}

# Call the audit function
audit_sudo_timeout
```

