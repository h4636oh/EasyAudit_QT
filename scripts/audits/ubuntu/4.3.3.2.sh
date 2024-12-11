ip6tables -L INPUT -v -n
ip6tables -L OUTPUT -v -n
# -OR-
# Verify IPv6 is disabled:
# Run the following script. Output will confirm if IPv6 is enabled on the system.
# #!/usr/bin/bash
# {
# if grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable; then
# echo -e " - IPv6 is enabled on the system"
# else
# echo -e " - IPv6 is not enabled on the system"
# fi
# }