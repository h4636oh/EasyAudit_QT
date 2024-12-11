#```powershell
# PowerShell 7 Script to Audit the Configuration of PowerShell Transcription
# Assumption: The script checks if the registry setting for PowerShell Transcription is set to Enabled.

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
$valueName = "EnableTranscripting"

# Attempt to get the registry value
try {
    $regValue = Get-ItemProperty -Path $registryPath -ErrorAction Stop
    $isEnabled = $regValue.$valueName
} catch {
    # If there's an error accessing the registry path, assume the policy is not enabled
    Write-Host "Policy setting for 'Turn on PowerShell Transcription' is not set (registry path not found). It should be Enabled."
    # Exit with status 1 indicating audit failure
    exit 1
}

# Check the value of EnableTranscripting and determine if it matches the recommended setting
if ($isEnabled -eq 1) {
    Write-Host "Policy setting for 'Turn on PowerShell Transcription' is correctly set to 'Enabled'."
    # Exit with status 0 indicating audit success
    exit 0
} else {
    Write-Host "Policy setting for 'Turn on PowerShell Transcription' is not set to 'Enabled'. Please configure it manually."
    # Provide prompt for manual configuration since this script is audit only
    Write-Host "Go to: Computer Configuration > Policies > Administrative Templates > Windows Components > Windows PowerShell > Turn on PowerShell Transcription and set to 'Enabled'."
    # Exit with status 1 indicating audit failure
    exit 1
}
# ```
