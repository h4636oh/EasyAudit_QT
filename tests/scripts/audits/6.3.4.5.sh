#!/usr/bin/env bash
{
 l_output="" l_output2="" l_perm_mask="0137"
 l_maxperm="$( printf '%o' $(( 0777 & ~$l_perm_mask )) )"
 while IFS= read -r -d $'\0' l_fname; do
 l_mode=$(stat -Lc '%#a' "$l_fname")
 if [ $(( "$l_mode" & "$l_perm_mask" )) -gt 0 ]; then
 l_output2="$l_output2\n - file: \"$l_fname\" is mode: \"$l_mode\" (should be mode: \"$l_maxperm\" or more restrictive)"
 fi
 done < <(find /etc/audit/ -type f \( -name "*.conf" -o -name '*.rules' \) -print0)
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n - All audit configuration files are mode: \"$l_maxperm\" or more restrictive"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n$l_output2"
 exit 1
 fi
}

