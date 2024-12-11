
#!/bin/bash

# Audit script to check the settings of even_deny_root and root_unlock_time in faillock configuration.
# This script does not perform any remediation actions, it only checks and reports the status.

# Function to check even_deny_root and root_unlock_time in /etc/security/faillock.conf
check_faillock_conf() {
  grep -Pi '^\s*(even_deny_root|root_unlock_time\s*=\s*\d+)\b' /etc/security/faillock.conf
}

# Function to verify root_unlock_time is set to 60 or more if it is defined in /etc/security/faillock.conf
check_root_unlock_time_in_faillock_conf() {
  grep -Pi '^\s*root_unlock_time\s*=\s*([1-9]|[1-5][0-9])\b' /etc/security/faillock.conf
}

# Function to verify root_unlock_time in pam_faillock.so module
check_pam_faillock_root_unlock_time() {
  grep -Pi '^\s*auth\s+([^#\n\r]+\s+)?pam_faillock\.so\s+([^#\n\r]+\s+)?root_unlock_time\s*=\s*([1-9]|[1-5][0-9])\b' /etc/pam.d/system-auth /etc/pam.d/password-auth
}

# Main audit logic
echo "Auditing faillock configuration for even_deny_root and root_unlock_time settings..."

faillock_result=$(check_faillock_conf)
root_time_faillock_conf_result=$(check_root_unlock_time_in_faillock_conf)
root_time_pam_result=$(check_pam_faillock_root_unlock_time)

if [[ -z "$faillock_result" ]]; then
  echo "even_deny_root and/or root_unlock_time not found in /etc/security/faillock.conf"
  exit 1
elif [[ -n "$root_time_faillock_conf_result" ]]; then
  echo "root_unlock_time is set to less than 60 in /etc/security/faillock.conf"
  exit 1
elif [[ -n "$root_time_pam_result" ]]; then
  echo "root_unlock_time is set to less than 60 in PAM configuration for pam_faillock.so"
  exit 1
else
  echo "Auditing passed: even_deny_root and root_unlock_time are configured correctly."
  exit 0
fi
```

