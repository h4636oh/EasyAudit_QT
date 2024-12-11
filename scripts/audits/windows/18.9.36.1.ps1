#```powershell
# PowerShell 7 script to audit the 'Enable RPC Endpoint Mapper Client Authentication' policy setting
# This script checks if the specified registry key is set to 1 (Enabled) for the policy compliance.

param (
    [string]$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Rpc',
    [string]$RegistryValue = 'EnableAuthEpResolution'
)

# Check if the registry key exists
if (!(Test-Path -Path $RegistryPath)) {
    Write-Output "Audit Failed: Registry path $RegistryPath does not exist."
    exit 1
}

# Get the current value of the registry key
$currentValue = (Get-ItemProperty -Path $RegistryPath -Name $RegistryValue -ErrorAction SilentlyContinue).$RegistryValue

# Check if the value is set to 1
if ($currentValue -eq 1) {
    Write-Output "Audit Passed: 'Enable RPC Endpoint Mapper Client Authentication' is set to 'Enabled'."
    exit 0
} else {
    Write-Output "Audit Failed: 'Enable RPC Endpoint Mapper Client Authentication' is not set to 'Enabled'. Please configure it manually through Group Policy at: Computer Configuration\\Policies\\Administrative Templates\\System\\Remote Procedure Call\\Enable RPC Endpoint Mapper Client Authentication."
    exit 1
}
# ```
