#!/usr/bin/env bash

# Check for weak Key Exchange algorithms
weak_kex_algorithms=$(sshd -T | grep -Pi -- 'kexalgorithms\h+([^#\n\r]+,)?(diffie-hellman-group1-sha1|diffie-hellman-group14-sha1|diffie-hellman-group-exchange-sha1)\b')

if [[ -z "$weak_kex_algorithms" ]]; then
  echo "No weak Key Exchange algorithms are being used."
else
  echo "Weak Key Exchange algorithms found:"
  echo "$weak_kex_algorithms"
  exit 1
fi

