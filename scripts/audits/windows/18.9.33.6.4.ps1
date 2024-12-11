#```powershell
# PowerShell script to audit the configuration of "Allow standby states (S1-S3) when sleeping (plugged in)"
# Ensures the setting is configured to 'Disabled'

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\abfc2519-3608-4c2a-94ea-171b0ed546ab"
$valueName = "ACSettingIndex"

# Attempt to retrieve the registry value
try {
    $registryValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Error "Failed to retrieve the registry value. Ensure the registry path is correct and accessible."
    exit 1
}

# Check if the retrieved value matches the expected value (Disabled)
if ($registryValue.$valueName -eq 0) {
    Write-Output "Audit Passed: 'Allow standby states (S1-S3) when sleeping (plugged in)' is set to 'Disabled'."
    exit 0
} else {
    Write-Warning "Audit Failed: 'Allow standby states (S1-S3) when sleeping (plugged in)' is NOT set to 'Disabled'."
    Write-Output "Please manually navigate to the Group Policy Editor path: Computer Configuration\Policies\Administrative Templates\System\Power Management\Sleep Settings\Allow standby states (S1-S3) when sleeping (plugged in) and set it to 'Disabled'."
    exit 1
}
# ```
