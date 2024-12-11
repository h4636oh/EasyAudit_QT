#```powershell
# PowerShell 7 script to audit the "Configure RPC over TCP port" policy setting

# Define the registry path and value name for the audit
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC'
$valueName = 'RpcTcpPort'
$expectedValue = 0

# Attempt to retrieve the registry value
try {
    $registryValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "Audit Failed: Unable to retrieve the registry value. Registry path or value does not exist."
    Write-Host "Manual Check Required: Navigate to the UI path specified in the policy documentation to verify settings."
    exit 1
}

# Check if the retrieved value matches the expected value
if ($registryValue.$valueName -eq $expectedValue) {
    Write-Host "Audit Passed: 'Configure RPC over TCP port' is correctly set to 'Enabled: 0'."
    exit 0
} else {
    Write-Host "Audit Failed: 'Configure RPC over TCP port' is not set to the recommended value of 'Enabled: 0'."
    Write-Host "Manual Action Required: Navigate to Computer Configuration\Policies\Administrative Templates\Printers\ and set 'Configure RPC over TCP port' to 'Enabled: 0'."
    exit 1
}
# ```
