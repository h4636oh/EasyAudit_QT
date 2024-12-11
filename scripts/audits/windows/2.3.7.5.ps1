#```powershell
# Audit Script for 'Interactive logon: Message text for users attempting to log on'

# Define registry path and key
$registryPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$registryKey = 'LegalNoticeText'

# Attempt to retrieve the registry value
try {
    $regValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction Stop
} catch {
    Write-Output "Registry key not found. Please ensure the setting exists."
    exit 1
}

# Check if the LegalNoticeText is set to a non-empty value
if ($null -ne $regValue.$registryKey -and $regValue.$registryKey.Trim() -ne '') {
    Write-Output "Audit Passed: Legal Notice Text is configured."
    exit 0
} else {
    Write-Output "Audit Failed: Legal Notice Text is not configured."
    Write-Output "Please manually set the policy at: Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options\\Interactive logon: Message text for users attempting to log on."
    exit 1
}
# ```
# 
# This script examines the specified registry key to determine if the legal notice text is properly set. It outputs audit results and prompts the user to manually configure the policy if it is not set.
