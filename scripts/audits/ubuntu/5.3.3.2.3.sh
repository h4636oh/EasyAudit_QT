#!/usr/bin/env bash

# Check dcredit, ucredit, lcredit, ocredit, and minclass settings
pwquality_settings=$(grep -Psi -- '^\h*(minclass|[dulo]credit)\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

if [[ -z "$pwquality_settings" ]]; then
  echo "No minclass or credit settings found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf."
else
  echo "Settings found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf:"
  echo "$pwquality_settings"
  exit 1
fi

# Verify that module arguments are not overridden in /etc/pam.d/common-password
overrides=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?(minclass=\d*|[dulo]credit=-?\d*)\b' /etc/pam.d/common-password)

if [[ -z "$overrides" ]]; then
  echo "No overriding module arguments found in /etc/pam.d/common-password. Configuration is correct."
else
  echo "Overriding module arguments found in /etc/pam.d/common-password:"
  echo "$overrides"
  exit 1
fi

