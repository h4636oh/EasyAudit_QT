#!/usr/bin/env bash

# Check maxsequence settings in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf
maxsequence_pwquality=$(grep -Psi -- '^\h*maxsequence\h*=\h*[1-3]\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

if [[ -z "$maxsequence_pwquality" ]]; then
  echo "No maxsequence setting of 3 or less found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf."
else
  echo "Maxsequence setting found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf:"
  echo "$maxsequence_pwquality"
  exit 1
fi

# Check if maxsequence is set to 0, greater than 3, or conforms to local site policy in /etc/pam.d/common-password
maxsequence_common_password=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?maxsequence\h*=\h*(0|[4-9]|[1-9][0-9]+)\b' /etc/pam.d/common-password)

if [[ -z "$maxsequence_common_password" ]]; then
  echo "No invalid maxsequence setting found in /etc/pam.d/common-password. Configuration is correct."
else
  echo "Invalid maxsequence setting found in /etc/pam.d/common-password:"
  echo "$maxsequence_common_password"
  exit 1
fi

