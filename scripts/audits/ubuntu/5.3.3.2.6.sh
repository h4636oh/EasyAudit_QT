#!/usr/bin/env bash

# Check dictcheck setting in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf
dictcheck_pwquality=$(grep -Psi -- '^\h*dictcheck\h*=\h*0\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

if [[ -z "$dictcheck_pwquality" ]]; then
  echo "No dictcheck setting of 0 found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf. Configuration is correct."
else
  echo "Dictcheck setting of 0 found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf:"
  echo "$dictcheck_pwquality"
  exit 1
fi

# Check dictcheck setting as a module argument in /etc/pam.d/common-password
dictcheck_common_password=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?dictcheck\h*=\h*0\b' /etc/pam.d/common-password)

if [[ -z "$dictcheck_common_password" ]]; then
  echo "No dictcheck setting of 0 found in /etc/pam.d/common-password. Configuration is correct."
else
  echo "Dictcheck setting of 0 found in /etc/pam.d/common-password:"
  echo "$dictcheck_common_password"
  exit 1
fi

