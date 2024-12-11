#!/usr/bin/env bash
{
 l_perm_mask="0137"
 if [ -e "/etc/audit/auditd.conf" ]; then
 l_audit_log_directory="$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' /etc/audit/auditd.conf | xargs)")"
 if [ -d "$l_audit_log_directory" ]; then
 l_maxperm="$(printf '%o' $(( 0777 & ~$l_perm_mask )) )"
 a_files=()
 while IFS= read -r -d $'\0' l_file; do
 [ -e "$l_file" ] && a_files+=("$l_file")
 done < <(find "$l_audit_log_directory" -maxdepth 1 -type f -perm /"$l_perm_mask" -print0)
if (( "${#a_files[@]}" > 0 )); then
 for l_file in "${a_files[@]}"; do
 l_file_mode="$(stat -Lc '%#a' "$l_file")"
 echo -e "\n- Audit Result:\n ** FAIL **\n - File: \"$l_file\" is mode: \"$l_file_mode\"\n (should be mode: \"$l_maxperm\" or more restrictive)\n"
 done
 else
 echo -e "\n- Audit Result:\n ** PASS **\n - All files in \"$l_audit_log_directory\" are mode: \"$l_maxperm\" or more restrictive"
 fi
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Log file directory not set in \"/etc/audit/auditd.conf\" please set log file directory"
 fi
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - File: \"/etc/audit/auditd.conf\" not found.\n - ** Verify auditd is installed **"
 exit 1
 fi
}
