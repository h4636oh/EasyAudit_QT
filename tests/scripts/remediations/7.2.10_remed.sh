#!/usr/bin/env bash
{
    l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
    unset a_uarr
    a_uarr=() # Clear and initialize array
    
    # Populate array with users and user home location
    while read -r l_epu l_eph; do
        [[ -n "$l_epu" && -n "$l_eph" ]] && a_uarr+=("$l_epu $l_eph")
    done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"
    
    l_asize="${#a_uarr[@]}" # Number of users before proceeding
    l_maxsize="1000" # Maximum number of local interactive users before warning (Default 1,000)
    
    [ "$l_asize" -gt "$l_maxsize" ] && echo -e "\n ** INFO **\n - \"$l_asize\" Local interactive users found on the system\n - This may be a long running check\n"
    
    file_access_fix() {
        l_facout2=""
        l_max="$( printf '%o' $(( 0777 & ~$l_mask)) )"
        if [ $(( l_mode & l_mask )) -gt 0 ]; then
            echo -e " - File: \"$l_hdfile\" is mode: \"$l_mode\" and should be mode: \"$l_max\" or more restrictive\n - Changing to mode \"$l_max\""
            chmod "$l_chp" "$l_hdfile"
        fi
        if [[ ! "$l_owner" =~ ($l_user) ]]; then
            echo -e " - File: \"$l_hdfile\" owned by: \"$l_owner\" and should be owned by \"${l_user//|/ or }\"\n - Changing ownership to \"$l_user\""
            chown "$l_user" "$l_hdfile"
        fi
        if [[ ! "$l_gowner" =~ ($l_group) ]]; then
            echo -e " - File: \"$l_hdfile\" group owned by: \"$l_gowner\" and should be group owned by \"${l_group//|/ or }\"\n - Changing group ownership to \"$l_group\""
            chgrp "$l_group" "$l_hdfile"
        fi
    }

    while read -r l_user l_home; do
        if [ -d "$l_home" ]; then
            echo -e "\n - Checking user: \"$l_user\" home directory: \"$l_home\""
            l_group="$(id -gn "$l_user" | xargs)"
            l_group="${l_group// /|}"
            while IFS= read -r -d $'\0' l_hdfile; do
                while read -r l_mode l_owner l_gowner; do
                    case "$(basename "$l_hdfile")" in
                        .forward | .rhost )
                            echo -e " - File: \"$l_hdfile\" exists\n - Please investigate and manually delete \"$l_hdfile\""
                            ;;
                        .netrc )
                            l_mask='0177'
                            l_chp="u-x,go-rwx"
                            file_access_fix
                            ;;
                        .bash_history )
                            l_mask='0177'
                            l_chp="u-x,go-rwx"
                            file_access_fix
                            ;;
                        * )
                            l_mask='0133'
                            l_chp="u-x,go-wx"
                            file_access_fix
                            ;;
                    esac
                done <<< "$(stat -Lc '%#a %U %G' "$l_hdfile")"
            done < <(find "$l_home" -xdev -type f -name '.*' -print0)
        fi
    done <<< "$(printf '%s\n' "${a_uarr[@]}")"
    
    unset a_uarr # Remove array
}

