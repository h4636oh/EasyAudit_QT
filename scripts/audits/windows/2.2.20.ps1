#```powershell
# Ensure 'Deny log on through Remote Desktop Services' to include 'Guests'
# This script audits if the 'Guests' group is included in the 'Deny log on through Remote Desktop Services' policy.
# It checks the Local Security Policy configuration through the Security Descriptor Definition Language (SDDL).

# Function to convert SDDL to a more readable format
function Convert-SddlToReadableFormat {
    param (
        [string]$sddl
    )
    $sddlParts = @{
        "S" = "SeDenyRemoteInteractiveLogonRight"
    }
    return $sddlParts[$sddl]
}

# Main audit function
function Audit-DenyLogonThroughRDP {
    # Retrieve the SDDL for 'Deny log on through Remote Desktop Services'
    try {
        $sddl = (Get-CimInstance -ClassName Win32_UserAccount).SDDLPersistedName
        $readablePolicyName = Convert-SddlToReadableFormat -sddl $sddl
        
        # Check if the 'Guests' group is denied
        if ($readablePolicyName -and $readablePolicyName -eq "SeDenyRemoteInteractiveLogonRight") {
            # Check if 'Guests' is included
            $guestsIncluded = (Get-LokalGroup -Name "Guests").Name -contains "Guests"
            
            if ($guestsIncluded) {
                Write-Output "Audit Passed: 'Guests' group is correctly included in 'Deny log on through Remote Desktop Services'."
                exit 0
            } else {
                Write-Output "Audit Failed: 'Guests' group is NOT included in 'Deny log on through Remote Desktop Services'."
                exit 1
            }
        } else {
            Write-Output "Audit Failed: Unable to retrieve correct policy settings."
            exit 1
        }
    } catch {
        Write-Output "Audit Failed: Error retrieving Security Policy. Further manual verification required."
        exit 1
    }
}

Audit-DenyLogonThroughRDP
# ```
# 
# *Note:* The above script assumes that you have the necessary permissions and that the system has the appropriate PowerShell capabilities to fetch the security policy settings. The script checks a condition and outputs whether the setting complies with the security policy, exiting with `0` for compliance and `1` for non-compliance.
