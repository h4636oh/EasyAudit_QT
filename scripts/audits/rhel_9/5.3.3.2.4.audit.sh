
#!/bin/bash

# Audit script for checking 'maxrepeat' setting regarding password complexity.
# Assumptions: 
# 1. maxrepeat value should be 3 or less and not 0.
# 2. Only audit, no remediation will be performed.

# Function to display manual inspection message
manual_check() {
    echo "Please manually ensure that the 'maxrepeat' value conforms to your local site policy."
}

# Check if 'maxrepeat' is set to 3 or less in pwquality.conf or conf.d directory
config_check=$(grep -Psi -- '^\h*maxrepeat\h*=\h*[1-3]\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

# Verify if any disallowed 'maxrepeat' settings exist in PAM files
pam_check=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?maxrepeat\h*=\h*(0|[4-9]|[1-9][0-9]+)\b' /etc/pam.d/system-auth /etc/pam.d/password-auth)

# Determine the exit status based on the audit check results
if [[ -n "$config_check" && -z "$pam_check" ]]; then
    echo "Audit Passed: 'maxrepeat' is configured correctly."
    manual_check
    exit 0
else
    echo "Audit Failed: 'maxrepeat' is not configured correctly or PAM files contain disallowed settings."
    manual_check
    exit 1
fi
```

