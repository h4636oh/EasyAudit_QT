#!/usr/bin/env bash
{
l_output2=""
l_pmask="0022"
l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
l_root_path="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"
unset a_path_loc && IFS=":" read -ra a_path_loc <<< "$l_root_path"
grep -q "::" <<< "$l_root_path" && l_output2="$l_output2\n - root's pathcontains a empty directory (::)"
grep -Pq ":\h*$" <<< "$l_root_path" && l_output2="$l_output2\n - root'spath contains a trailing (:)"
grep -Pq '(\h+|:)\.(:|\h*$)' <<< "$l_root_path" && l_output2="$l_output2\n- root's path contains current working directory (.)"
while read -r l_path; do
if [ -d "$l_path" ]; then
while read -r l_fmode l_fown; do
[ "$l_fown" != "root" ] && l_output2="$l_output2\n - Directory:\"$l_path\" is owned by: \"$l_fown\" should be owned by \"root\""
[ $(( $l_fmode & $l_pmask )) -gt 0 ] && l_output2="$l_output2\n -Directory: \"$l_path\" is mode: \"$l_fmode\" and should be mode:\"$l_maxperm\" or more restrictive"
done <<< "$(stat -Lc '%#a %U' "$l_path")"
else
l_output2="$l_output2\n - \"$l_path\" is not a directory"
fi
done <<< "$(printf "%s\n" "${a_path_loc[@]}")"
if [ -z "$l_output2" ]; then
echo -e "\n- Audit Result:\n *** PASS ***\n - Root's path is correctlyconfigured\n"
else
echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for auditfailure * :\n$l_output2\n"
exit 1
fi
}
