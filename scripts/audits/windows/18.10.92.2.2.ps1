#```powershell
# Define the registry path and key for audit
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
$registryValueName = 'ScheduledInstallDay'
$expectedValue = 0

# Function to audit the registry value
function Audit-ScheduledInstallDay {
    # Attempt to get the current value from the registry
    try {
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
    } catch {
        Write-Host "Registry key or value not found. Please ensure that the policy is configured." -ForegroundColor Yellow
        exit 1
    }
    
    # Compare the current value with the expected value
    if ($currentValue.$registryValueName -eq $expectedValue) {
        Write-Host "Audit Passed: 'ScheduledInstallDay' is set to '$expectedValue' (Every Day)." -ForegroundColor Green
        exit 0
    } else {
        Write-Host "Audit Failed: 'ScheduledInstallDay' is not set to '$expectedValue'. Please configure it manually." -ForegroundColor Red
        Write-Host "Navigate to: Computer Configuration\Policies\Administrative Templates\Windows Components\Windows Update\Manage end user experience\Configure Automatic Updates" -ForegroundColor Red
        exit 1
    }
}

# Run the audit function
Audit-ScheduledInstallDay
# ```
