#!/bin/bash

# Ensure the script exits if a command fails
set -e

echo "Audit: Checking for available updates or patches..."

# Run the dnf check-update command to list available updates
dnf check-update

# Check the exit status of the previous command
if [[ $? -ne 100 ]]; then
    # If the exit status is not 100, then no updates are available
    echo "No updates or patches are available."
else
    # If the exit status is 100, updates are available
    echo "Updates or patches are available, manual intervention required."
    echo "Please review the list of available updates above."
    exit 1
fi

echo "Audit: Checking if system reboot is required..."

# Run dnf needs-restarting -r to check if a reboot is required
dnf needs-restarting -r

# Check the exit status again to determine reboot requirement
if [[ $? -eq 0 ]]; then
    echo "No system reboot is required."
    exit 0
else
    echo "System reboot is required. Please plan for a reboot."
    exit 1
fi

### Key Points:

# - **Script Functionality**: The script uses `dnf check-update` to audit available updates and checks if any patches are pending. It also checks if a reboot is necessary using `dnf needs-restarting -r`.

# - **Exit Codes**: The script exits with `1` if updates are available or if a reboot is required, ensuring it properly signals a failed audit if manual action is needed. If no updates are available and no reboot is needed, it exits with `0`.

# - **Manual Intervention**: Users are prompted to manually review updates if any are found or plan a reboot if required.