#```powershell
# PowerShell 7 Script to Audit PNRP Service Configuration
# This script audits if the Peer Name Resolution Protocol (PNRPsvc) is set to 'Disabled'

# Define the registry path and key
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\PNRPsvc'
$registryValueName = 'Start'
$expectedValue = 4

# Retrieve the current registry value
try {
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop | Select-Object -ExpandProperty $registryValueName
} catch {
    Write-Host "Failed to retrieve the registry value. Please ensure the registry path is correct and you have the necessary permissions."
    exit 1
}

# Check if the current registry value matches the expected value for 'Disabled' state
if ($currentValue -eq $expectedValue) {
    Write-Host "Audit Passed: The Peer Name Resolution Protocol (PNRPsvc) is set to 'Disabled'."
    exit 0
} else {
    Write-Host "Audit Failed: The Peer Name Resolution Protocol (PNRPsvc) is NOT set to 'Disabled'."
    Write-Host "Please manually navigate to 'Computer Configuration\\Policies\\Windows Settings\\Security Settings\\System Services\\Peer Name Resolution Protocol' and ensure it is set to 'Disabled'."
    exit 1
}
# ```
