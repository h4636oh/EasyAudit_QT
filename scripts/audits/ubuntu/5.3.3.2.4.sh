#!/usr/bin/env bash

# Check maxrepeat settings in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf
maxrepeat_pwquality=$(grep -Psi -- '^\h*maxrepeat\h*=\h*[1-3]\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

if [[ -z "$maxrepeat_pwquality" ]]; then
  echo "No maxrepeat setting of 3 or less found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf."
else
  echo "Maxrepeat setting found in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf:"
  echo "$maxrepeat_pwquality"
  exit 1
fi

# Check if maxrepeat is set to 0, greater than 3, or conforms to local site policy in /etc/pam.d/common-password
maxrepeat_common_password=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?maxrepeat\h*=\h*(0|[4-9]|[1-9][0-9]+)\b' /etc/pam.d/common-password)

if [[ -z "$maxrepeat_common_password" ]]; then
  echo "No invalid maxrepeat setting found in /etc/pam.d/common-password. Configuration is correct."
else
  echo "Invalid maxrepeat setting found in /etc/pam.d/common-password:"
  echo "$maxrepeat_common_password"
  exit 1
fi

