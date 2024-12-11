#```powershell
# PowerShell 7 Script to Audit BitLocker Recovery Configuration
# This script audits whether the BitLocker recovery settings are configured
# according to the organization policy, as outlined in the input requirements.

# Define the registry path and key for audit
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$registryKey = "OSActiveDirectoryInfoToStore"

# Initialize audit status
$auditPassed = $false

# Check if the registry key exists and has the correct value
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction SilentlyContinue
    if ($value.$registryKey -eq 1) {
        $auditPassed = $true
    }
}

# Generate audit report and exit based on the audit outcome
if ($auditPassed) {
    Write-Output "Audit passed: BitLocker recovery information is correctly configured in AD DS."
    exit 0
} else {
    Write-Warning "Audit failed: BitLocker recovery information is NOT correctly configured in AD DS."
    Write-Warning "Please manually verify and set the following Group Policy setting:"
    Write-Warning "Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\BitLocker Drive Encryption\\Operating System Drives\\Choose how BitLocker-protected operating system drives can be recovered: Configure storage of BitLocker recovery information to AD DS: Enabled: Store recovery passwords and key packages."
    exit 1
}
# ```
# 
# This script checks the specified registry key to verify that the BitLocker recovery information is stored in Active Directory Domain Services as required. If the setting is correctly configured, the script exits with a status of 0, indicating a successful audit. If not, it prompts the user to manually verify and configure the necessary Group Policy settings, then exits with a status of 1.
