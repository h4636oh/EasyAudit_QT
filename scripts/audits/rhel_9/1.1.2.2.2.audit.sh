#!/bin/bash

# Audit script to verify that the nodev option is set for /dev/shm
# Profile Applicability: Level 1 - Server, Level 1 - Workstation
# Description: The nodev mount option specifies that the filesystem cannot contain special devices.
# Rationale: Ensure that users cannot attempt to create special devices in /dev/shm partitions.

# Check if /dev/shm is a separate partition and if "nodev" option is set
audit_dev_shm_nodev() {
    local mount_check
    mount_check=$(findmnt -kn /dev/shm | grep -v 'nodev')

    if [[ -n $mount_check ]]; then
        echo "Audit failed: The nodev option is NOT set on /dev/shm."
        echo "Manual Action Required: Verify and modify /etc/fstab to include 'nodev' for /dev/shm."
        return 1
    else
        echo "Audit passed: The nodev option is set on /dev/shm."
        return 0
    fi
}

# Execute the audit function
audit_dev_shm_nodev
exit $?

### Notes:
# - The script checks if the `/dev/shm` partition has the `nodev` option set.
# - If the `nodev` option is not set, it informs the user that manual action is required.
# - Exits with status `1` on audit failure (meaning `nodev` is not set) and `0` on success.
# - Assumes that `/dev/shm` should be a separate partition; behavior may vary based on system setup.