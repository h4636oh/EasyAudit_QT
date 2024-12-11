#!/bin/bash

# Ensure the script adheres to Bash syntax and best practices.
# Script to audit the auditd service status

# Function to check if auditd is enabled
check_auditd_enabled() {
    is_enabled=$(systemctl is-enabled auditd 2>/dev/null)
    if [[ "$is_enabled" == "enabled" ]]; then
        echo "Auditd is enabled."
        return 0
    else
        echo "Auditd is not enabled."
        return 1
    fi
}

# Function to check if auditd is active
check_auditd_active() {
    is_active=$(systemctl is-active auditd 2>/dev/null)
    if [[ "$is_active" == "active" ]]; then
        echo "Auditd is active."
        return 0
    else
        echo "Auditd is not active."
        return 1
    fi
}

# Perform the audit checks
check_auditd_enabled
enabled_status=$?

check_auditd_active
active_status=$?

# Evaluate overall audit status
if [[ $enabled_status -eq 0 && $active_status -eq 0 ]]; then
    echo "Audit: PASSED - auditd service is enabled and active."
    exit 0
else
    echo "Audit: FAILED - auditd service is not in the desired state."
    echo "Please ensure that the auditd service is enabled and active."
    exit 1
fi
```

