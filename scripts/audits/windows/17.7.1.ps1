#```powershell
# PowerShell 7 script to audit audit policy settings for 'Audit Policy Change'

# Define the subcategory to be checked
$subcategory = "Audit Policy Change"

# Run auditpol to get the current settings for the specified subcategory
$auditPolOutput = & auditpol.exe /get /subcategory:"$subcategory"

# Check if the settings include 'Success'
if ($auditPolOutput -match "Success")
{
    Write-Output "Audit Policy Change is set to include 'Success'. Audit Passed."
    exit 0
}
else
{
    Write-Output "Audit Policy Change does not include 'Success'. Please review settings."
    Write-Host "Navigate to the UI Path in the Remediation section and confirm it is set as prescribed: "
    Write-Host "Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Advanced Audit Policy Configuration\\Audit Policies\\Policy Change\\Audit Audit Policy Change"
    exit 1
}

# Note: If auditpol.exe is not available or the script requires different privileges,
# it may fail. Ensure the script is run with adequate permissions.
# ```
# 
# This script checks the audit settings for "Audit Policy Change" and verifies if it includes "Success." The script will output corresponding messages and exit codes based on the result of the audit. If the required condition is met, it exits with code 0; otherwise, it exits with code 1 and prompts manual review of the UI settings path.
