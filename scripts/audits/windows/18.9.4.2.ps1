#```powershell
<#
.SYNOPSIS
    Audit if 'Remote host allows delegation of non-exportable credentials' is enabled.

.DESCRIPTION
    This script checks if the policy 'Remote host allows delegation of non-exportable credentials'
    is enabled by verifying the corresponding registry setting. It audits without remediating.

.EXITS
    0 if the audit passes (the setting is enabled).
    1 if the audit fails (the setting is not enabled).
#>

try {
    # Define registry path and value name
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation"
    $valueName = "AllowProtectedCreds"

    # Attempt to get the registry value
    $regValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop

    # Check if the registry value equals 1 (enabled)
    if ($regValue.$valueName -eq 1) {
        Write-Host "Audit Passed: 'Remote host allows delegation of non-exportable credentials' is enabled."
        exit 0
    }
    else {
        Write-Host "Audit Failed: 'Remote host allows delegation of non-exportable credentials' is not enabled."
        exit 1
    }
}
catch {
    Write-Host "Audit Failed: Unable to access registry path or value. Please verify access permissions."
    exit 1
}

# Prompt the user to manually verify the setting in group policy if registry access fails.
Write-Host "Please manually verify the setting via Group Policy:"
Write-Host " Navigate to Computer Configuration -> Policies -> Administrative Templates -> System -> Credentials Delegation"
Write-Host " Ensure 'Remote host allows delegation of non-exportable credentials' is set to 'Enabled'."
# ```
