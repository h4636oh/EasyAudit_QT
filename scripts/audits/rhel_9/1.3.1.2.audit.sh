#!/bin/bash

# Script to audit SELinux configuration in bootloader

# Function to perform the audit
audit_selinux() {
  # Run the audit command to check for SELinux or enforcing parameters set to 0 in GRUB boot configuration
  output=$(grubby --info=ALL | grep -Po '(selinux|enforcing)=0\b')

  # Check if the output is empty
  if [ -z "$output" ]; then
    echo "Audit Passed: SELinux is properly configured in the bootloader."
    exit 0
  else
    echo "Audit Failed: SELinux is not configured correctly in the bootloader."
    echo "Please remove 'selinux=0' or 'enforcing=0' from your GRUB configuration."
    exit 1
  fi
}

# Execute the audit function
audit_selinux

# This script verifies that SELinux is enabled and not overridden by GRUB boot parameters by checking that neither `selinux=0` nor `enforcing=0` is found in the current GRUB configurations. If the check passes, it outputs a success message and exits with code 0. If it finds any disabled configurations, it prompts the user to manually address them and exits with code 1.