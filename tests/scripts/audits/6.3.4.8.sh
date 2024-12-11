#!/usr/bin/env bash
{
 l_output="" l_output2="" l_perm_mask="0022"
 l_maxperm="$( printf '%o' $(( 0777 & ~$l_perm_mask )) )"
 a_audit_tools=("/sbin/auditctl" "/sbin/aureport" "/sbin/ausearch" "/sbin/autrace" "/sbin/auditd" "/sbin/augenrules")
 for l_audit_tool in "${a_audit_tools[@]}"; do
 l_mode="$(stat -Lc '%#a' "$l_audit_tool")"
 if [ $(( "$l_mode" & "$l_perm_mask" )) -gt 0 ]; then
 l_output2="$l_output2\n - Audit tool \"$l_audit_tool\" is mode: \"$l_mode\" and should be mode: \"$l_maxperm\" or more restrictive"
 else
 l_output="$l_output\n - Audit tool \"$l_audit_tool\" is correctly configured to mode: \"$l_mode\""
 fi
 done
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :$l_output"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_output2\n"
 [ -n "$l_output" ] && echo -e "\n - * Correctly configured * :\n$l_output\n"
 fi
 unset a_audit_tools
}
