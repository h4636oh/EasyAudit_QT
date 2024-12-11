#!/bin/bash

# This script audits the grub2 configuration to ensure that auditing for processes
# that start prior to auditd is enabled by checking for the 'audit=1' parameter.

# Function to check if 'audit=1' is set in grubby
check_grubby() {
    grubby --info=ALL | grep -Po '\baudit=1\b' &>/dev/null
    return $?
}

# Function to check if 'audit=1' is set in /etc/default/grub
check_grub_default() {
    grep -Psoi -- '^\h*GRUB_CMDLINE_LINUX="([^#\n\r]+\h+)?audit=1\b' /etc/default/grub &>/dev/null
    return $?
}

# Check grubby
check_grubby
grubby_status=$?

# Check /etc/default/grub
check_grub_default
grub_default_status=$?

# Determine the audit result and output appropriate message
if [ $grubby_status -eq 0 ] && [ $grub_default_status -eq 0 ]; then
    echo "Audit Successful: 'audit=1' is correctly set in both grubby and /etc/default/grub."
    exit 0
else
    echo "Audit Failed: 'audit=1' is not set correctly."
    echo "Please ensure 'audit=1' is added to the kernel parameters."
    echo "Check '/etc/default/grub' for 'GRUB_CMDLINE_LINUX' line."
    exit 1
fi
```

This script will audit whether the `audit=1` parameter is present in both the grubby bootloader configuration and the `/etc/default/grub` file. It checks for the presence of the parameter using `grubby` and `grep`. The script will prompt the user to manually verify or update the grub configuration if the audit fails. It exits with appropriate status codes based on the audit results.