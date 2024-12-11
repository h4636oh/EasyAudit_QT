
#!/bin/bash

# Script to audit if pam_unix module is enabled as required

# Check the presence of pam_unix settings in both /etc/pam.d/password-auth and /etc/pam.d/system-auth

# Define function to check for pam_unix.so entries
audit_pam_unix_module() {
    local files=("/etc/pam.d/password-auth" "/etc/pam.d/system-auth")
    local expected_entries=(
        "auth sufficient pam_unix.so"
        "account required pam_unix.so"
        "password sufficient pam_unix.so sha512 shadow use_authtok"
        "session required pam_unix.so"
    )

    for file in "${files[@]}"; do
        for entry in "${expected_entries[@]}"; do
            if ! grep -Pq -- "\\b$entry\\b" "$file"; then
                echo "Audit failed: '$entry' not found in $file"
                return 1
            fi
        done
    done

    echo "All necessary pam_unix entries found. Audit passed."
    return 0
}

# Run the audit
audit_pam_unix_module
exit_status=$?

if [[ $exit_status -ne 0 ]]; then
    # Inform the user if manual remediation steps are needed
    echo "Some pam_unix entries are missing. Please refer to the documentation"
    echo "to update the authselect profile template files to include the pam_unix entries."
fi

# Exit with the appropriate status
exit $exit_status
```

This script audits the presence of the `pam_unix.so` module entries in `/etc/pam.d/password-auth` and `/etc/pam.d/system-auth`. If any required entries are missing, it suggests manual steps for remediation without modifying the system.