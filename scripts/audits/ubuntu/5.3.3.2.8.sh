#!/usr/bin/env bash

# Check if enforce_for_root is enabled in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf
enforce_for_root_setting=$(grep -Psi -- '^\h*enforce_for_root\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

if [[ -z "$enforce_for_root_setting" ]]; then
  echo "enforce_for_root setting not found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf. Please enable it to ensure the configuration is correct."
else
  echo "enforce_for_root setting found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf:"
  echo "$enforce_for_root_setting"
  exit 1
fi

