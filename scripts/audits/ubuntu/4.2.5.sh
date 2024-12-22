#!/usr/bin/env bash

# Function to check for base chains
check_base_chain() {
  local chain="$1"
  local result

  result=$(nft list ruleset | grep "hook $chain")

  if [[ -n "$result" ]]; then
    echo "Base chain for $chain exists:"
    echo "$result"
  else
    echo "Base chain for $chain does not exist."
    exit 1
  fi
}

# Check base chains for INPUT, FORWARD, and OUTPUT
check_base_chain "input"
check_base_chain "forward"
check_base_chain "output"

