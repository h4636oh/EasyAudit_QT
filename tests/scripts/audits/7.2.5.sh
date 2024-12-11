#!/usr/bin/env bash
{
exit_status=0
while read -r l_count l_uid; do
 if [ "$l_count" -gt 1 ]; then
 echo -e "Duplicate UID: \"$l_uid\" Users: \"$(awk -F: '($3 == n) { print $1 }' n=$l_uid /etc/passwd | xargs)\""
 exit_status=1
 fi
 done < <(cut -f3 -d":" /etc/passwd | sort -n | uniq -c)
 exit $exit_status
}
