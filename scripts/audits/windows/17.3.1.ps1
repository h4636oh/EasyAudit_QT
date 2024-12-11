#```powershell
# Script to audit 'Audit PNP Activity' is set to include 'Success'
# This script audits the setting using `auditpol` and prompts the user if manual verification is required.

# Define the required log inclusion
$requiredSetting = "Success"

# Function to check the current audit policy setting for PNP Activity
function Check-PNPActivityAudit {
    $auditResult = auditpol /get /subcategory:"PNP Activity"
    # Extract the setting using a regex match, assuming auditpol returns a standard result
    if ($auditResult -match "PNP Activity[\s]+:\s+(\w+)") {
        return $matches[1]
    } else {
        Write-Host "Could not determine PNP Activity Audit setting."
        return $null
    }
}

# Execute the check
$currentSetting = Check-PNPActivityAudit

if ($null -eq $currentSetting) {
    Write-Host "Audit: Unable to determine the current setting. Please verify manually."
    exit 1
}

# Compare the result with the required setting
if ($currentSetting -eq $requiredSetting) {
    Write-Host "Audit Passed: 'Audit PNP Activity' is set to include 'Success'."
    exit 0
} else {
    Write-Host "Audit Failed: 'Audit PNP Activity' is not set to 'Success'. Current Setting: $currentSetting"
    # Prompt the user for manual verification as well (if necessary)
    Write-Host "Please ensure manually that 'Audit PNP Activity' is set to include 'Success'."
    exit 1
}
# ```
# 
# This script uses `auditpol.exe` to check the audit setting for "PNP Activity". It then checks if the setting is configured to "Success". If it cannot ascertain the setting or if the setting is incorrect, it prompts the user to manually verify the configuration. It exits with status 0 for a pass and 1 for a fail, fulfilling the given audit-only requirement.
