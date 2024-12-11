#```powershell
# Script to audit the policy setting for scanning removable drives using Microsoft Defender Antivirus
# Ensure this script is executed with administrative privileges

# Define the registry path and value name
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Scan'
$valueName = 'DisableRemovableDriveScanning'

# Get the current registry value
try {
    $currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "Registry key or value not found. Assumed default setting is Disabled."
    exit 1
}

# Check the value of DisableRemovableDriveScanning
if ($currentValue.$valueName -eq 0) {
    Write-Host "Audit Passed: Scanning of removable drives is enabled."
    exit 0
} else {
    Write-Host "Audit Failed: Scanning of removable drives is not enabled."
    
    # Prompt user to manually check and set the Group Policy
    Write-Host "Please manually set the following Group Policy to Enabled:"
    Write-Host @" 
    Computer Configuration\Policies\Administrative Templates\Windows Components\Microsoft Defender Antivirus\Scan\Scan removable drives
"@
    exit 1
}
# ```
# 
