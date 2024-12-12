#!/usr/bin/env bash

# Verify the Banner setting in the SSH configuration
banner_output=$(sshd -T | grep -Pi -- '^banner\h+\/\H+')

if [ -z "$banner_output" ]; then
  echo "FAIL: Banner is not set in the SSH configuration."
  exit 1
else
  echo "PASS: Banner is set to $banner_output."
  exit 0
fi

# Example: Checking for a specific user (e.g., sshuser) in a Match block
match_user_banner_output=$(sshd -T -C user=sshuser | grep -Pi -- '^banner\h+\/\H+')

if [ -z "$match_user_banner_output" ]; then
  echo "FAIL: Banner is not set for user sshuser."
  exit 1
else
  echo "PASS: Banner is set for user sshuser to $match_user_banner_output."
  exit 0
fi
