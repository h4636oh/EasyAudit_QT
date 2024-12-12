#!/usr/bin/env bash
{
 l_output="" l_output2=""
 a_suid=(); a_sgid=() # initialize arrays
 while IFS= read -r l_mount_point; do
 if ! grep -Pqs '^\h*\/run\/usr\b' <<< "$l_mount_point" && ! grep -Pqs -- '\bnoexec\b' <<< "$(findmnt -krn "$l_mount_point")"; then
 while IFS= read -r -d $'\0' l_file; do
 if [ -e "$l_file" ]; then
 l_mode="$(stat -Lc '%#a' "$l_file")"
 [ $(( $l_mode & 04000 )) -gt 0 ] && a_suid+=("$l_file")
 [ $(( $l_mode & 02000 )) -gt 0 ] && a_sgid+=("$l_file")
 fi
 done < <(find "$l_mount_point" -xdev -type f \( -perm -2000 -o -perm -4000 \) -print0 2>/dev/null)
 fi
 done <<< "$(findmnt -Derno target)"
 if ! (( ${#a_suid[@]} > 0 )); then
 l_output="$l_output\n - No executable SUID files exist on the system"
 else
 l_output2="$l_output2\n - List of \"$(printf '%s' "${#a_suid[@]}")\" SUID executable files:\n$(printf '%s\n' "${a_suid[@]}")\n - end of list -\n"
 fi
 if ! (( ${#a_sgid[@]} > 0 )); then
 l_output="$l_output\n - There are no SGID files exist on the system"
 else
 l_output2="$l_output2\n - List of \"$(printf '%s' "${#a_sgid[@]}")\" SGID executable files:\n$(printf '%s\n' "${a_sgid[@]}")\n - end of list -\n"
 fi
 [ -n "$l_output2" ] && l_output2="$l_output2\n- Review the preceding list(s) of SUID and/or SGID files to\n- ensure that no rogue programs have been introduced onto the system.\n" 
 unset a_arr; unset a_suid; unset a_sgid # Remove arrays
 # If l_output2 is empty, Nothing to report
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n$l_output2\n"
 [ -n "$l_output" ] && echo -e "$l_output\n"
 fi
}

