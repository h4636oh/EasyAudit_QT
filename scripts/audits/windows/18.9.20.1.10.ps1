#```powershell
# Define the registry path and key
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$registryKey = "NoOnlinePrintsWizard"

# Attempt to get the registry value
try {
    $registryValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction Stop
    # Check if the registry value is set to 1 (Enabled)
    if ($registryValue.$registryKey -eq 1) {
        Write-Host "Audit Passed: 'Turn off the Order Prints picture task' is enabled."
        exit 0 # Audit passed
    } else {
        Write-Host "Audit Failed: 'Turn off the Order Prints picture task' is not enabled."
        exit 1 # Audit failed
    }
} catch {
    # Handle potential errors when accessing the registry
    Write-Host "Audit Failed: Unable to retrieve registry key. Please ensure the key exists and retry."
    exit 1 # Audit failed
}

# Prompt user to manually verify the setting if unable to confirm via script
Write-Host "Manual Check Required: Navigate to 'Computer Configuration\\Policies\\Administrative Templates\\System\\Internet Communication Management\\Internet Communication settings' and ensure 'Turn off the Order Prints picture task' is set to 'Enabled'."
# ```
