#```powershell
# PowerShell Script to Audit 'Minimum password age' Policy Setting
# This script checks if the Minimum password age is set to 1 or more days in the Default Domain Policy GPO
# It exits with status 0 if compliant and status 1 if not compliant.

# Function to get the current Minimum Password Age Policy
function Get-MinimumPasswordAgePolicy {
    try {
        # Using Get-ADDefaultDomainPasswordPolicy cmdlet to retrieve the minimum password age setting
        $passwordPolicy = Get-ADDefaultDomainPasswordPolicy -ErrorAction Stop
        return $passwordPolicy.MinPasswordAge.Days
    }
    catch {
        # PowerShell error handling
        Write-Host "Error: Unable to retrieve the password policy. Ensure you have the necessary permissions."
        exit 1
    }
}

# Retrieve the current minimum password age
$currentMinPasswordAge = Get-MinimumPasswordAgePolicy

# Check if the current minimum password age is compliant
if ($currentMinPasswordAge -ge 1) {
    Write-Host "Audit Passed: The Minimum password age is set to $currentMinPasswordAge day(s), which is compliant."
    exit 0
} else {
    Write-Host "Audit Failed: The Minimum password age is set to $currentMinPasswordAge day(s), which is not compliant."
    Write-Host "Please navigate to Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Account Policies\\Password Policy\\Minimum password age"
    Write-Host "and set it to 1 or more day(s) manually."
    exit 1
}
# ```
