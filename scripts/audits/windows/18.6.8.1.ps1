#```powershell
# Script to audit if "Enable insecure guest logons" is set to 'Disabled'
# Policy backed by registry value: AllowInsecureGuestAuth (0 - Disabled, 1 - Enabled)

# Define the registry path and value name
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation"
$valueName = "AllowInsecureGuestAuth"

# Try to get the registry value
try {
    $allowInsecureGuestAuth = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "Registry key or value not found. Please ensure the Group Policy is applied."
    # Prompt user to check manually
    Write-Host "Manually verify the Group Policy setting at the following UI path:"
    Write-Host "Computer Configuration\\Policies\\Administrative Templates\\Network\\Lanman Workstation\\Enable insecure guest logons"
    Exit 1
}

# Check the value and determine if audit passes or fails
if ($allowInsecureGuestAuth.$valueName -eq 0) {
    Write-Host "Audit Passed: 'Enable insecure guest logons' is set to 'Disabled'."
    Exit 0
} else {
    Write-Host "Audit Failed: 'Enable insecure guest logons' is not set to 'Disabled'."
    Exit 1
}
# ```
