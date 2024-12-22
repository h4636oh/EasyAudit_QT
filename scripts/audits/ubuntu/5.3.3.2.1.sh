#!/usr/bin/env bash

# Check if difok is set to 2 or more in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf
difok_pwquality=$(grep -Psi -- '^\h*difok\h*=\h*([2-9]|[1-9][0-9]+)\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

if [[ -z "$difok_pwquality" ]]; then
  echo "No difok setting of 2 or more found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf."
else
  echo "Difok setting found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf:"
  echo "$difok_pwquality"
  exit 1
fi

# Check if difok is set to less than 2 in /etc/pam.d/common-password
difok_common_password=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?difok\h*=\h*([0-1])\b' /etc/pam.d/common-password)

if [[ -z "$difok_common_password" ]]; then
  echo "No difok setting less than 2 found in /etc/pam.d/common-password. Configuration is correct."
else
  echo "Difok setting less than 2 found in /etc/pam.d/common-password:"
  echo "$difok_common_password"
fi

