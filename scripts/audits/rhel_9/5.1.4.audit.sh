#!/bin/bash

# This script audits SSH configuration to ensure only strong ciphers are being used.

# Command to check current SSH ciphers
audit_command='sshd -T | grep -Pi "^ciphers\\h+\"?([^#\\n\\r]+,)?((3des|blowfish|cast128|aes(128|192|256))-cbc|arcfour(128|256)?|rijndael-cbc@lysator\\.liu\\.se|chacha20-poly1305@openssh\\.com)\\"'

# Execute the audit command

output=$(eval $audit_command)

# Check if the output contains any weak ciphers
if [[ -n $output ]]; then
    echo "Weak ciphers found in SSH configuration: $output"
    echo "Please review the ciphers and ensure only strong ciphers are configured."
    echo "Reference CVE-2023-48795 if chacha20-poly1305@openssh.com is present."
    exit 1
else
    echo "No weak ciphers found in SSH configuration."
    exit 0
fi
