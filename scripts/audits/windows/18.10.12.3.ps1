#```powershell
# PowerShell 7 Script to Audit Group Policy Setting for 'Turn off Microsoft consumer experiences'

# Define the registry path and key
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$registryKey = "DisableWindowsConsumerFeatures"

# Function to check the registry setting
function Check-RegistrySetting {
    try {
        # Get the current registry value
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction Stop

        # Check if the value is set to 1
        if ($currentValue.$registryKey -eq 1) {
            Write-Host "Audit Passed: 'Turn off Microsoft consumer experiences' is enabled." -ForegroundColor Green
            exit 0
        }
        else {
            Write-Host "Audit Failed: 'Turn off Microsoft consumer experiences' is not enabled." -ForegroundColor Red
            exit 1
        }
    }
    catch {
        Write-Host "Audit Failed: Unable to retrieve the registry setting. Manual check may be required." -ForegroundColor Yellow
        Write-Host "Please navigate to 'Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\Cloud Content' and manually verify." -ForegroundColor Yellow
        exit 1
    }
}

# Execute the audit check
Check-RegistrySetting
# ```
