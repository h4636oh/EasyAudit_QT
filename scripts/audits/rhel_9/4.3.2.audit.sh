#!/bin/bash

# Description: Audit script to verify whether nftables is configured for established connections.
# The script checks if nftables is in use and whether the firewall rules match the specified policy.
# Note: If firewalld is in use, skip this audit.
# Exit 0 if the audit passes, 1 if it fails.

# Check if firewalld is active
if systemctl is-active --quiet firewalld; then
  echo "Firewalld is active. This audit can be skipped."
  exit 0
fi

# Check if nftables is enabled
if ! systemctl is-enabled nftables.service &>/dev/null; then
  echo "NFTables service is not enabled. Please enable it if you intend to use it."
  exit 1
fi

# Extract the rules from nftables to verify established connections
nft_output=$(nft list ruleset | awk '/hook input/,/}/' | grep 'ct state')

# Define the expected rules for established connections
expected_rules=(
  "ip protocol tcp ct state established accept"
  "ip protocol udp ct state established accept"
  "ip protocol icmp ct state established accept"
)

# Function to check if nftables rules match the expected ones
function verify_rules {
  for rule in "${expected_rules[@]}"; do
    if ! echo "$nft_output" | grep -q "$rule"; then
      echo "Rule '$rule' is missing or does not match site policy."
      exit 1
    fi
  done
  echo "All nftables rules for established connections are correctly configured."
}

# Run the verification
verify_rules

# Exit with success status
exit 0