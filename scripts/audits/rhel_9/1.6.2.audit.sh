#!/bin/bash

# Title: 1.6.2 Ensure system wide crypto policy is not set in sshd configuration (Automated)
# Description: Audit script to check if system-wide crypto policy is overridden in sshd configuration
# Profile Applicability: Level 1 - Server, Level 1 - Workstation

# Define the file to be checked
CONFIG_FILE="/etc/sysconfig/sshd"

# Run the audit command
output=$(grep -Pi '^\h*CRYPTO_POLICY\h*=' "$CONFIG_FILE")

# Check the result
if [ -z "$output" ]; then
  echo "PASS: No system-wide crypto policy is set in $CONFIG_FILE."
  exit 0
else
  echo "FAIL: System-wide crypto policy overrides detected in $CONFIG_FILE."
  echo "Manual Action Required: Please review the file and comment out any CRYPTO_POLICY settings."
  exit 1
fi

### Script Explanation:
# - **Logical Flow**: The script checks whether the `CRYPTO_POLICY` is set in `/etc/sysconfig/sshd`. If nothing is detected, it exits with a status of 0 (pass). If any setting is detected, it exits with status 1 (fail) and prompts manual intervention.
# - **Commands Used**:
#   - `grep -Pi '^\\h*CRYPTO_POLICY\\h*=' /etc/sysconfig/sshd`: Searches for lines that might configure `CRYPTO_POLICY` in the target config file.
#   - `-P`: Enables Perl-compatible regex, allowing us to use `\h` for horizontal whitespace.
#   - `-i`: Makes the search case-insensitive.
# - **Assumptions**: 
#   - The configuration file location `/etc/sysconfig/sshd` is valid and accessible.
#   - The script doesn't perform any remediation but suggests a manual review instead.