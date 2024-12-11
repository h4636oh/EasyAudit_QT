#```powershell
# PowerShell 7 Script to Audit 'Prevent downloading of enclosures' Policy Setting

# Define the registry path and expected value
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds'
$registryValueName = 'DisableEnclosureDownload'
$expectedValue = 1

# Try to get the registry value
try {
    $registryValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
} catch {
    Write-Host "Registry path not found: $registryPath"
    Write-Host "Please ensure that the policy path 'Prevent downloading of enclosures' is set to 'Enabled'"
    Exit 1
}

# Check if the registry value is as expected
if ($registryValue.$registryValueName -eq $expectedValue) {
    Write-Host "Audit Passed: 'Prevent downloading of enclosures' is enabled as expected."
    Exit 0
} else {
    Write-Host "Audit Failed: 'Prevent downloading of enclosures' is not set as expected."
    Write-Host "Please manually verify and ensure that the policy is enabled."
    Exit 1
}
# ```
