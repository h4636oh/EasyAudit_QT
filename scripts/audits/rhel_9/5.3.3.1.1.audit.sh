
#!/bin/bash

# Script to audit password failed attempts lockout configuration

# Function to audit /etc/security/faillock.conf
audit_faillock_conf() {
    local faillock_setting
    faillock_setting=$(grep -Pi -- '^\h*deny\h*=\h*[1-5]\b' /etc/security/faillock.conf)

    if [[ -z "$faillock_setting" ]]; then
        echo "Audit failed: /etc/security/faillock.conf deny parameter is not set properly."
        return 1
    else
        echo "Audit passed: /etc/security/faillock.conf deny parameter is set correctly."
        return 0
    fi
}

# Function to audit PAM configuration files
audit_pam_files() {
    local pam_output
    pam_output=$(grep -Pi -- '^\h*auth\h+(requisite|required|sufficient)\h+pam_faillock\.so\h+([^#\n\r]+\h+)?deny\h*=\h*(0|[6-9]|[1-9][0-9]+)\b' /etc/pam.d/system-auth /etc/pam.d/password-auth)

    if [[ -n "$pam_output" ]]; then
        echo "Audit failed: Deny parameter in PAM files should not be set or set incorrectly."
        return 1
    else
        echo "Audit passed: No incorrect deny parameter found in PAM files."
        return 0
    fi
}

# Run both audit functions
audit_faillock_conf
faillock_result=$?

audit_pam_files
pam_result=$?

# Exit with appropriate status
if [[ $faillock_result -eq 0 && $pam_result -eq 0 ]]; then
    exit 0
else
    exit 1
fi
```

### Explanation:
- The script includes two functions to audit specific configurations:
  1. `audit_faillock_conf` checks that the `deny` parameter in `/etc/security/faillock.conf` is between 1 and 5, as per guidelines.
  2. `audit_pam_files` ensures that any `deny` parameter in PAM configuration files (`/etc/pam.d/system-auth` and `/etc/pam.d/password-auth`) are not incorrectly set to values other than 0 or values above 5 — ideally, no results should be returned.
- If both functions pass the audit, the script exits with `0`. If any checks fail, it exits with `1`.