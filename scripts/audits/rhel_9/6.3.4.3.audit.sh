
#!/bin/bash

# 6.3.4.3 Ensure audit log files owner is configured (Automated)
# Profile Applicability: Level 2 - Server, Level 2 - Workstation
# Description: Audit log files contain information about the system and system activity.
# Rationale: Access to audit records can reveal system and configuration data to attackers,
# potentially compromising its confidentiality.

audit_log_ownership() {
    l_output="" 
    l_output2=""
    l_perm_mask="0177"

    # Check if auditd configuration file exists
    if [ -e "/etc/audit/auditd.conf" ]; then
        # Get audit log directory from the config
        l_audit_log_directory="$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' /etc/audit/auditd.conf | xargs)")"
        
        # Check if the directory exists
        if [ -d "$l_audit_log_directory" ]; then
            # Calculate the maximum file permission
            l_maxperm="$(printf '%o' $(( 0777 & ~$l_perm_mask )) )"
            
            # Find files in the audit log directory that don't match the permission mask
            while IFS= read -r -d $'\0' l_file; do
                l_output2="$l_output2\n - File: \"$l_file\" is mode: \"$(stat -Lc '%#a' "$l_file")\"\n   (should be mode: \"$l_maxperm\" or more restrictive)\n"
            done < <(find "$l_audit_log_directory" -maxdepth 1 -type f -perm /"$l_perm_mask" -print0)
        else
            l_output2="$l_output2\n - Log file directory not set in \"/etc/audit/auditd.conf\" please set log file directory\n"
        fi
    else
        l_output2="$l_output2\n - File: \"/etc/audit/auditd.conf\" not found.\n - ** Verify auditd is installed **\n"
    fi

    # Determine the audit result based on the gathered information
    if [ -z "$l_output2" ]; then
        l_output="$l_output\n - All files in \"$l_audit_log_directory\" are mode: \"$l_maxperm\" or more restrictive"
        echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :$l_output"
        exit 0
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_output2\n"
        exit 1
    fi
}

# Run the audit
audit_log_ownership
```