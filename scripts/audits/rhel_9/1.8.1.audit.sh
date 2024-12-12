#!/bin/bash

# Description: Audit script to ensure GNOME Display Manager (GDM) is removed.
# If a Graphical User Interface (GUI) is not required, it should be removed to reduce the attack surface of the system.

# Function: Audit whether the 'gdm' package is installed
audit_gdm() {
    if rpm -q gdm &> /dev/null; then
        # If the package is found, the audit fails
        echo "Audit Failed: The GNOME Display Manager (gdm) package is still installed."
        echo "Please consider removing the package using the following command:"
        echo "# dnf remove gdm"
        exit 1
    else
        # If the package is not found, the audit passes
        echo "Audit Passed: The GNOME Display Manager (gdm) package is not installed."
        exit 0
    fi
}

# Call the audit function
audit_gdm
