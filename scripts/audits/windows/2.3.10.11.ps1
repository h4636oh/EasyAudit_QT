#```powershell
# Script to audit the setting for 'Network access: Shares that can be accessed anonymously'

# Define the registry path and key
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$keyName = "NullSessionShares"

# Attempt to retrieve the registry value
try {
    $nullSessionShares = Get-ItemProperty -Path $registryPath -Name $keyName -ErrorAction Stop
} catch {
    Write-Host "Failed to retrieve registry key: $registryPath\$keyName"
    return 1
}

# Check if the registry value is blank (no shares can be accessed anonymously)
if ($nullSessionShares.$keyName -eq $null -or $nullSessionShares.$keyName -eq "") {
    Write-Host "Audit Passed: 'Network access: Shares that can be accessed anonymously' is set to 'None'."
    exit 0
} else {
    Write-Host "Audit Failed: 'Network access: Shares that can be accessed anonymously' has the following entries:"
    $nullSessionShares.$keyName
    Write-Host "Please manually verify and ensure it is set to 'None' (i.e., Blank)."
    exit 1
}
# ```
# 
# This PowerShell 7 script audits the specified registry setting to ensure it matches the recommended configuration of 'None', indicating no network shares are accessible anonymously. If the audit determines that no values are present (as they should be), it exits with a success code (0). Otherwise, it displays a failure message and exits with a code of 1. If there's any issue reading the registry, the script will also indicate failure and return an error code.
