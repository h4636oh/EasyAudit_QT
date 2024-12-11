#!/bin/bash

# Title: 1.1.2.2.3 Ensure nosuid option set on /dev/shm partition
# Description: The nosuid mount option specifies that the filesystem cannot contain setuid files.
# Rationale: Setting this option on a file system prevents users from introducing privileged programs onto the system and allowing non-root users to execute them.
# Profile Applicability: Level 1 - Server, Level 1 - Workstation

# Function to audit the nosuid option on /dev/shm partition
audit_nosuid_option() {
    # Check if a separate partition exists for /dev/shm and verify the nosuid option
    if findmnt -kn /dev/shm | grep -v 'nosuid' > /dev/null 2>&1; then
        echo "Audit Failed: The nosuid option is not set on /dev/shm partition."
        echo "Please manually edit /etc/fstab and add 'nosuid' to the options for /dev/shm."
        return 1
    else
        echo "Audit Passed: The nosuid option is correctly set on /dev/shm partition."
        return 0
    fi
}

# Run the audit
audit_nosuid_option

# Capture the audit result
AUDIT_RESULT=$?

# Exit with the appropriate status based on audit result
if [ $AUDIT_RESULT -eq 0 ]; then
    exit 0
else
    exit 1
fi

