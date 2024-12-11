#```powershell
# PowerShell 7 Script to Audit Script Scanning Configuration
# This script audits whether 'Turn on script scanning' is set to 'Enabled'.
# Instruction: Navigate to the specified UI path in the Group Policy Editor to manually verify setting.
# Requirement: Exit 0 if the audit is passed, and exit 1 if it fails.

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"
$registryValueName = "DisableScriptScanning"
$expectedValue = 0

# Check if the registry key exists
if (Test-Path $registryPath) {
    try {
        # Fetch the actual value from the registry
        $actualValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
        if ($actualValue.$registryValueName -eq $expectedValue) {
            Write-Output "Audit Passed: 'Turn on script scanning' is Enabled."
            exit 0
        } else {
            Write-Output "Audit Failed: 'Turn on script scanning' is not set to Enabled. Manual verification needed."
            exit 1
        }
    } catch {
        Write-Output "Audit Failed: Unable to retrieve the registry value. Manual verification needed."
        exit 1
    }
} else {
    Write-Output "Audit Failed: Registry path not found. Manual verification needed."
    exit 1
}

# Reminder for manual verification
Write-Output "Please verify manually via the UI path in Group Policy Editor:
Computer Configuration > Policies > Administrative Templates > Windows Components > Microsoft Defender Antivirus > Real-Time Protection > Turn on script scanning."
exit 1
# ```
