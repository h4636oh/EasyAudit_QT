#!/usr/bin/env bash
{
while read -r l_count l_gid; do
if [ "$l_count" -gt 1 ]; then
echo -e "Duplicate GID: \"$l_gid\" Groups: \"$(awk -F: '($3 == n) { print $1 }' n=$l_gid /etc/group | xargs)\""
exit 1
else
echo -e "**PASS** \n No duplicate GID: \"$l_gid\""
exit 0
fi
done < <(cut -f3 -d":" /etc/group | sort -n | uniq -c)
}