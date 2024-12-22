#!/usr/bin/env bash

# Check if ENCRYPT_METHOD is set to SHA512 or yescrypt in /etc/login.defs
encrypt_method=$(grep -Pi -- '^\h*ENCRYPT_METHOD\h+(SHA512|yescrypt)\b' /etc/login.defs)

if [[ -z "$encrypt_method" ]]; then
  echo "ENCRYPT_METHOD is not set to SHA512 or yescrypt in /etc/login.defs."
else
  echo "ENCRYPT_METHOD setting found in /etc/login.defs:"
  echo "$encrypt_method"
fi

