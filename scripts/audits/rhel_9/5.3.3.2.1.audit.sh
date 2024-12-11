#!/bin/bash

# Check difok value in /etc/security/pwquality.conf and .conf files
if grep -Psi -- '^\h*difok\h*=\h*([2-9]|[1-9][0-9]+)\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf; then
  echo "difok is set to 2 or more in /etc/security/pwquality.conf or /etc/security/pwquality.conf.d/*.conf."
else
  echo "difok is NOT set to 2 or more in /etc/security/pwquality.conf or /etc/security/pwquality.conf.d/*.conf."
  exit 1
fi

# Check difok in PAM configuration files
if grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?difok\h*=\h*([0-1])\b' /etc/pam.d/system-auth /etc/pam.d/password-auth; then
  echo "difok is set incorrectly in /etc/pam.d/system-auth or /etc/pam.d/password-auth."
  exit 1
else
  echo "difok is not set incorrectly in /etc/pam.d/system-auth or /etc/pam.d/password-auth."
fi

# If all checks pass
echo "Audit passed: difok is correctly configured."
exit 0
