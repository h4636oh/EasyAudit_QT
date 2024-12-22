#!/usr/bin/env bash

# Check if enforcing=0 is set in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf
enforcing_pwquality=$(grep -PHsi -- '^\h*enforcing\h*=\h*0\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

if [[ -z "$enforcing_pwquality" ]]; then
  echo "No enforcing=0 setting found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf. Configuration is correct."
else
  echo "Enforcing=0 setting found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf:"
  echo "$enforcing_pwquality"
  exit 1
fi

# Check if enforcing=0 is set as a module argument in /etc/pam.d/common-password
enforcing_common_password=$(grep -PHsi -- '^\h*password\h+[^#\n\r]+\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?enforcing=0\b' /etc/pam.d/common-password)

if [[ -z "$enforcing_common_password" ]]; then
  echo "No enforcing=0 setting found in /etc/pam.d/common-password. Configuration is correct."
else
  echo "Enforcing=0 setting found in /etc/pam.d/common-password:"
  echo "$enforcing_common_password"
  exit 1
fi

