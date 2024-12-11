
#!/bin/bash

# Audit script to verify if rsyslog service is enabled and active.
# This script assumes rsyslog is the chosen logging service.
# For servers and workstations, exits with 0 on success or 1 on failure.

# Function to check if rsyslog is installed
check_rsyslog_installed() {
    if ! command -v rsyslogd >/dev/null 2>&1; then
        echo "rsyslog is not installed. Please install the rsyslog package."
        exit 1
    fi
}

# Function to check if rsyslog is enabled
check_rsyslog_enabled() {
    local is_enabled
    is_enabled=$(systemctl is-enabled rsyslog 2>/dev/null)
    
    if [[ "$is_enabled" != "enabled" ]]; then
        echo "rsyslog service is not enabled. Please enable it manually."
        echo "Run: systemctl enable rsyslog.service"
        exit 1
    fi
}

# Function to check if rsyslog is active
check_rsyslog_active() {
    local is_active
    is_active=$(systemctl is-active rsyslog.service 2>/dev/null)
    
    if [[ "$is_active" != "active" ]]; then
        echo "rsyslog service is not active. Please start it manually."
        echo "Run: systemctl start rsyslog.service"
        exit 1
    fi
}

# Main script execution
check_rsyslog_installed
check_rsyslog_enabled
check_rsyslog_active

echo "rsyslog service is enabled and active."
exit 0
```

This script performs a series of checks to ensure the rsyslog service is installed, enabled, and active, as required. If any check fails, user instructions are provided, and the script exits with a non-zero status. Otherwise, it exits successfully, confirming the service's proper status.