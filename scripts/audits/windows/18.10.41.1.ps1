#```powershell
# Audit Script for Checking Microsoft Account Authentication Setting

<#
.SYNOPSIS
This script audits the Group Policy setting to ensure 'Block all consumer Microsoft account user authentication' is set to 'Enabled'.

.DESCRIPTION
The script checks the registry value for 'DisableUserAuth' to verify whether consumer Microsoft account authentication is blocked.

.PARAMETER RegistryPath
The registry path where the setting is stored.

.PARAMETER RegistryValue
The name of the registry value to check.

.NOTES
Exit code 0 indicates the setting is compliant (Enabled).
Exit code 1 indicates the setting is non-compliant (Not Enabled).
#>

param(
    [string]$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftAccount",
    [string]$RegistryValue = "DisableUserAuth"
)

# Function to check registry setting
function Check-RegistrySetting {
    param(
        [string]$Path,
        [string]$ValueName
    )

    try {
        $regValue = Get-ItemProperty -Path $Path -ErrorAction Stop
        
        if ($null -ne $regValue.$ValueName -and $regValue.$ValueName -eq 1) {
            return $true
        } else {
            return $false
        }
    } catch {
        # Handle the case where the registry key or value does not exist
        return $false
    }
}

# Main Script Logic
$result = Check-RegistrySetting -Path $RegistryPath -ValueName $RegistryValue

if ($result) {
    Write-Output "Audit Passed: 'Block all consumer Microsoft account user authentication' is set to 'Enabled'."
    exit 0
} else {
    Write-Output "Audit Failed: 'Block all consumer Microsoft account user authentication' is not set to 'Enabled'."
    Write-Output "Please manually navigate to the Group Policy: Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> Microsoft accounts and set 'Block all consumer Microsoft account user authentication' to 'Enabled'."
    exit 1
}
# ```
