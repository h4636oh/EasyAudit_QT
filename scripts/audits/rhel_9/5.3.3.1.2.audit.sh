
#!/bin/bash

# Audit script to ensure password unlock time is configured correctly
# This script checks the unlock_time setting in /etc/security/faillock.conf
# and verifies necessary settings in PAM configuration files.

# Define anticipated unlock_time setting
EXPECTED_UNLOCK_TIME="900"

# Check /etc/security/faillock.conf for unlock_time settings
faillock_config_check=$(grep -Pi -- '^\h*unlock_time\h*=\h*(0|9[0-9][0-9]|[1-9][0-9]{3,})\b' /etc/security/faillock.conf)

# Check PAM configuration files for unlock_time settings
pam_check=$(grep -Pi -- '^\h*auth\h+(requisite|required|sufficient)\h+pam_faillock\.so\h+([^\#\n\r]+\h+)?unlock_time\h*=\h*([1-9]|[1-9][0-9]|[1-8][0-9][0-9])\b' /etc/pam.d/system-auth /etc/pam.d/password-auth)

# Audit faillock.conf
if [[ -z $faillock_config_check ]]; then
  echo "Audit Failed: unlock_time not configured correctly in /etc/security/faillock.conf"
  exit 1
else
  echo "faillock.conf Check Passed: unlock_time is configured."
fi

# Audit PAM configuration
if [[ -z $pam_check ]]; then
  echo "PAM Check Passed: No incorrect unlock_time found in PAM files."
else
  echo "Audit Failed: Incorrect unlock_time found in PAM configuration files."
  exit 1
fi

# Prompt for manual action if necessary
echo "Manual Check Required: Verify local policies and adjust unlock_time setting if needed."

# If both checks passed, exit with success
exit 0
```