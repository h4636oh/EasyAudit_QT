#!/bin/bash

# Description: Audit script to verify nftables base chain policy is set to DROP on systems using nftables.
# Exit 0 if the audit passes, exit 1 if it fails.

# Function to check if nftables service is enabled
check_nftables_service_enabled() {
    systemctl --quiet is-enabled nftables.service
    return $?
}

# Function to check nftables rules for base chain policy
check_nftables_policy() {
    local chain_hook="$1"
    nft list ruleset | grep "hook $chain_hook" | grep -v 'policy drop'
    return $?
}

# Main audit function
audit_nftables_policy() {
    # Check if nftables service is enabled
    if check_nftables_service_enabled; then
        # Check for hooks and ensure the policy is DROP
        if ! check_nftables_policy "input"; then
            echo "Audit failed: 'input' base chain is not set to policy DROP."
            return 1
        fi

        if ! check_nftables_policy "forward"; then
            echo "Audit failed: 'forward' base chain is not set to policy DROP."
            return 1
        fi

        echo "Audit passed: All nftables base chains have a policy of DROP."
        return 0
    else
        echo "nftables service is not enabled. Assuming the recommendation can be skipped."
        # It can exit 0 since this condition allows skipping recommendation as per provided text
        return 0
    fi
}

# Execute the audit
audit_nftables_policy
exit $?

