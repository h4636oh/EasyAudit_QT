#!/bin/bash

# Check if AppArmor parameters are already present
if ! grep -q 'apparmor=1 security-apparmor' /etc/default/grub; then
    # Add AppArmor parameters to GRUB_CMDLINE_LINUX
    sed -i 's/GRUB_CMDLINE_LINUX=".*"/GRUB_CMDLINE_LINUX="apparmor=1 security-apparmor"/' /etc/default/grub

    # Update GRUB configuration
    update-grub
    echo "AppArmor parameters added to GRUB_CMDLINE_LINUX and GRUB configuration updated."
else
    echo "AppArmor parameters already present in GRUB_CMDLINE_LINUX."
fi
