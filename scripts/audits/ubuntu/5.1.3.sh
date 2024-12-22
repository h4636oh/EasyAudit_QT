#!/usr/bin/env bash
{
 l_output="" l_output2=""
 l_pmask="0133" && l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
 FILE_CHK()
 {
 while IFS=: read -r l_file_mode l_file_owner l_file_group; do
 l_out2=""
 if [ $(( $l_file_mode & $l_pmask )) -gt 0 ]; then
 l_out2="$l_out2\n - Mode: \"$l_file_mode\" should be mode: 
\"$l_maxperm\" or more restrictive"
 fi
 if [ "$l_file_owner" != "root" ]; then
 l_out2="$l_out2\n - Owned by: \"$l_file_owner\" should be owned by \"root\""
 fi
 if [ "$l_file_group" != "root" ]; then
 l_out2="$l_out2\n - Owned by group \"$l_file_group\" should be group owned by group: \"root\""
 fi
 if [ -n "$l_out2" ]; then
 l_output2="$l_output2\n - File: \"$l_file\"$l_out2"
 else
 l_output="$l_output\n - File: \"$l_file\"\n - Correct: mode: \"$l_file_mode\", owner: \"$l_file_owner\", and group owner: \"$l_file_group\" configured"
 fi
 done < <(stat -Lc '%#a:%U:%G' "$l_file")
 }
 while IFS= read -r -d $'\0' l_file; do 
 if ssh-keygen -lf &>/dev/null "$l_file"; then 
 file "$l_file" | grep -Piq --'\bopenssh\h+([^#\n\r]+\h+)?public\h+key\b' && FILE_CHK
 fi
 done < <(find -L /etc/ssh -xdev -type f -print0 2>/dev/null)
 if [ -z "$l_output2" ]; then
 [ -z "$l_output" ] && l_output="\n - No openSSH public keys found"
 echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :$l_output"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_output2\n"
 [ -n "$l_output" ] && echo -e "\n - * Correctly configured * :\n$l_output\n"
 fi
}

