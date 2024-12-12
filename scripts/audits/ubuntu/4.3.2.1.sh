#!/bin/bash

# Function to check if the chain policy is DROP or REJECT
check_chain_policy() {
    local chain_name=$1
    local policy=$(iptables -L $chain_name -n | head -n 1 | awk '{print $4}')
    
    if [[ $policy == "DROP" || $policy == "REJECT" ]]; then
        echo "PASS: $chain_name chain policy is set to $policy."
    else
        echo "FAIL: $chain_name chain policy is not DROP or REJECT. Current policy: $policy"
    fi
}

check_chain_policy "INPUT"
check_chain_policy "FORWARD"
check_chain_policy "OUTPUT"