#!/bin/bash

# This script audits the SSH key exchange algorithms to ensure no weak algorithms are used.
# It checks against a list of known weak key exchange algorithms.

# List of weak key exchange algorithms
weak_kex_algos=(
    "diffie-hellman-group1-sha1"
    "diffie-hellman-group14-sha1"
    "diffie-hellman-group-exchange-sha1"
)

# Run the command to check the current SSH key exchange algorithms
kex_check=$(sshd -T | grep -Pi -- 'kexalgorithms\s+([^#\n\r]+,)?(diffie-hellman-group1-sha1|diffie-hellman-group14-sha1|diffie-hellman-group-exchange-sha1)\b')

# Determine whether weak algorithms are present
if [[ -n "$kex_check" ]]; then
    echo "Audit Failed: Weak Key Exchange Algorithms are present:"
    echo "$kex_check"
    exit 1
else
    echo "Audit Passed: No Weak Key Exchange Algorithms are found."
    exit 0
fi

# Note for auditors:
# - Ensure that key exchange algorithms comply with your site policy.
# - This script assumes `sshd` is configured correctly in your PATH and the command can successfully return configuration.
# - Manually review and compare your system configuration against this audit in case of unexpected results. 

