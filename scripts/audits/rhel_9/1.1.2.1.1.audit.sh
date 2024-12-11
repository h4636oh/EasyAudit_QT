#!/bin/bash

# Exit script on any error
set -e

# Function to check if /tmp is mounted
check_tmp_mounted() {
    local mount_output
    mount_output=$(findmnt -kn /tmp)

    if [[ -z "$mount_output" ]]; then
        echo "Audit Failed: /tmp is not mounted as a separate partition or tmpfs."
        exit 1
    else
        echo "Check Passed: /tmp is mounted."
    fi
}

# Function to check if systemd will mount /tmp at boot time
check_systemd_tmp_mount() {
    local systemd_status
    systemd_status=$(systemctl is-enabled tmp.mount)

    if [[ "$systemd_status" == "masked" || "$systemd_status" == "disabled" ]]; then
        echo "Audit Failed: systemd will not mount /tmp at boot time (status: $systemd_status)."
        exit 1
    else
        echo "Check Passed: systemd will mount /tmp at boot time (status: $systemd_status)."
    fi
}

# Main function to run all checks
main() {
    echo "Auditing /tmp partition configuration..."

    # Check if /tmp is mounted
    check_tmp_mounted

    # Check if systemd is configured to mount /tmp at boot
    check_systemd_tmp_mount

    echo "All checks passed. Audit successful."
    exit 0
}

# Execute the main function
main