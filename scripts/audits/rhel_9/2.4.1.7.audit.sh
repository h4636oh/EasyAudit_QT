#!/bin/bash

# Brief: This script audits the ownership and permissions of the /etc/cron.d directory.
# It checks if the directory has the correct permissions and ownership.
# Exit 0 indicates the audit passes; exit 1 indicates it fails.

# Check if cron is installed
if ! command -v crontab &> /dev/null; then
    echo "cron is not installed on the system."
    exit 1
fi

# Audit command to check the permissions and ownership of /etc/cron.d
CRON_DIR="/etc/cron.d"
EXPECTED_PERMISSIONS="700"
EXPECTED_UID="0" # root
EXPECTED_GID="0" # root

# Get current permissions and ownership
cron_permissions=$(stat -Lc "%a" $CRON_DIR)
cron_uid=$(stat -Lc "%u" $CRON_DIR)
cron_gid=$(stat -Lc "%g" $CRON_DIR)

# Verify permissions and ownership
if [[ "$cron_permissions" != "$EXPECTED_PERMISSIONS" ]] || [[ "$cron_uid" != "$EXPECTED_UID" ]] || [[ "$cron_gid" != "$EXPECTED_GID" ]]; then
    echo "Audit Failed:"
    echo "Incorrect permissions or ownership on $CRON_DIR"
    echo "Expected: Permissions $EXPECTED_PERMISSIONS, UID $EXPECTED_UID (root), GID $EXPECTED_GID (root)"
    echo "Found: Permissions $cron_permissions, UID $cron_uid, GID $cron_gid"
    exit 1
fi

echo "Audit Passed: $CRON_DIR permissions and ownership are correctly configured."
exit 0

# This script:

# 1. Checks if the `cron` is installed.
# 2. Verifies the current permissions and ownership of `/etc/cron.d`.
# 3. Compares them against the expected values (permissions `700`, UID `0`, GID `0`).
# 4. Outputs the result and corresponding message, exiting with status `0` if the audit passes and `1` if it fails.
