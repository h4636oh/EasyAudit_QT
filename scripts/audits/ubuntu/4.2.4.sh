#!/usr/bin/env bash

# Check if nftables table exists
nft_tables=$(nft list tables 2>/dev/null)

if [[ -z "$nft_tables" ]]; then
  echo "No nftables tables found."
else
  echo "nftables tables found:"
  echo "$nft_tables"
  exit 1
fi

