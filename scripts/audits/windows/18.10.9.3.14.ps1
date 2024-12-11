#```powershell
# Script to audit the BitLocker policy setting that denies write access to removable drives not protected by BitLocker.

# Define the registry path and value name
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Policies\Microsoft\FVE"
$valueName = "RDVDenyWriteAccess"

# Try to read the registry value
try {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "Audit failed: Unable to read registry value. Ensure you have the necessary permissions."
    Exit 1
}

# Check if the value is set to 1 (Enabled)
if ($value.$valueName -eq 1) {
    Write-Host "Audit passed: 'Deny write access to removable drives not protected by BitLocker' is enabled."
    Exit 0
} else {
    Write-Host "Audit failed: 'Deny write access to removable drives not protected by BitLocker' is not enabled."
    Write-Host "Please navigate to the Group Policy path:"
    Write-Host "Computer Configuration\Policies\Administrative Templates\Windows Components\BitLocker Drive Encryption\Removable Data Drives\Deny write access to removable drives not protected by BitLocker"
    Write-Host "And ensure this setting is set to 'Enabled'."
    Exit 1
}
# ```
