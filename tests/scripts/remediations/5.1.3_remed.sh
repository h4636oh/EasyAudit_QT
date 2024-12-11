#!/usr/bin/env bash
{
l_output="" l_output2=""
l_pmask="0133" && l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
FILE_ACCESS_FIX()
{
while IFS=: read -r l_file_mode l_file_owner l_file_group; do
l_out2=""
if [ $(( $l_file_mode & $l_pmask )) -gt 0 ]; then
l_out2="$l_out2\n - Mode: \"$l_file_mode\" should be mode:
\"$l_maxperm\" or more restrictive\n - updating to mode: \:$l_maxperm\""
chmod u-x,go-wx
fi
if [ "$l_file_owner" != "root" ]; then
l_out2="$l_out2\n - Owned by: \"$l_file_owner\" should be owned
by \"root\"\n - Changing ownership to \"root\""
chown root "$l_file"
fi
if [ "$l_file_group" != "root" ]; then
l_out2="$l_out2\n - Owned by group \"$l_file_group\" should be
group owned by: \"root\"\n - Changing group ownership to \"root\""
chgrp root "$l_file"
fi
if [ -n "$l_out2" ]; then
l_output2="$l_output2\n - File: \"$l_file\"$l_out2"
else
l_output="$l_output\n - File: \"$l_file\"\n - Correct: mode:
\"$l_file_mode\", owner: \"$l_file_owner\", and group owner:
\"$l_file_group\" configured"
fi
done < <(stat -Lc '%#a:%U:%G' "$l_file")
}
while IFS= read -r -d $'\0' l_file; do
if ssh-keygen -lf &>/dev/null "$l_file"; then
file "$l_file" | grep -Piq --
'\bopenssh\h+([^#\n\r]+\h+)?public\h+key\b' && FILE_ACCESS_FIX
fi
done < <(find -L /etc/ssh -xdev -type f -print0 2>/dev/null)
if [ -z "$l_output2" ]; then
echo -e "\n- No access changes required\n"
else
echo -e "\n- Remediation results:\n$l_output2\n"
fi
}