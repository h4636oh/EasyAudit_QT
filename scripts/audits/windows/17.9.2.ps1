#```powershell
# PowerShell 7 script to audit "Audit Other System Events" for Success and Failure

# Check the current audit policy for "Other System Events"
function Check-OtherSystemEventsAuditPolicy {
    $auditPolicy = & auditpol /get /subcategory:"Other System Events" 2>&1

    if ($auditPolicy -match "Success and Failure") {
        Write-Host "Audit policy for 'Other System Events' is set to 'Success and Failure'."
        return $true
    } elseif ($auditPolicy -match "Success") {
        Write-Host "Audit policy for 'Other System Events' is set only to 'Success'."
        return $false
    } elseif ($auditPolicy -match "Failure") {
        Write-Host "Audit policy for 'Other System Events' is set only to 'Failure'."
        return $false
    } else {
        Write-Host "Audit policy for 'Other System Events' is not correctly set."
        return $false
    }
}

# Main script logic
$result = Check-OtherSystemEventsAuditPolicy

if ($result) {
    # Audit passed
    Write-Host "Audit successful. The system is configured as recommended."
    exit 0
} else {
    # Audit failed
    Write-Host "Audit failed. The system configuration does not match the recommended settings."
    Write-Host "Please manual review via UI Path: Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Advanced Audit Policy Configuration -> Audit Policies -> System -> Audit Other System Events"
    exit 1
}
# ```
# 
# This script checks the current audit setting for "Other System Events" using `auditpol.exe` and verifies if it's set to "Success and Failure". If it meets the criteria, it exits with status 0 indicating the audit passed. If not, it prompts the user to manually check the settings in the GUI and exits with status 1 indicating the audit failed.
