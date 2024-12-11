# PowerShell script to audit the registry setting for "Turn off the advertising ID".

# Define the registry key and value to check
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
$registryValueName = "DisabledByGroupPolicy"
$expectedValue = 1

# Check if the registry path exists
if (-not (Test-Path $registryPath)) {
    Write-Error "The registry path does not exist: $registryPath"
    Write-Output "Please ensure that the Group Policy setting 'Turn off the advertising ID' is applied."
    Exit 1
}

# Try to get the current registry value
try {
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
} catch {
    Write-Error "Failed to retrieve the registry value. Ensure that the registry path exists and you have the necessary permissions."
    Write-Output "Please verify manually that the Group Policy setting 'Turn off the advertising ID' is Enabled."
    Exit 1
}

# Check if the registry value matches the expected value
if ($currentValue.$registryValueName -eq $expectedValue) {
    # Audit passes
    Write-Output "'Turn off the advertising ID' is set correctly."
    Exit 0
} else {
    # Audit fails
    Write-Error "'Turn off the advertising ID' is NOT set as expected."
    Write-Output "Please ensure the Group Policy path: 'Computer Configuration\\Policies\\Administrative Templates\\System\\User Profiles\\Turn off the advertising ID' is set to 'Enabled'."
    Exit 1
}
