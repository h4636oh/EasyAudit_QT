
#!/bin/bash

# Script to audit the configuration of pam_pwquality module in /etc/pam.d/

# Variables
password_auth="/etc/pam.d/password-auth"
system_auth="/etc/pam.d/system-auth"

# Function to perform the audit
audit_pam_pwquality() {
  # Check if pam_pwquality.so is present in password-auth and system-auth
  grep -P -- '\bpam_pwquality\.so\b' "$password_auth" | grep -q 'requisite'
  local result1=$?

  grep -P -- '\bpam_pwquality\.so\b' "$system_auth" | grep -q 'requisite'
  local result2=$?

  # Check results and decide pass/fail
  if [ $result1 -eq 0 ] && [ $result2 -eq 0 ]; then
    echo "Audit Passed: pam_pwquality module is correctly configured in $password_auth and $system_auth."
    exit 0
  else
    if [ $result1 -ne 0 ]; then
      echo "Audit Failed: pam_pwquality module is missing or incorrect in $password_auth."
    fi

    if [ $result2 -ne 0 ]; then
      echo "Audit Failed: pam_pwquality module is missing or incorrect in $system_auth."
    fi

    exit 1
  fi
}

# Prompt user for manual verification
# echo "Please manually verify the following configuration in the authselect templates:"
# echo "1. The profile includes pam_pwquality.so lines in both password-auth and system-auth."
# echo "2. Ensure no lines include {include if \"with-pwquality\"}. If they do, use authselect to enable this feature."
# echo "3. If lines exist without {include if \"with-pwquality\"}, update the profile using authselect."

# Perform the audit
audit_pam_pwquality
```

