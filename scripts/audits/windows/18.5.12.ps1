#```powershell
# This script audits the configuration of TcpMaxDataRetransmissions to ensure it is set to 3.

# Define the registry path and key
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$registryKey = "TcpMaxDataRetransmissions"
$expectedValue = 3

# Get the actual value from the registry
try {
    $actualValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction Stop | Select-Object -ExpandProperty $registryKey
} catch {
    Write-Host "Error: Unable to read the registry key. Ensure you have the necessary permissions and the key exists." -ForegroundColor Red
    exit 1
}

# Compare the actual value with the expected value
if ($actualValue -eq $expectedValue) {
    Write-Host "Audit Passed: The '$registryKey' is set to $expectedValue as expected." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Audit Failed: The '$registryKey' is set to $actualValue. It should be set to $expectedValue." -ForegroundColor Yellow
    Write-Host "Please navigate to Computer Configuration\Policies\Administrative Templates\MSS (Legacy) and ensure 'MSS:(TcpMaxDataRetransmissions)' is set to Enabled: 3 manually." -ForegroundColor Yellow
    exit 1
}
# ```
# 
# This PowerShell script audits the `TcpMaxDataRetransmissions` registry setting and outputs the results. It checks if the registry value is set to the recommended setting of 3, indicating compliance. If the setting is incorrect, it suggests manual steps to correct it, following best practices for auditing without applying changes.
