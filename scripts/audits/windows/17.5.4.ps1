#```powershell
# PowerShell 7 script to audit 'Audit Logon' setting for Success and Failure

# Function to check 'Audit Logon' settings using auditpol.exe
function Check-AuditLogon {
    # Run auditpol command to get Logon subcategory setting
    $auditLogonSetting = auditpol /get /subcategory:"Logon" | Select-String "Logon" 

    # Check if the current configuration matches 'Success and Failure'
    $isConfiguredCorrectly = $auditLogonSetting -match 'Success and Failure'

    # Return the result
    return $isConfiguredCorrectly
}

# Prompt user if manual UI verification is needed
function Prompt-ManualVerification {
    Write-Host "Please verify the 'Audit Logon' setting manually through the UI:"
    Write-Host "Navigate to: Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Advanced Audit Policy Configuration -> Audit Policies -> Logon/Logoff -> Audit Logon"
    Write-Host "Ensure it is set to 'Success and Failure'."
}

# Perform the audit by calling the check function
$isConfiguredCorrectly = Check-AuditLogon

# Check the result and exit accordingly
if ($isConfiguredCorrectly) {
    Write-Host "Audit Logon is correctly set to 'Success and Failure'."
    exit 0
} else {
    Write-Host "Audit Logon is NOT correctly set. Please verify the settings."
    Prompt-ManualVerification
    exit 1
}
# ```
# 
# This script performs an audit to check if the 'Audit Logon' setting is set to 'Success and Failure' using the `auditpol` command. It then prompts the user for manual verification if the audit fails, complying strictly with the requirement to only audit, not remediating any settings.
