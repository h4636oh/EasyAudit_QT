# This script audits the 'Enforce password history' policy setting.
# It checks that the setting is configured to remember 24 or more passwords.

# Define the expected number of passwords to remember
$expectedPasswordHistoryCount = 24

# Function to get the current 'Enforce password history' setting from the local security policy
function Get-PasswordHistorySetting {
    try {
        # The path to the registry where password policy is stored
        $passwordPolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

        # Retrieve the password history setting (which may be located under Local Group Policy settings in some cases)
        $passwordHistory = (Get-ItemProperty -Path $passwordPolicyPath -Name "EnforcePasswordHistory" -ErrorAction Stop).EnforcePasswordHistory
        
        # Return the setting
        return [int]$passwordHistory
    } catch {
        Write-Output "Error retrieving password history setting: $_"
        return $null
    }
}

# Main script execution
$passwordHistorySetting = Get-PasswordHistorySetting

if ($passwordHistorySetting -eq $null) {
    Write-Output "Failed to retrieve password history setting."
    Exit 1
} elseif ($passwordHistorySetting -ge $expectedPasswordHistoryCount) {
    Write-Output "Audit Passed: 'Enforce password history' is set to $passwordHistorySetting password(s)."
    Exit 0
} else {
    Write-Output "Audit Failed: 'Enforce password history' is set to $passwordHistorySetting password(s), which is less than the expected $expectedPasswordHistoryCount."
    Write-Output "Please manually set the policy through the Group Policy Management Console as per the remediation instructions."
    Exit 1
}
