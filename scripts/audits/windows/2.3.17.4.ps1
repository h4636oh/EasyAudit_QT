#```powershell
<#
.SYNOPSIS
    Audits if the 'User Account Control: Detect application installations and prompt for elevation' is set to 'Enabled'.

.DESCRIPTION
    This script checks the registry setting to determine if 'EnableInstallerDetection' is set to 1, which corresponds to the 'Enabled' policy state.

.NOTES
    Profile Applicability: Level 1 (L1) - Corporate/Enterprise Environment (general use).
    Recommended State for this setting is: Enabled.
#>

# Registry path and value name to check
$regPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$valueName = 'EnableInstallerDetection'

try {
    # Retrieve the current registry value
    $currentValue = Get-ItemPropertyValue -Path $regPath -Name $valueName -ErrorAction Stop
    # Check if the value is set to 1, which means 'Enabled'
    if ($currentValue -eq 1) {
        Write-Output "Audit Passed: 'User Account Control: Detect application installations and prompt for elevation' is set to 'Enabled'."
        exit 0
    } else {
        Write-Output "Audit Failed: 'User Account Control: Detect application installations and prompt for elevation' is NOT set to 'Enabled'."
        exit 1
    }
} catch {
    # Handle the scenario where the registry path or value does not exist
    Write-Output "Audit Failed: Unable to determine the setting. Please verify the registry path '$regPath' and ensure the value '$valueName' exists."
    exit 1
}
# ```
