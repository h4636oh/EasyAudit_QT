#!/bin/bash

# Ensure the script adheres to Bash syntax and best practices.
# Exit 1 when the audit fails and exit 0 when it passes.

# Check if cron is installed by checking for the presence of /etc/cron.hourly
if [ -d "/etc/cron.hourly" ]; then
    # Audit the permissions, UID, and GID of /etc/cron.hourly
    OUTPUT=$(stat -Lc 'Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/cron.hourly)

    # Expected permissions and ownership
    EXPECTED_PERMISSIONS="700/drwx------"
    EXPECTED_UID="0/ root"
    EXPECTED_GID="0/ root"
    
    # Verify the actual state against expected values
    if echo "$OUTPUT" | grep -q "$EXPECTED_PERMISSIONS" && \
       echo "$OUTPUT" | grep -q "$EXPECTED_UID" && \
       echo "$OUTPUT" | grep -q "$EXPECTED_GID"; then
        echo "Audit Passed: /etc/cron.hourly has correct permissions and ownership."
        exit 0
    else
        echo "Audit Failed: /etc/cron.hourly does not have the correct permissions and ownership."
        echo "Please manually set the permissions and ownership using the following commands:"
        echo "# chown root:root /etc/cron.hourly/"
        echo "# chmod og-rwx /etc/cron.hourly/"
        exit 1
    fi
else
    echo "cron is not installed or /etc/cron.hourly directory does not exist."
    echo "Please ensure cron is installed and then re-run the audit."
    exit 1
fi
