#```powershell
# This script audits if the 'Audit Authorization Policy Change' is set to include 'Success'.
# It uses the auditpol.exe command to check the current policy setting and prompts the user
# if manual verification is needed.

# Importing common Windows modules
Import-Module -Name Microsoft.PowerShell.Security

# Function to check the 'Audit Authorization Policy Change' setting
function Test-AuditAuthorizationPolicyChange {
    try {
        # Execute auditpol command to check the current setting
        $auditPolicy = auditpol /get /subcategory:"Authorization Policy Change"
        
        # Define a regex to find 'Success' in the audit policy output
        $successRegex = '(?i)Success'

        # Check if 'Success' is included in the policy settings
        if ($auditPolicy -match $successRegex) {
            Write-Host "Audit Authorization Policy Change is set to include 'Success'."
            return $true
        } else {
            Write-Host "Audit Authorization Policy Change is NOT set to include 'Success'."
            return $false
        }
    } catch {
        # Handle any exceptions that occur during auditing
        Write-Error "An error occurred while checking the audit policy: $_"
        return $false
    }
}

# Function to run the audit check and produce the appropriate exit code
function Run-AuditCheck {
    # Run the audit check
    $isConfiguredCorrectly = Test-AuditAuthorizationPolicyChange

    # Prompt the user for manual verification if necessary and handle the result
    if (-not $isConfiguredCorrectly) {
        Write-Host "Please verify manually at the UI path:"
        Write-Host "Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Advanced Audit Policy Configuration\\Audit Policies\\Policy Change\\Audit Authorization Policy Change"
        Write-Host "Ensure it is set to include 'Success'."
        exit 1
    } else {
        exit 0
    }
}

# Execute the audit check
Run-AuditCheck
# ```
# 
# This script follows your requirements by performing a check using the `auditpol` command, checking if the 'Success' condition is met, prompting the user for manual verification if necessary, and exiting with the appropriate status code. It adheres to best practices and utilizes PowerShell 7 syntax.
