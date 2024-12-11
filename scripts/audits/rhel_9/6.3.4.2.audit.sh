
#!/usr/bin/env bash

# This script audits the permissions of audit log files to ensure they are mode 0640 or more restrictive.

# Define the expected permissions mask and initialize output variables
l_perm_mask="0177" # Permissions mask for mode more restrictive than 0640
l_output="" 
l_output2=""

# Check if auditd configuration file exists
if [ -e "/etc/audit/auditd.conf" ]; then
    # Extract the directory for audit log files from the configuration
    l_audit_log_directory="$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' /etc/audit/auditd.conf | xargs)")"
    
    # Check if the directory exists
    if [ -d "$l_audit_log_directory" ]; then
        l_maxperm="$(printf '%o' $(( 0777 & ~$l_perm_mask )) )" # Calculate the maximum permissible mode
        
        # Find audit log files in the directory with permissions greater than the permissible mode
        while IFS= read -r -d $'\0' l_file; do
            while IFS=: read -r l_file_mode l_hr_file_mode; do
                l_output2="$l_output2\n - File: \"$l_file\" is mode: \"$l_hr_file_mode\"\n   (should be mode: \"$l_maxperm\" or more restrictive)\n"
            done <<< "$(stat -Lc '%#a:%A' "$l_file")"
        done < <(find "$l_audit_log_directory" -maxdepth 1 -type f -perm /"$l_perm_mask" -print0)
    else
        # Directory not set message
        l_output2="$l_output2\n - Log file directory not set in \"/etc/audit/auditd.conf\". Please set log file directory."
    fi
else
    # Auditd configuration file not found message
    l_output2="$l_output2\n - File: \"/etc/audit/auditd.conf\" not found.\n - ** Verify auditd is installed **"
fi

# Output the audit results
if [ -z "$l_output2" ]; then
    l_output="$l_output\n - All files in \"$l_audit_log_directory\" are mode: \"$l_maxperm\" or more restrictive"
    echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :$l_output"
    exit 0
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_output2\n"
    exit 1
fi
```

