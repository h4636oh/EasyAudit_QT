#```powershell
# This script audits the 'Special Logon' policy to ensure it is set to include 'Success'.
# The audit is based on the requirement to monitor when special logons, 
# which have administrator-equivalent privileges, occur.

# Function to check Special Logon audit configuration
function Audit-SpecialLogon {
    # Run auditpol command to get Special Logon subcategory status
    $output = & auditpol /get /subcategory:"Special Logon" | Out-String

    # Verify if the current configuration includes 'Success'
    if ($output -match "Success") {
        Write-Output "'Special Logon' is correctly configured to include 'Success'."
        return $true
    } else {
        Write-Output "'Special Logon' is NOT correctly configured. Please configure it to include 'Success'."
        return $false
    }
}

# Perform the audit
$auditResult = Audit-SpecialLogon

# Exit with code 0 if audit passes, and code 1 if it fails
if ($auditResult) {
    exit 0
} else {
    # Prompt the user to manually check the UI Path if the audit fails
    Write-Output "Refer to the UI Path specified in the remediation steps to manually verify and adjust settings if necessary:"
    Write-Output "Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Advanced Audit Policy Configuration\\Audit Policies\\Logon/Logoff\\Audit Special Logon"
    exit 1
}
# ```
