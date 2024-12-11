#```powershell
# This script audits the registry setting for the logon message title.
# It checks if the registry value at the specified location is set and prompts for user confirmation.

# Constants for registry path and entry
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$registryName = "LegalNoticeCaption"

try {
    # Attempt to retrieve the registry value
    $logonMessageTitle = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction Stop

    if ($null -ne $logonMessageTitle.$registryName -and $logonMessageTitle.$registryName -ne "") {
        Write-Host "Audit Passed: Logon message title is set to '$($logonMessageTitle.$registryName)'."
        exit 0
    } else {
        Write-Host "Audit Failed: Logon message title is not set." -ForegroundColor Red
        Write-Host "Please manually verify and configure the logon message title as per your organization's policy."
        exit 1
    }
} catch {
    Write-Host "Audit Failed: Unable to read the registry key or it does not exist." -ForegroundColor Red
    Write-Host "Ensure the registry path is correct and verify the logon message title manually."
    exit 1
}
# ```
# 
