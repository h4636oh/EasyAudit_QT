#!/usr/bin/env bash

echo "Auditing sudo configuration for use of pseudo terminal (PTY)..."

# Check for 'Defaults use_pty' in sudoers and sudoers.d
use_pty_output=$(grep -rPi '^\h*Defaults\h+([^#\n\r]+,)?use_pty(,\h*\h+\h*)*\h*(#.*)?$' /etc/sudoers*)

# Verify if 'Defaults use_pty' is correctly set
if [[ "$use_pty_output" == *"/etc/sudoers:Defaults use_pty"* ]]; then
    echo "Audit passed: 'Defaults use_pty' is correctly set."
else
    echo "Audit failed: 'Defaults use_pty' is not set or incorrectly configured."
    echo "Current output:"
    echo "$use_pty_output"
    exit 1
fi

# Check for 'Defaults !use_pty' to ensure it is not set
no_use_pty_output=$(grep -rPi '^\h*Defaults\h+([^#\n\r]+,)?!use_pty(,\h*\h+\h*)*\h*(#.*)?$' /etc/sudoers*)

# Verify that 'Defaults !use_pty' is not set
if [[ -z "$no_use_pty_output" ]]; then
    echo "Audit passed: 'Defaults !use_pty' is not set."
else
    echo "Audit failed: 'Defaults !use_pty' is set. Found the following:"
    echo "$no_use_pty_output"
    exit 1
fi