#```powershell
# PowerShell 7 Script to Audit the 'Allow Suggested Apps in Windows Ink Workspace' Setting

# Define the registry path and value name
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace'
$valueName = 'AllowSuggestedAppsInWindowsInkWorkspace'

# Retrieve the current registry value
try {
    $currentValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop
    $currentSetting = $currentValue.$valueName    
} catch {
    Write-Host "Audit Failed: Unable to retrieve the registry value. Ensure the registry path exists." -ForegroundColor Red
    Exit 1
}

# Define the expected value for compliance
$expectedValue = 0

# Compare the current setting with the expected value
if ($currentSetting -eq $expectedValue) {
    Write-Host "Audit Passed: 'Allow suggested apps in Windows Ink Workspace' is set to 'Disabled'." -ForegroundColor Green
    Exit 0
} else {
    Write-Host "Audit Failed: 'Allow suggested apps in Windows Ink Workspace' is not set to 'Disabled'. Please navigate to Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> Windows Ink Workspace and ensure it is set to 'Disabled'." -ForegroundColor Red
    Exit 1
}
# ```
# 
# This script audits the setting for 'Allow suggested apps in Windows Ink Workspace' by checking the specified registry value. It will exit with code 0 if the audit passes and code 1 if it fails. It also provides guidance for manual verification in the group policy editor, as required.
