#!/bin/bash

# Script to audit unconfined services on a system
# Profile Applicability: Level 2 - Server, Level 2 - Workstation

echo "Auditing for unconfined services..."

# Run the audit command
unconfined_processes=$(ps -eZ | grep unconfined_service_t)

# Check if unconfined processes are found
if [ -z "$unconfined_processes" ]; then
  echo "Audit Passed: No unconfined services found."
  exit 0
else
  echo "Audit Failed: Unconfined services detected."
  echo "$unconfined_processes"
  echo "Please investigate the unconfined processes found."
  echo "You may need to manually create or adjust SELinux policies if these are necessary services."
  exit 1
fi

### Script Explanation:
# - The script verifies that no processes are running in unconfined SELinux domains by executing the `ps` command and grepping for `unconfined_service_t`.
# - If no unconfined processes are found, the script outputs a pass message and exits with a status of `0`.
# - If unconfined processes are detected, it outputs a fail message along with the process details and advises manual SELinux policy adjustments, then exits with a status of `1`.