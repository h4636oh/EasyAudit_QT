#```powershell
# This script audits the 'Create global objects' policy setting to ensure it is configured
# to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE' as per recommendations.

# Function to check user rights assignment policy
function Get-UserRightsAssignment {
    param (
        [string]$PolicyName
    )

    try {
        # Get the policy setting value
        $userRights = (Get-LocalGroupPolicy -Name 'User Rights Assignment').GetString($PolicyName)
        return $userRights -join ', '
    } catch {
        Write-Error "Failed to retrieve policy value: $_"
        return $null
    }
}

# Define the expected policy setting
$expectedSetting = 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'

# Define the policy name for 'Create global objects'
$policyName = 'Create global objects'

# Invoke the function to get current policy setting
$currentSetting = Get-UserRightsAssignment -PolicyName $policyName

if ($currentSetting -eq $expectedSetting) {
    Write-Output "SUCCESS: The 'Create global objects' policy is configured correctly."
    exit 0
} else {
    Write-Output "FAILURE: The 'Create global objects' policy is not configured as expected."
    Write-Output "Current setting is: $currentSetting"
    Write-Output "Expected setting is: $expectedSetting"
    Write-Output "Please manually review and update the setting as per the remediation instructions."
    exit 1
}
# ```
# 
### Explanation
# - The script defines a function `Get-UserRightsAssignment` to retrieve the current value of the specified policy.
# - The expected setting for 'Create global objects' is set as 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'.
# - The script compares the current policy settings to the expected ones.
# - Outputs success or failure messages based on the comparison result.
# - Exits with code 0 if the audit passes and with code 1 if the audit fails.
# - Prompts the user to manually review and update the policy if it doesn't meet the expected configuration.
