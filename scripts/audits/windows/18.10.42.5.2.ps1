#```powershell
# This script audits the 'Join Microsoft MAPS' setting to ensure it is set to 'Disabled'.
# Adheres to Level 2 (L2) - High Security/Sensitive Data Environment specifications

$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet'
$registryName = 'SpynetReporting'
$auditPass = $false

if (Test-Path $registryPath) {
    $regValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue
    if ($null -eq $regValue -or $regValue.$registryName -eq 0) {
        # The setting is either Disabled or the registry key doesn't exist
        $auditPass = $true
    }
}

if ($auditPass) {
    Write-Host "Audit Passed: 'Join Microsoft MAPS' is set to 'Disabled' as required." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Audit Failed: 'Join Microsoft MAPS' is not set to 'Disabled'." -ForegroundColor Red
    # Prompting the user to manually navigate to the GUI to verify and correct the setting if necessary
    Write-Host "Please navigate to Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> Microsoft Defender Antivirus -> MAPS -> Join Microsoft MAPS and ensure it is set to 'Disabled'."
    exit 1
}
# ```
