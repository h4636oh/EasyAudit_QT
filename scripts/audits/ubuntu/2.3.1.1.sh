#!/usr/bin/env bash
{
 l_output="" l_output2=""
 service_not_enabled_chk()
 {
 l_out2=""
 if systemctl is-enabled "$l_service_name" 2>/dev/null | grep -q 'enabled'; then
 l_out2="$l_out2\n - Daemon: \"$l_service_name\" is enabled on the system"
 fi
 if systemctl is-active "$l_service_name" 2>/dev/null | grep -q '^active'; then
 l_out2="$l_out2\n - Daemon: \"$l_service_name\" is active on the system"
 fi
 } 
 l_service_name="systemd-timesyncd.service" # Check systemd-timesyncd daemon
 service_not_enabled_chk
 if [ -n "$l_out2" ]; then
 l_timesyncd="y"
 l_out_tsd="$l_out2"
 else
 l_timesyncd="n"
 l_out_tsd="\n - Daemon: \"$l_service_name\" is not enabled and not active on the system"
 fi
 l_service_name="chrony.service" # Check chrony
 service_not_enabled_chk
 if [ -n "$l_out2" ]; then
 l_chrony="y"
 l_out_chrony="$l_out2"
 else
 l_chrony="n"
 l_out_chrony="\n - Daemon: \"$l_service_name\" is not enabled and not active on the system"
 fi
 l_status="$l_timesyncd$l_chrony"
 case "$l_status" in
 yy)
 l_output2=" - More than one time sync daemon is in use on the system$l_out_tsd$l_out_chrony"
 ;;
 nn)
 l_output2=" - No time sync daemon is in use on the system$l_out_tsd$l_out_chrony"
 ;;
 yn|ny)
 l_output=" - Only one time sync daemon is in use on the system$l_out_tsd$l_out_chrony"
 ;;
 *)
 l_output2=" - Unable to determine time sync daemon(s) status"
 ;;
 esac
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2\n"
 exit 1
 fi
}

