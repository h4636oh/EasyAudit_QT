#```powershell
# PowerShell 7 Script to Audit the 'Network security: Do not store LAN Manager hash value on next password change' Setting

# Variables
$RegistryPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
$RegistryValueName = 'NoLMHash'
$ExpectedValue = 1
$AuditPassed = $false

# Check if the registry key and value exist
if (Test-Path $RegistryPath) {
    $RegistryValue = Get-ItemProperty -Path $RegistryPath -Name $RegistryValueName -ErrorAction SilentlyContinue

    # Audit logic - Check if the setting is set as expected
    if ($RegistryValue -eq $null) {
        Write-Host "Audit Failed: Registry value for '$RegistryValueName' does not exist."
    }
    elseif ($RegistryValue.$RegistryValueName -eq $ExpectedValue) {
        Write-Host "Audit Passed: '$RegistryValueName' is set to the correct value ($ExpectedValue)."
        $AuditPassed = $true
    }
    else {
        Write-Host "Audit Failed: '$RegistryValueName' is set to $($RegistryValue.$RegistryValueName), but $ExpectedValue is expected."
    }
} else {
    Write-Host "Audit Failed: Registry path '$RegistryPath' does not exist."
}

# Exit with appropriate code based on audit result
if ($AuditPassed) {
    exit 0
} else {
    exit 1
}
# ```
