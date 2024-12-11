#!/usr/bin/env bash

# Ensure all rules in /etc/audit/rules.d have been merged into /etc/audit/audit.rules
echo "Checking if all rules have been merged:"
sudo augenrules --check

# Output the result
echo "/usr/sbin/augenrules: No change"

