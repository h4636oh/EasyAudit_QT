#```powershell
# This script audits the 'Allow Clipboard synchronization across devices' setting.
# It checks the registry value at HKLM:\SOFTWARE\Policies\Microsoft\Windows\System:AllowCrossDeviceClipboard
# Expected Value: 0 (Disabled)

# Define the registry path and the value name
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$ValueName = "AllowCrossDeviceClipboard"

# Try to get the registry value
try {
    $regValue = Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction Stop
} catch {
    # If there is an error, the registry value does not exist
    Write-Host "The registry key does not exist. Please confirm the setting manually in Group Policy."
    exit 1
}

# Check if the registry value is set to the expected value (0)
if ($regValue.$ValueName -eq 0) {
    Write-Host "Audit passed: Clipboard synchronization across devices is disabled."
    exit 0
} else {
    Write-Host "Audit failed: Clipboard synchronization across devices is not disabled."
    Write-Host "Please set 'Allow Clipboard synchronization across devices' to 'Disabled' manually via Group Policy."
    exit 1
}
# ```
