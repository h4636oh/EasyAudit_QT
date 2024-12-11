
#!/bin/bash

# This script audits the active authselect profile to ensure it includes the required pam modules.
# It checks for the presence of pam_pwquality.so, pam_pwhistory.so, pam_faillock.so, and pam_unix.so,
# and outputs appropriate messages based on the audit result.
# The script exits with 0 if the audit passes and 1 if the audit fails.

# Define the active profile file
AUTHSELECT_CONF="/etc/authselect/authselect.conf"

# Verify the authselect configuration file exists
if [[ ! -f "$AUTHSELECT_CONF" ]]; then
  echo "Error: Authselect configuration file not found at $AUTHSELECT_CONF."
  exit 1
fi

# Get the active profile name
ACTIVE_PROFILE=$(head -1 "$AUTHSELECT_CONF")

# Define the path for the profile to verify
PROFILE_PATH="/etc/authselect/$ACTIVE_PROFILE"

# Verify the active profile directory exists
if [[ ! -d "$PROFILE_PATH" ]]; then
  echo "Error: Active authselect profile directory not found at $PROFILE_PATH."
  exit 1
fi

# Modules to check within the authselect profile
declare -a REQUIRED_MODULES=("pam_pwquality.so" "pam_pwhistory.so" "pam_faillock.so" "pam_unix.so")

# Initializing fail flag
fail_flag=0

# Check each required module
for module in "${REQUIRED_MODULES[@]}"; do
  if ! grep -qP -- "\\b${module}\\b" "$PROFILE_PATH/system-auth" "$PROFILE_PATH/password-auth"; then
    echo "Module $module is missing from the authselect profile."
    fail_flag=1
  fi
done

# Provide audit result based on findings
if [[ $fail_flag -eq 1 ]]; then
  echo "Audit Failed: Not all required pam modules are present in the authselect profile."
  exit 1
else
  echo "Audit Passed: All required pam modules are present in the authselect profile."
  exit 0
fi
```

This script checks if the active authselect profile includes the specified PAM modules by searching specific configuration files for corresponding entries, following the specifications given. It logs the missing modules and then exits with a non-zero status if the audit does not pass.