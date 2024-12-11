#!/usr/bin/env bash
{
    a_output2=()
    a_output3=()
    l_maxsize="1000" # Maximum number of local interactive users before warning (Default 1,000)
    l_valid_shells="^($(awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
    a_user_and_home=() # Create array with local users and their home directories

    while read -r l_local_user l_local_user_home; do # Populate array with users and user home location
        [[ -n "$l_local_user" && -n "$l_local_user_home" ]] && a_user_and_home+=("$l_local_user:$l_local_user_home")
    done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"
    
    l_asize="${#a_user_and_home[@]}" # Here if we want to look at number of users before proceeding
    [ "${#a_user_and_home[@]}" -gt "$l_maxsize" ] && printf '%s\n' "" " ** INFO **" \
        " - \"$l_asize\" Local interactive users found on the system" \
        " - This may be a long running check" ""

    file_access_chk() {
        a_access_out=()
        l_max="$(printf '%o' $(( 0777 & ~$l_mask)) )"
        if [ $(( $l_mode & $l_mask )) -gt 0 ]; then
            a_access_out+=(" - File: \"$l_hdfile\" is mode: \"$l_mode\" and should be mode: \"$l_max\" or more restrictive")
        fi
        if [[ ! "$l_owner" =~ ($l_user) ]]; then
            a_access_out+=(" - File: \"$l_hdfile\" owned by: \"$l_owner\" and should be owned by \"${l_user//|/ or }\"")
        fi
        if [[ ! "$l_gowner" =~ ($l_group) ]]; then
            a_access_out+=(" - File: \"$l_hdfile\" group owned by: \"$l_gowner\" and should be group owned by \"${l_group//|/ or }\"")
        fi
    }

    while IFS=: read -r l_user l_home; do
        a_dot_file=()
        a_netrc=()
        a_netrc_warn=()
        a_bhout=()
        a_hdirout=()
        
        if [ -d "$l_home" ]; then
            l_group="$(id -gn "$l_user" | xargs)"; l_group="${l_group// /|}"
            while IFS= read -r -d $'\0' l_hdfile; do
                while read -r l_mode l_owner l_gowner; do
                    case "$(basename "$l_hdfile")" in
                        .forward | .rhost )
                            a_dot_file+=(" - File: \"$l_hdfile\" exists") ;;
                        .netrc )
                            l_mask='0177'; file_access_chk
                            if [ "${#a_access_out[@]}" -gt 0 ]; then
                                a_netrc+=("${a_access_out[@]}")
                            else
                                a_netrc_warn+=(" - File: \"$l_hdfile\" exists")
                            fi ;;
                        .bash_history )
                            l_mask='0177'; file_access_chk
                            [ "${#a_access_out[@]}" -gt 0 ] && a_bhout+=("${a_access_out[@]}") ;;
                        * )
                            l_mask='0133'; file_access_chk
                            [ "${#a_access_out[@]}" -gt 0 ] && a_hdirout+=("${a_access_out[@]}") ;;
                    esac
                done < <(stat -Lc '%#a %U %G' "$l_hdfile")
            done < <(find "$l_home" -xdev -type f -name '.*' -print0)
        fi
        
        if [[ "${#a_dot_file[@]}" -gt 0 || "${#a_netrc[@]}" -gt 0 || "${#a_bhout[@]}" -gt 0 || "${#a_hdirout[@]}" -gt 0 ]]; then
            a_output2+=(" - User: \"$l_user\" Home Directory: \"$l_home\"" "${a_dot_file[@]}" "${a_netrc[@]}" "${a_bhout[@]}" "${a_hdirout[@]}")
        fi
        
        [ "${#a_netrc_warn[@]}" -gt 0 ] && a_output3+=(" - User : \"$l_user\" Home Directory: \"$l_home\"" "${a_netrc_warn[@]}")
    done <<< "$(printf '%s\n' "${a_user_and_home[@]}")"
    
    if [ "${#a_output2[@]}" -le 0 ]; then # If l_output2 is empty, we pass
        [ "${#a_output3[@]}" -gt 0 ] && printf '%s\n' " ** WARNING **" "${a_output3[@]}"
        printf '%s\n' "- Audit Result:" " ** PASS **"
        exit 0
    else
        printf '%s\n' "- Audit Result:" " ** FAIL **" " - * Reasons for audit failure * :" "${a_output2[@]}" ""
        [ "${#a_output3[@]}" -gt 0 ] && printf '%s\n' " ** WARNING **" "${a_output3[@]}"
        exit 1
    fi
}