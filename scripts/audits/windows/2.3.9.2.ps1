#```powershell
# PowerShell Script to Audit SMB Server Packet Signing Policy

# Define the registry path and the expected registry value
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters'
$registryValueName = 'RequireSecuritySignature'
$expectedValue = 1

# Try to get the registry value
try {
    $registryValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
} catch {
    Write-Host "Could not retrieve the registry value at $registryPath. Please check the permissions or verify if the path is correct."
    Write-Host "Audit Failed: Unable to access the required registry key."
    exit 1
}

# Check if the value matches the expected value
if ($registryValue.$registryValueName -eq $expectedValue) {
    Write-Host "Audit Passed: The Microsoft network server: Digitally sign communications (always) is set to 'Enabled'."
    exit 0
} else {
    Write-Host "Audit Failed: The Microsoft network server: Digitally sign communications (always) is not set to 'Enabled'."
    Write-Host "Manual Check: Navigate to 'Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options' and verify the setting."
    Write-Host "The registry value should be set to 1 at $registryPath\$registryValueName."
    exit 1
}
# ```
