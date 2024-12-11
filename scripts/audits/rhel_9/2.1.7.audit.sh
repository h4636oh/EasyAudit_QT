#!/bin/bash

# Audit script to verify that FTP server services are not in use.

# Check if vsftpd package is installed
if rpm -q vsftpd &>/dev/null; then
    echo "vsftpd package is installed."
    
    # Check if vsftpd.service is enabled
    if systemctl is-enabled vsftpd.service &>/dev/null; then
        echo "vsftpd.service is enabled. Please ensure this is in line with local site policies."
        exit 1
    fi

    # Check if vsftpd.service is active
    if systemctl is-active vsftpd.service &>/dev/null; then
        echo "vsftpd.service is active. Please ensure this is in line with local site policies."
        exit 1
    fi
    
    echo "vsftpd package is installed but service is not enabled or active."
    echo "Please manually review dependencies and ensure this meets local site policy."
else
    echo "vsftpd package is not installed."
fi

# Note the potential existence of other FTP server packages
echo "Please ensure no other FTP server packages are installed or enabled unless required and approved by site policy."

exit 0

# This script audits whether the vsftpd package and its associated service are installed, enabled, or active. If any checks fail, the script exits with a status of 1, indicating a failed audit. It also instructs the user to ensure compliance with local policies and to check other FTP server packages.