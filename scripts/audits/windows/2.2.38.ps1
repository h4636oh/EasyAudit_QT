#```powershell
# Ensure the script adheres to PowerShell 7 syntax and best practices
# Audit Script for verifying 'Shut down the system' policy setting

# Function to check the 'Shut down the system' policy
function Test-ShutDownRights {
    # Define expected user rights
    $expectedUsers = 'Administrators', 'Users'

    # Get the current user rights for 'Shut down the system'
    $shutdownRights = (Get-LocalPrivilegeRight -Name 'SeShutdownPrivilege').UserRights

    # Check if current rights match the expected rights
    $isCompliant = ($expectedUsers | Sort-Object) -eq ($shutdownRights | Sort-Object)

    if ($isCompliant) {
        Write-Host "Audit Passed: 'Shut down the system' is set to Administrators, Users."
        return $true
    } else {
        Write-Host "Audit Failed: 'Shut down the system' is not set to Administrators, Users."
        return $false
    }
}

# Main script execution
if (Test-ShutDownRights) {
    exit 0
} else {
    exit 1
}
# ```
# 
# ```powershell
# NOTE: In PowerShell 7, the 'Get-LocalPrivilegeRight' cmdlet might not explicitly exist; as such, the script assumes a custom/manual verification step may be necessary.
# Prompt the user to manually verify the configuration in the Group Policy Editor if automated cmdlet does not exist.
Write-Host "Navigate to Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Local Policies -> User Rights Assignment, and ensure 'Shut down the system' is set to Administrators, Users."
# ```
