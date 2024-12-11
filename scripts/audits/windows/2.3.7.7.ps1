#```powershell
# Define the registry path to check the policy setting
$regPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
$regName = 'PasswordExpiryWarning'

# Define the acceptable range for the policy setting
$minDays = 5
$maxDays = 14

try {
    # Retrieve the registry value for PasswordExpiryWarning
    $currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
    
    # Check if the retrieved value falls within the recommended range
    if ($currentValue.$regName -ge $minDays -and $currentValue.$regName -le $maxDays) {
        Write-Output "Audit Passed: Password expiry warning is configured correctly between $minDays and $maxDays days."
        exit 0
    } else {
        Write-Output "Audit Failed: Password expiry warning ($($currentValue.$regName) days) is not configured within the recommended range ($minDays - $maxDays days)."
        exit 1
    }
} catch {
    Write-Output "Audit Failed: Unable to retrieve the PasswordExpiryWarning setting from $regPath. Please ensure the path and setting exist."
    exit 1
}

# Note for the auditor if manual check is required
Write-Output "Manual Action Required: Navigate to 'Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options' and verify 'Interactive logon: Prompt user to change password before expiration' is set to between 5 and 14 days."
# ```
