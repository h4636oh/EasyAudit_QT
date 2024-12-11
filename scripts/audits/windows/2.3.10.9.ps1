#```powershell
# PowerShell 7 script to audit whether 'Network access: Restrict anonymous access to Named Pipes and Shares' is enabled.

# Define the registry path and the value name to check
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters'
$valueName = 'RestrictNullSessAccess'

# Try to get the registry value
try {
    $registryValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "Failed to retrieve the registry value. Please verify the registry path and permissions are correct."
    exit 1
}

# Check if the registry value is set to 1 (Enabled)
if ($registryValue.$valueName -eq 1) {
    Write-Host "'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled'. Audit Passed."
    exit 0
} else {
    Write-Host "'Network access: Restrict anonymous access to Named Pipes and Shares' is NOT set to 'Enabled'. Audit Failed."
    Write-Host "Please enable this setting manually by navigating to the following Group Policy path: "
    Write-Host "Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Local Policies -> Security Options"
    Write-Host "Set 'Network access: Restrict anonymous access to Named Pipes and Shares' to 'Enabled'."
    exit 1
}
# ```
