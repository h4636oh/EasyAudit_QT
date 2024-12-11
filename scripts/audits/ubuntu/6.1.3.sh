#!/usr/bin/env bash
{
 l_output="" l_output2="" 
 f_parameter_chk()
 {
 l_out="" l_out2=""
 for l_string in "${!A_out[@]}"; do
 l_file_parameter="$(grep -Po -- "^\h*$l_parameter_name\b.*$" <<< "$l_string")"
 if [ -n "$l_file_parameter" ]; then
 l_file="$(printf '%s' "${A_out[$l_file_parameter]}")"
 l_out="$l_out\n - Exists as: \"$l_file_parameter\n - in the configuration file: \"$l_file\""
 for l_var in "${a_items[@]}"; do
 if ! grep -Pq -- "\b$l_var\b" <<< "$l_file_parameter"; then
 l_out2="$l_out2\n - Option: \"$l_var\" is missing from: \"$l_file_parameter\" in: \"$l_file\""
 fi
 done
 fi
 done
 [ -n "$l_out" ] && l_output="$l_output\n - Parameter: \"$l_parameter_name\":$l_out"
 [ -z "$l_out2" ] && l_output="$l_output\n - and includes \"$(printf '%s+' "${a_items[@]}")\""
 [ -n "$l_out2" ] && l_output2="$l_output2\n - Parameter: \"$l_parameter_name\":$l_out2"
 [[ -z "$l_out" && -z "$l_out2" ]] && l_output2="$l_output2\n - Parameter: \"$l_parameter_name\" is not configured"
 }
 f_check_config()
 {
 a_items=("p" "i" "n" "u" "g" "s" "b" "acl" "xattrs" "sha512")
 a_parlist=("/sbin/auditctl" "/sbin/auditd" "/sbin/ausearch" "/sbin/aureport" "/sbin/autrace" "/sbin/augenrules")
 unset A_out; declare -A A_out
 while IFS= read -r l_out; do
 if [ -n "$l_out" ]; then
 if [[ $l_out =~ ^\s*# ]]; then
 l_file="${l_out//# /}"
 else
 l_parameter="$l_out"
 A_out+=(["$l_parameter"]="$l_file")
 fi
 fi
 done < <(/usr/bin/systemd-analyze cat-config "$l_config_file" | grep -Pio '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
 for l_parameter_name in "${a_parlist[@]}"; do
 if [ -f "$l_parameter_name" ]; then
 f_parameter_chk
 else
 l_output="$l_output\n - ** Warning **\n Audit tool file: \"$l_parameter_name\" does not exist\n Please verify auditd is installed"
 fi
 done
 }
 if [ -f "/etc/aide/aide.conf" ]; then
 l_config_file="/etc/aide/aide.conf" && f_check_config
 elif [ -f "/etc/aide.conf" ]; then
 l_config_file="/etc/aide.conf" && f_check_config
 else
 l_output2="$l_output2\n - AIDE configuration file not found.\n Please verify AIDE is installed on the system"
 fi
 unset a_items; unset a_parlist; unset A_out 
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :$l_output"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_output2\n"
 [ -n "$l_output" ] && echo -e "\n - * Correctly configured * :\n$l_output\n"
 exit 1
 fi
}

