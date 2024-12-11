#```powershell
# This script audits the 'Restrict Unauthenticated RPC clients' policy setting
# and checks if it is set to 'Enabled: Authenticated'. It will exit with 0 if the
# audit passes and 1 if it fails.

# Define the registry path and value
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Rpc'
$regName = 'RestrictRemoteClients'
$expectedValue = 1

# Try to get the registry key value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
} catch {
    Write-Host "Could not retrieve the registry key. Please ensure it exists."
    Exit 1
}

# Check if the current registry value matches the expected value
if ($regValue.$regName -eq $expectedValue) {
    Write-Host "The 'Restrict Unauthenticated RPC clients' policy is correctly set to 'Enabled: Authenticated'."
    Exit 0
} else {
    Write-Host "The 'Restrict Unauthenticated RPC clients' policy is NOT correctly set. Manual intervention is required."
    Write-Host "Please navigate to Computer Configuration -> Policies -> Administrative Templates -> System -> Remote Procedure Call"
    Write-Host "and set 'Restrict Unauthenticated RPC clients' to 'Enabled: Authenticated'."
    Exit 1
}

# ```
