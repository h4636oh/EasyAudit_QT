
#!/usr/bin/env bash

# The script audits the permissions of the audit log directory based on the configuration in /etc/audit/auditd.conf.
# It checks if the directory permissions are mode 0750 or more restrictive.
# If the audit fails, the script exits with status 1.
# If the audit passes, it exits with status 0.

l_perm_mask="0027"

# Check if auditd configuration file exists
if [ -e "/etc/audit/auditd.conf" ]; then
    # Extract the directory of the log file
    l_audit_log_directory="$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' /etc/audit/auditd.conf | xargs)")"
    
    # Check if the extracted path is a directory
    if [ -d "$l_audit_log_directory" ]; then
        # Calculate the maximum permissible file mode
        l_maxperm="$(printf '%o' $(( 0777 & ~$l_perm_mask )) )"
        l_directory_mode="$(stat -Lc '%#a' "$l_audit_log_directory")"
        
        # Compare current directory mode with required criteria
        if [ $(( $l_directory_mode & $l_perm_mask )) -gt 0 ]; then
            echo -e "\n- Audit Result:\n ** FAIL **\n - Directory: \"$l_audit_log_directory\" is mode: \"$l_directory_mode\" (should be mode: \"$l_maxperm\" or more restrictive)\n"
            exit 1
        else
            echo -e "\n- Audit Result:\n ** PASS **\n - Directory: \"$l_audit_log_directory\" is mode: \"$l_directory_mode\" (should be mode: \"$l_maxperm\" or more restrictive)\n"
            exit 0
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Log file directory not set in \"/etc/audit/auditd.conf\" please set log file directory\n"
        exit 1
    fi
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - File: \"/etc/audit/auditd.conf\" not found\n - ** Verify auditd is installed **\n"
    exit 1
fi
```
