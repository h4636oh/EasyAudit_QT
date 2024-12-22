#!/usr/bin/env bash

# Check if minlen is set to 14 or more in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf
minlen_pwquality=$(grep -Psi -- '^\h*minlen\h*=\h*(1[4-9]|[2-9][0-9]|[1-9][0-9]{2,})\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

if [[ -z "$minlen_pwquality" ]]; then
  echo "No minlen setting of 14 or more found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf."
else
  echo "Minlen setting found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf:"
  echo "$minlen_pwquality"
  exit 1
fi

# Check if minlen is set to less than 14 in /etc/pam.d/system-auth and /etc/pam.d/common-password
minlen_common_password=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?minlen\h*=\h*([0-9]|1[0-3])\b' /etc/pam.d/system-auth /etc/pam.d/common-password)

if [[ -z "$minlen_common_password" ]]; then
  echo "No minlen setting less than 14 found in /etc/pam.d/system-auth and /etc/pam.d/common-password. Configuration is correct."
else
  echo "Minlen setting less than 14 found in /etc/pam.d/system-auth and /etc/pam.d/common-password:"
  echo "$minlen_common_password"
  exit 1
fi

