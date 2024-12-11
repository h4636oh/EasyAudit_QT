#```powershell
# This script audits whether the 'Audit Group Membership' setting is configured to include 'Success'.
# It checks the audit settings using the `auditpol.exe` command.

# Execute the auditpol command to check current settings for 'Group Membership'
$auditResult = & auditpol /get /subcategory:"Group Membership"

# Check if the 'Success' auditing is enabled
if ($auditResult -match 'Success') {
    Write-Host "Audit Group Membership is correctly set to include 'Success'."
    exit 0  # Audit passes
} else {
    Write-Host "Audit Group Membership is NOT set to include 'Success'. Please configure it manually."
    Write-Host "Navigate to: Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Advanced"
    Write-Host "Audit Policy Configuration\\Audit Policies\\Logon/Logoff\\Audit Group Membership and include 'Success'."
    exit 1  # Audit fails
}
# ```
