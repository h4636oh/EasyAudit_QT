#```powershell
# Script to audit the Kerberos encryption types setting

# The required registry path and value
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters"
$ValueName = "SupportedEncryptionTypes"
$ExpectedValue = 2147483640  # Represents AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types

# Check if the registry path exists
if (-Not (Test-Path -Path $RegistryPath)) {
    Write-Output "Registry path does not exist."
    Exit 1
}

# Retrieve the current registry value
$ActualValue = (Get-ItemProperty -Path $RegistryPath -Name $ValueName).$ValueName

# Compare the actual value with the expected value
if ($ActualValue -eq $ExpectedValue) {
    Write-Output "Audit Passed: Kerberos encryption types configured correctly."
    Exit 0
} else {
    Write-Output "Audit Failed: Kerberos encryption types are not configured as expected."
    Write-Output "Manual Action Required: Navigate to 'Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options\\Network security: Configure encryption types allowed for Kerberos' and set it to 'AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types'."
    Exit 1
}
# ```
