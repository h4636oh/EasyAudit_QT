#!/bin/bash
grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && echo -e "\n -IPv6 is enabled\n" || echo -e "\n - IPv6 is not enabled\n"
