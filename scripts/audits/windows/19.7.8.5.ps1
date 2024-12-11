#```powershell
# PowerShell 7 Script to Audit the Group Policy setting for "Turn off Spotlight collection on Desktop"
# This script checks if the registry value corresponds to the Group Policy setting being "Enabled"
# Exiting 0 indicates audit success, 1 indicates failure.
# Assumption: This script is supposed to be run per user session to check individual registry settings.

# Define the registry path and value name
$RegistryPath = "HKU:\$($env:USERPROFILE)\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$ValueName = "DisableSpotlightCollectionOnDesktop"

# Try to get the registry value
try {
    $regValue = Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction Stop
} catch {
    Write-Output "Could not retrieve registry key. Ensure you have access to the registry and try again."
    exit 1
}

# Check if the value is set to 1
if ($regValue.$ValueName -eq 1) {
    Write-Output "Audit passed: 'Turn off Spotlight collection on Desktop' is set to 'Enabled'."
    exit 0
} else {
    Write-Output "Audit failed: 'Turn off Spotlight collection on Desktop' is NOT set to 'Enabled'."
    Write-Output "Please manually set the Group Policy: User Configuration\\Policies\\Administrative Templates\\Windows Components\\Cloud Content\\Turn off Spotlight collection on Desktop to 'Enabled'."
    exit 1
}
# ```
# 
# This script audits whether the "Turn off Spotlight collection on Desktop" policy is enabled by checking the appropriate registry value under the current user's profile. If the value is not set correctly, it prompts the user to manually adjust the Group Policy setting as described in the audit requirements.
