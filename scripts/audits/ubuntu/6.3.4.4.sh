#!/usr/bin/env bash
{
 l_perm_mask="0027"
 if [ -e "/etc/audit/auditd.conf" ]; then
 l_audit_log_directory="$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' /etc/audit/auditd.conf | xargs)")"
 if [ -d "$l_audit_log_directory" ]; then
 l_maxperm="$(printf '%o' $(( 0777 & ~$l_perm_mask )) )"
 l_directory_mode="$(stat -Lc '%#a' "$l_audit_log_directory")"
 if [ $(( $l_directory_mode & $l_perm_mask )) -gt 0 ]; then
 echo -e "\n- Audit Result:\n ** FAIL **\n - Directory: \"$l_audit_log_directory\" is mode: \"$l_directory_mode\"\n (should be mode: \"$l_maxperm\" or more restrictive)\n"
 else
 echo -e "\n- Audit Result:\n ** PASS **\n - Directory: \"$l_audit_log_directory\" is mode: \"$l_directory_mode\"\n (should be mode: \"$l_maxperm\" or more restrictive)\n"
 fi 
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Log file directory not set in \"/etc/audit/auditd.conf\" please set log file directory"
 fi
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - File: \"/etc/audit/auditd.conf\" not found\n - ** Verify auditd is installed **"
 exit 1
 fi
}

