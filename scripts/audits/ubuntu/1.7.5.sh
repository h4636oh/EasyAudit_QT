#!/usr/bin/env bash
{
 # Check if GNOME Desktop Manager is installed. If package isn't installed, recommendation is Not Applicable
 # Determine system's package manager
 l_pkgoutput=""
 if command -v dpkg-query > /dev/null 2>&1; then
 l_pq="dpkg-query -s"
 elif command -v rpm > /dev/null 2>&1; then
 l_pq="rpm -q"
 fi
 # Check if GDM is installed
 l_pcl="gdm gdm3" # Space-separated list of packages to check
 for l_pn in $l_pcl; do
 $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
 done
 # Check configuration (If applicable)
 if [ -n "$l_pkgoutput" ]; then
 l_output="" l_output2=""
 # Check if the idle-delay is locked
 if grep -Psrilq '^\h*idle-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/; then
 if grep -Prilq '\/org\/gnome\/desktop\/session\/idle-delay\b' /etc/dconf/db/*/locks; then
 l_output="$l_output\n - \"idle-delay\" is locked"
 else
 l_output2="$l_output2\n - \"idle-delay\" is not locked"
 fi
 else
 l_output2="$l_output2\n - \"idle-delay\" is not set so it cannot be locked"
 fi
 # Check if the lock-delay is locked
 if grep -Psrilq '^\h*lock-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/; then
 if grep -Prilq '\/org\/gnome\/desktop\/screensaver\/lock-delay\b' /etc/dconf/db/*/locks; then
 l_output="$l_output\n - \"lock-delay\" is locked"
 else
 l_output2="$l_output2\n - \"lock-delay\" is not locked"
 fi
 else
 l_output2="$l_output2\n - \"lock-delay\" is not set so it cannot be locked"
 fi
 else
 l_output="$l_output\n - GNOME Desktop Manager package is not installed on the system\n -Recommendation is not applicable"
 fi
 # Report results. If no failures output in l_output2, we pass
 [ -n "$l_pkgoutput" ] && echo -e "\n$l_pkgoutput"
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
 [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
 exit 1
 fi
}

