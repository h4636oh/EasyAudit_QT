#!/bin/bash

# Check password complexity settings in /etc/security/pwquality.conf and .conf files
if grep -Psi -- '^\h*(minclass|[dulo]credit)\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf; then
  echo "Password complexity settings found in /etc/security/pwquality.conf or /etc/security/pwquality.conf.d/*.conf."
else
  echo "Password complexity settings NOT found in /etc/security/pwquality.conf or /etc/security/pwquality.conf.d/*.conf."
  exit 1
fi

# Verify that minclass is set to 4 or more
if grep -Psi -- '^\h*minclass\s*=\s*([0-3])\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf; then
  echo "minclass is set to less than 4 in /etc/security/pwquality.conf or .conf files."
  exit 1
fi

# Verify that dcredit, ucredit, lcredit, ocredit are not set to 0 or greater
if grep -Psi -- '^\h*(dcredit|ucredit|lcredit|ocredit)\s*=\s*([0-9])\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf; then
  echo "dcredit, ucredit, lcredit, or ocredit is set to 0 or greater in /etc/security/pwquality.conf or .conf files."
  exit 1
fi

# Check password complexity settings in PAM configuration files
if grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?(minclass=[0-3]|[dulo]credit=[^-]\d*)\b' /etc/pam.d/system-auth /etc/pam.d/password-auth; then
  echo "Password complexity settings are incorrectly configured in /etc/pam.d/system-auth or /etc/pam.d/password-auth."
  exit 1
fi

# If all checks pass
echo "Audit passed: Password complexity is correctly configured."
exit 0
