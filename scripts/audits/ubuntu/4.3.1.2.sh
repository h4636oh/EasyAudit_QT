#!/usr/bin/env bash

# Check if nftables is installed
if dpkg-query -s nftables &>/dev/null; then
  echo "nftables is installed"
else
  echo "nftables is not installed"
  exit 1
fi

