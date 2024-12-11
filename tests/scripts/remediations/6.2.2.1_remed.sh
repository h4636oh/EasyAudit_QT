#!/usr/bin/env bash
{
 l_op2="" l_output2=""
 l_uidmin="$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"
 file_test_fix()
 {
 l_op2=""
 l_fuser="root"
 l_fgroup="root"
 if [ $(( $l_mode & $perm_mask )) -gt 0 ]; then
 l_op2="$l_op2\n - Mode: \"$l_mode\" should be \"$maxperm\" or more restrictive\n - Removing excess permissions"
 chmod "$l_rperms" "$l_fname"
 fi
 if [[ ! "$l_user" =~ $l_auser ]]; then
 l_op2="$l_op2\n - Owned by: \"$l_user\" and should be owned by \"${l_auser//|/ or }\"\n - Changing ownership to: \"$l_fuser\""
 chown "$l_fuser" "$l_fname"
 fi
 if [[ ! "$l_group" =~ $l_agroup ]]; then
 l_op2="$l_op2\n - Group owned by: \"$l_group\" and should be group owned by \"${l_agroup//|/ or }\"\n - Changing group ownership to: \"$l_fgroup\""
 chgrp "$l_fgroup" "$l_fname"
 fi
 [ -n "$l_op2" ] && l_output2="$l_output2\n - File: \"$l_fname\" is:$l_op2\n"
 }
 unset a_file && a_file=() # clear and initialize array
 # Loop to create array with stat of files that could possibly fail one of the audits
 while IFS= read -r -d $'\0' l_file; do
 [ -e "$l_file" ] && a_file+=("$(stat -Lc '%n^%#a^%U^%u^%G^%g' "$l_file")")
 done < <(find -L /var/log -type f \( -perm /0137 -o ! -user root -o ! -group root \) -print0)
 while IFS="^" read -r l_fname l_mode l_user l_uid l_group l_gid; do
 l_bname="$(basename "$l_fname")"
 case "$l_bname" in
 lastlog | lastlog.* | wtmp | wtmp.* | wtmp-* | btmp | btmp.* | btmp-* | README)
 perm_mask='0113'
 maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
 l_rperms="ug-x,o-wx"
 l_auser="root"
 l_agroup="(root|utmp)"
 file_test_fix
 ;;
 secure | auth.log | syslog | messages)
 perm_mask='0137'
 maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
 l_rperms="u-x,g-wx,o-rwx"
 l_auser="(root|syslog)"
 l_agroup="(root|adm)"
 file_test_fix
 ;;
 SSSD | sssd)
 perm_mask='0117'
 maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
 l_rperms="ug-x,o-rwx"
 l_auser="(root|SSSD)"
 l_agroup="(root|SSSD)"
 file_test_fix 
 ;;
 gdm | gdm3)
 perm_mask='0117'
 l_rperms="ug-x,o-rwx"
 maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
 l_auser="root"
 l_agroup="(root|gdm|gdm3)"
 file_test_fix 
 ;;
 *.journal | *.journal~)
 perm_mask='0137'
 maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
 l_rperms="u-x,g-wx,o-rwx"
 l_auser="root"
 l_agroup="(root|systemd-journal)" 
 file_test_fix
 ;;
 *)
 perm_mask='0137'
 maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
 l_rperms="u-x,g-wx,o-rwx"
 l_auser="(root|syslog)"
 l_agroup="(root|adm)"
 if [ "$l_uid" -lt "$l_uidmin" ] && [ -z "$(awk -v grp="$l_group" -F: '$1==grp {print $4}' /etc/group)" ]; then
 if [[ ! "$l_user" =~ $l_auser ]]; then
 l_auser="(root|syslog|$l_user)"
 fi
 if [[ ! "$l_group" =~ $l_agroup ]]; then
 l_tst=""while l_out3="" read -r l_duid; do
 [ "$l_duid" -ge "$l_uidmin" ] && l_tst=failed
 done <<< "$(awk -F: '$4=='"$l_gid"' {print $3}' /etc/passwd)"
 [ "$l_tst" != "failed" ] && l_agroup="(root|adm|$l_group)"
 fi
 fi
 file_test_fix
 ;;
 esac
 done <<< "$(printf '%s\n' "${a_file[@]}")"
 unset a_file # Clear array
 # If all files passed, then we report no changes
 if [ -z "$l_output2" ]; then
 echo -e "- All files in \"/var/log/\" have appropriate permissions and ownership\n - No changes required\n"
 else
 # print report of changes
 echo -e "\n$l_output2"
 fi
}
