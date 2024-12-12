#!/usr/bin/env bash
{
unset a_ufwout;unset a_openports
while read -r l_ufwport; do
[ -n "$l_ufwport" ] && a_ufwout+=("$l_ufwport")
done < <(ufw status verbose | grep -Po '^\h*\d+\b' | sort -u)
while read -r l_openport; do
[ -n "$l_openport" ] && a_openports+=("$l_openport")
done < <(ss -tuln | awk '($5!~/%lo:/ && $5!~/127.0.0.1:/ &&
$5!~/\[?::1\]?:/) {split($5, a, ":"); print a[2]}' | sort -u)
a_diff=("$(printf '%s\n' "${a_openports[@]}" "${a_ufwout[@]}"
"${a_ufwout[@]}" | sort | uniq -u)")
if [[ -n "${a_diff[*]}" ]]; then
echo -e "\n- Audit Result:\n ** FAIL **\n- The following port(s) don't
have a rule in UFW: $(printf '%s\n' \\n"${a_diff[*]}")\n- End List"
exit 1
else
echo -e "\n - Audit Passed -\n- All open ports have a rule in UFW\n"
fi
}