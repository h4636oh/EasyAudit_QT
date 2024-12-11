#!/usr/bin/env bash
{
l_output="" l_output2=""
perm_mask='0177' && maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
SSHD_FILES_CHK()
{
while IFS=: read -r l_mode l_user l_group; do
l_out2=""
[ $(( $l_mode & $perm_mask )) -gt 0 ] && l_out2="$l_out2\n - Is
mode: \"$l_mode\" should be: \"$maxperm\" or more restrictive"
[ "$l_user" != "root" ] && l_out2="$l_out2\n - Is owned by
\"$l_user\" should be owned by \"root\""
[ "$l_group" != "root" ] && l_out2="$l_out2\n - Is group owned by
\"$l_user\" should be group owned by \"root\""
if [ -n "$l_out2" ]; then
l_output2="$l_output2\n - File: \"$l_file\":$l_out2"
else
l_output="$l_output\n - File: \"$l_file\":\n - Correct: mode
($l_mode), owner ($l_user), and group owner ($l_group) configured"
fi
done < <(stat -Lc '%#a:%U:%G' "$l_file")
}
[ -e "/etc/ssh/sshd_config" ] && l_file="/etc/ssh/sshd_config" &&
SSHD_FILES_CHK
while IFS= read -r -d $'\0' l_file; do
[ -e "$l_file" ] && SSHD_FILES_CHK
done < <(find -L /etc/ssh/sshd_config.d -type f \( -perm /077 -o ! -user
root -o ! -group root \) -print0 2>/dev/null)
if [ -z "$l_output2" ]; then
echo -e "\n- Audit Result:\n *** PASS ***\n- * Correctly set *
:\n$l_output\n"
else
echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit
failure * :\n$l_output2\n"
[ -n "$l_output" ] && echo -e " - * Correctly set * :\n$l_output\n"
exit 1
fi
}