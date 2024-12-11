#```powershell
# Define the subcategory to audit
$Subcategory = "Security Group Management"

# Function to check audit policy
function Check-AuditPolicy {
    param(
        [string]$Subcategory
    )

    # Get the current status of the audit policy for the specified subcategory
    $policyStatus = & auditpol /get /subcategory:$Subcategory

    # Check if the audit policy includes "Success"
    if ($policyStatus -match "Success") {
        Write-Output "Audit policy for '$Subcategory' is set to include Success."
        return $true
    } else {
        Write-Output "Audit policy for '$Subcategory' does not include Success."
        return $false
    }
}

# Perform the audit check
$AuditResult = Check-AuditPolicy -Subcategory $Subcategory

# Exit with proper status code
if ($AuditResult) {
    exit 0  # Audit passed
} else {
    Write-Host "Manual Review Required: Ensure 'Audit Security Group Management' is set to 'Success'. Follow the UI Path described in the remediation section."
    exit 1  # Audit failed
}
# ```
# 
# This script checks if the audit policy for "Security Group Management" includes "Success". If it does, the script exits with code 0, indicating the audit passed. If not, it prompts the user to manually ensure that the audit setting is configured as recommended and exits with code 1.
