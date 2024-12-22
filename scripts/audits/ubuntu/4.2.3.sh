#!/usr/bin/env bash

# Function to check if there are no rules
check_rules() {
  local table="$1"
  local rules
  rules=$(eval "$table -L")

  if [[ -z "$rules" || "$rules" == "Chain INPUT (policy ACCEPT)"* && "$rules" == "Chain FORWARD (policy ACCEPT)"* && "$rules" == "Chain OUTPUT (policy ACCEPT)"* ]]; then
    echo "No $table rules found"
  else
    echo "$table rules found:"
    echo "$rules"
    exit 1
  fi
}

# Check iptables rules
check_rules "iptables"

# Check ip6tables rules
check_rules "ip6tables"

