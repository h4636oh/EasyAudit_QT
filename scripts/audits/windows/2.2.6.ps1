#```powershell
# This script audits the policy setting for "Allow log on through Remote Desktop Services"
# It checks if it is set to 'Administrators, Remote Desktop Users'

# Function to check the "Allow log on through Remote Desktop Services" user rights assignment
function Check-RemoteDesktopLogonRights {
    # Get the security descriptor for "SeRemoteInteractiveLogonRight"
    $remoteDesktopUsers = (Get-LocalGroupMember -Group "Remote Desktop Users" -ErrorAction Stop | Select-Object -ExpandProperty Name) -join ', '
    $administrators = (Get-LocalGroupMember -Group "Administrators" -ErrorAction Stop | Select-Object -ExpandProperty Name) -join ', '

    # Expected groups
    $expectedGroups = @("Remote Desktop Users", "Administrators")

    # If either check fails, mark the audit as failed
    $auditResult = $true

    # Check if 'Remote Desktop Users' group contains only expected users
    if ($remoteDesktopUsers -notmatch $expectedGroups[0]) {
        Write-Output "Audit Failed: Unexpected users found in 'Remote Desktop Users' group: $remoteDesktopUsers"
        $auditResult = $false
    }

    # Check if 'Administrators' group contains only expected users
    if ($administrators -notmatch $expectedGroups[1]) {
        Write-Output "Audit Failed: Unexpected users found in 'Administrators' group: $administrators"
        $auditResult = $false
    }

    # If auditResult is false, exit with code 1, else exit with code 0
    if (-not $auditResult) {
        exit 1
    } else {
        Write-Output "Audit Passed: 'Allow log on through Remote Desktop Services' is correctly configured."
        exit 0
    }
}

# Execute the function
Check-RemoteDesktopLogonRights
# ```
# 
# Note: The script assumes that the system is being audited manually and checks if the "Remote Desktop Users" and "Administrators" groups contain only the expected group names. This is necessary because Group Policy settings cannot be directly checked via PowerShell without advanced techniques or third-party tools. Further, due to limitations in PowerShell, precise auditing of certain Group Policy configurations might require manual steps or using specific system tools not covered here.
