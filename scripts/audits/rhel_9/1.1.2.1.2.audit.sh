#!/bin/bash

# Title: Ensure nodev option set on /tmp partition (Automated)
# Level: Level 1 - Server and Workstation
# Description: Verify that the nodev option is set for the /tmp partition to prevent the creation of special devices.

# Audit: Check if the nodev option is set on /tmp
audit_tmp_nodev() {
    # Check if /tmp is mounted with the nodev option
    if findmnt -kn /tmp | grep -vq nodev; then
        echo "Audit Failed: /tmp is not mounted with the 'nodev' option."
        exit 1
    else
        echo "Audit Passed: /tmp is mounted with the 'nodev' option."
        exit 0
    fi
}

# Prompt the user to ensure manual remediation if needed
manual_check_prompt() {
    echo "Manual Check: Please ensure that a separate partition exists for /tmp and that the 'nodev' option is set in /etc/fstab."
}

# Main Execution
audit_tmp_nodev
manual_check_prompt

### Key Points:
# - The script first checks if `/tmp` is mounted with the `nodev` option using `findmnt`.
# - It will exit with code `1` and print a failure message if the `nodev` option is not set.
# - It will exit with code `0` and print a success message if the `nodev` option is set.
# - The script includes a manual check prompt to ensure users verify their `/etc/fstab` for proper configuration.