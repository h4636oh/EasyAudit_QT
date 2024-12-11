
#!/bin/bash

# 5.3.3.2.2 Ensure password length is configured (Automated)
# This script audits the password minimum length settings.
# It ensures that passwords have a minimum length of 14 characters as per the policy.

# Function to check password minimum length in configuration files
check_password_minlen() {
    # Search for minlen setting in pwquality.conf and associated directories
    grep -Psi -- '^\h*minlen\h*=\h*(1[4-9]|[2-9][0-9]|[1-9][0-9]{2,})\b' \
    /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf

    if [[ $? -ne 0 ]]; then
        echo "Audit Failed: minlen is not set to 14 or more in /etc/security/pwquality.conf and associated files."
        exit 1
    fi
}

# Function to check for overriding minlen settings in PAM files
check_pam_minlen() {
    # Verify minlen is not incorrectly set in PAM configuration files
    grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+)?\h+minlen\h*=\h*([0-9]|1[0-3])\b' \
    /etc/pam.d/system-auth /etc/pam.d/password-auth

    if [[ $? -eq 0 ]]; then
        echo "Audit Failed: minlen is set to less than 14 in pam_pwquality.so module in PAM files."
        exit 1
    fi
}

# Check the pwquality configuration
check_password_minlen

# Check the PAM configuration for unwanted minlen settings
check_pam_minlen

# If both checks pass
echo "Audit Passed: Password minimum length is properly configured."
exit 0
```

This script performs the following tasks:

1. **Checks the `minlen` setting** in the `/etc/security/pwquality.conf` and the `.conf` files in `/etc/security/pwquality.conf.d/`. It ensures that the password minimum length is set to 14 or more characters.

2. **Checks for the presence** of a `minlen` setting in the `pam_pwquality.so` module within the `/etc/pam.d/system-auth` and `/etc/pam.d/password-auth` files, ensuring it is not set to less than 14 characters.

3. **Exits with status `1`** if any of the checks fail, and `0` if all checks pass, as per the audit requirements.