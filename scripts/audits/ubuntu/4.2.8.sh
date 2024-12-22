#!/bin/bash

echo "Auditing nftables base chain policies..."

# Function to check a specific chain for DROP policy
check_chain_policy() {
    local chain_name=$1
    local chain_policy=$(sudo nft list ruleset | grep "hook $chain_name")
    
    if [[ $chain_policy =~ "policy drop" ]]; then
        echo "PASS: Base chain '$chain_name' has a policy of DROP."
    else
        echo "FAIL: Base chain '$chain_name' does not have a policy of DROP."
        echo "Current policy: $chain_policy"
        exit 1
    fi
}

# Check base chains
check_chain_policy "input"
check_chain_policy "forward"
check_chain_policy "output"

echo "Audit completed."
