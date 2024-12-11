#```powershell
# PowerShell 7 Script to Audit 'Audit Security State Change' Setting

# Define the subcategory to audit
$subcategory = "Security State Change"

try {
    # Execute the auditpol command to check the current audit settings
    $auditPolOutput = auditpol /get /subcategory:$subcategory 2>&1

    # Check if auditpol command was successful
    if ($auditPolOutput -is [string] -and (($auditPolOutput -match "Success") -or ($auditPolOutput -match "SUCCESS"))) {
        Write-Output "Audit for 'Security State Change' is set correctly to include 'Success'."
        exit 0
    } else {
        Write-Warning "Audit for 'Security State Change' is not set to include 'Success'. Please configure it manually."
        Write-Warning "Refer to the UI path in the remediation section to configure via Group Policies or consult relevant documentation."
        exit 1
    }
} catch {
    Write-Error "An error occurred while attempting to audit: $_"
    exit 1
}
# ```
