#!/usr/bin/env bash

# Run the command to check for weak ciphers
weak_ciphers=$(sshd -T | grep -Pi -- '^ciphers\h+"?([^#\n\r]+,)?((3des|blowfish|cast128|aes(128|192|256))-cbc|arcfour(128|256)?|rijndael-cbc@lysator\.liu\.se|chacha20-poly1305@openssh\.com)\b')

# If weak ciphers are found, print the result and exit with failure
if [ -n "$weak_ciphers" ]; then
  echo "FAIL: Weak ciphers are configured:"
  echo "$weak_ciphers"
  exit 1
else
  echo "PASS: No weak ciphers found in the SSH configuration."
  exit 0
fi
