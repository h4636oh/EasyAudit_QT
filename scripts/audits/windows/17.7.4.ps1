#```powershell
# PowerShell 7 Script to Audit 'Audit MPSSVC Rule-Level Policy Change' Setting

# Function to check the audit setting for 'MPSSVC Rule-Level Policy Change'
function Test-AuditMPSSVCRulePolicyChange {
    try {
        # Run the auditpol command to fetch the current audit policy setting
        $auditResult = auditpol /get /subcategory:"MPSSVC Rule-Level Policy Change" | Select-String -Pattern "Success and Failure"
        
        # Determine if the audit policy is set correctly
        if ($null -ne $auditResult) {
            # If the correct setting is found, exit with code 0 (success)
            Write-Host "Audit setting for 'MPSSVC Rule-Level Policy Change' is correctly set to 'Success and Failure'."
            exit 0
        } else {
            # If the correct setting is not found, exit with code 1 (failure)
            Write-Host "Audit setting for 'MPSSVC Rule-Level Policy Change' is NOT set to 'Success and Failure'."
            exit 1
        }
    } catch {
        # Catch any errors that occur during the execution
        Write-Host "An error occurred while checking the audit settings: $_"
        exit 1
    }
}

# Execute the function
Test-AuditMPSSVCRulePolicyChange
# ```
