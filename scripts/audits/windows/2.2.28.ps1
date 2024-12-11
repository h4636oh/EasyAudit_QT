#```powershell
# This script audits the 'Log on as a batch job' user rights assignment to ensure it is set to 'Administrators'.
# It adheres to Level 2 (L2) High Security/Sensitive Data Environment standards.

# Function to check the 'Log on as a batch job' assignments
function Audit-LogonAsBatchJob {
    # PowerShell command to get user rights assignments for 'Log on as a batch job'
    $batchJobRight = 'SeBatchLogonRight'
    $expectedUsers = @('Administrators')

    # Get the current assignments for 'Log on as a batch job'
    $assignedUsers = (Get-LocalUserRight -Right $batchJobRight).Account

    # Check if only the 'Administrators' group is assigned
    if ($assignedUsers -contains 'BUILTIN\Administrators' -and $assignedUsers.Count -eq 1) {
        Write-Output "Audit Passed: 'Log on as a batch job' is correctly assigned to 'Administrators'."
        exit 0
    } else {
        Write-Output "Audit Failed: 'Log on as a batch job' is not correctly assigned."
        Write-Output "Assigned users/groups: $assignedUsers"
        Write-Output "Please manually update the configuration as per the remediation steps: "
        Write-Output "Navigate to: Computer Configuration\\Windows Settings\\Security Settings\\Local Policies\\User Rights Assignment\\Log on as a batch job"
        Write-Output "Set it to 'Administrators' only."
        exit 1
    }
}

# Function to get local user rights
function Get-LocalUserRight {
    param (
        [string]$Right
    )
    # Retrieve user rights policy from the SecurityDescriptor property
    $seceditOutput = & secedit /export /cfg $env:TEMP\secedit.inf /areas USER_RIGHTS
    $config = Get-Content $env:TEMP\secedit.inf
    $userRightLine = $config | Select-String -Pattern "($Right=)"
    
    # Parse accounts assigned to the right
    if ($userRightLine) {
        $accounts = $userRightLine -replace ".*=$Right=", "" -split ','
        return [pscustomobject]@{ Account = $accounts }
    } else {
        Write-Warning "Unable to find the user right: $Right"
        return $null
    }
}

# Run the audit function
Audit-LogonAsBatchJob
# ```
# 
# This script functions to audit whether the "Log on as a batch job" user right is assigned solely to the "Administrators" group, following the high-security guidelines specified. It returns the assigned groups and suggests manual remediation steps if the configuration does not meet the recommended state.
