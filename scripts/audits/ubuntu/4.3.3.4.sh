ss -6tuln
ip6tables -L INPUT -v -n
# OR verify IPv6 is disabled:
# Run the following script. Output will confirm if IPv6 is disabled on the system.
# #!/usr/bin/bash
# output=""
# grubfile="$(find -L /boot -name 'grub.cfg' -type f)"
# [ -f "$grubfile" ] && ! grep "^\s*linux" "$grubfile" | grep -vq
# ipv6.disable=1 && output="ipv6 disabled in grub config"
# grep -Eqs "^\s*net\.ipv6\.conf\.all\.disable_ipv6\s*=\s*1\b" /etc/sysctl.conf
# /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf \
# /run/sysctl.d/*.conf && grep -Eqs
# "^\s*net\.ipv6\.conf\.default\.disable_ipv6\s*=\s*1\b" /etc/sysctl.conf
# /etc/sysctl.d/*.conf \
# /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf && sysctl
# net.ipv6.conf.all.disable_ipv6 | grep -Eq \
# "^\s*net\.ipv6\.conf\.all\.disable_ipv6\s*=\s*1\b" && sysctl
# net.ipv6.conf.default.disable_ipv6 | \
# grep -Eq "^\s*net\.ipv6\.conf\.default\.disable_ipv6\s*=\s*1\b" &&
# output="ipv6 disabled in sysctl config"
# [ -n "$output" ] && echo -e "\n$output" || echo -e "\n*** IPv6 is enabled on
# the system ***"