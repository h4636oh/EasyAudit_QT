#```powershell
# Define the registry path and the expected value
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer'
$registryValueName = 'Start'
$expectedValue = 4

# Verify the registry key exists
if (-Not (Test-Path -Path $registryPath)) {
    Write-Host "Audit Failed: Registry path $registryPath does not exist."
    exit 1
}

# Retrieve the current value of the registry setting
$currentValue = (Get-ItemProperty -Path $registryPath -Name $registryValueName).$registryValueName

# Compare the current value against the expected value
if ($currentValue -eq $expectedValue) {
    Write-Host "Audit Passed: '$registryPath\\$registryValueName' is set to the recommended value ($expectedValue)."
    exit 0
} else {
    Write-Host "Audit Failed: '$registryPath\\$registryValueName' is set to $currentValue. Recommended value is $expectedValue."
    Write-Host "Please navigate to the specified UI path in the remediation section and adjust accordingly."
    exit 1
}
# ```
