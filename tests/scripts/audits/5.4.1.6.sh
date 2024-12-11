{
while IFS= read -r l_user; do
l_change=$(date -d "$(chage --list $l_user | grep '^Last password
change' | cut -d: -f2 | grep -v 'never$')" +%s)
if [[ "$l_change" -gt "$(date +%s)" ]]; then
echo "User: \"$l_user\" last password change was \"$(chage --list
$l_user | grep '^Last password change' | cut -d: -f2)\""
fi
done < <(awk -F: '$2~/^\$.+\$/{print $1}' /etc/shadow)
}