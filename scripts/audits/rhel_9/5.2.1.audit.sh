
#!/bin/bash

# 5.2.1 Ensure sudo is installed (Automated)
# This script audits whether sudo is installed on the system.
# It is applicable to Level 1 - Server and Level 1 - Workstation profiles.
# The script will exit with status 0 if sudo is installed, otherwise it exits with status 1.

# Function to check if sudo is installed
check_sudo_installed() {
    # Run the command to check sudo installation
    if dnf list sudo &>/dev/null; then
        echo "Audit Passed: sudo is installed."
        exit 0
    else
        echo "Audit Failed: sudo is not installed."
        echo "Manual Action: To remediate, please install sudo using the command: 'dnf install sudo'"
        exit 1
    fi
}

# Execute the check function
check_sudo_installed
```

