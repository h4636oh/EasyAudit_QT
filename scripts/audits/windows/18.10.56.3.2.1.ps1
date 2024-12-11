#```powershell
# PowerShell 7 Script to Audit Remote Desktop Services Configuration

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$valueName = "fDenyTSConnections"
$expectedValue = 1

# Try to get the registry value. Catch any exceptions if the path or value doesn't exist.
try {
    $actualValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "Registry path or value not found."
    Write-Host "Please ensure Remote Desktop Services are configured according to policy manually."
    exit 1
}

# Compare the actual value with the expected value
if ($actualValue.$valueName -eq $expectedValue) {
    Write-Host "Remote Desktop Services are correctly configured to disallow connections."
    exit 0
} else {
    Write-Host "Remote Desktop Services configuration does not match the expected policy."
    Write-Host "Please ensure the following group policy setting is set to Disabled:"
    Write-Host "`nComputer Configuration\Policies\Administrative Templates\Windows Components\Remote Desktop Services\Remote Desktop Session Host\Connections\Allow users to connect remotely by using Remote Desktop Services`n"
    exit 1
}
# ```
# 
# This script audits the configuration of Remote Desktop Services to check if they are set to disallow remote connections, as per the policy requirements. If the policy setting does not match the expected state, it provides instructions for the user to verify and configure manually. The script exits with code `0` if the audit is successful and `1` if it fails.
