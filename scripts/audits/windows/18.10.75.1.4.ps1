#```powershell
# PowerShell 7 Script to Audit Enhanced Phishing Protection in Microsoft Defender SmartScreen
# Ensure 'Notify Unsafe App' is enabled in the specified registry location.

# Define the registry path and the required registry value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WTDS\Components"
$registryName = "NotifyUnsafeApp"
$requiredValue = 1

# Check if the registry key exists
if (Test-Path $registryPath) {
    # Retrieve the current value of the registry key
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue

    if ($null -eq $currentValue) {
        Write-Output "The registry key '$registryName' does not exist at the path '$registryPath'. Audit fails."
        exit 1
    }
    elseif ($currentValue.$registryName -eq $requiredValue) {
        Write-Output "Audit passed: The registry key '$registryName' is correctly set to '$requiredValue'."
        exit 0
    }
    else {
        Write-Output "Audit fails: The registry key '$registryName' is set to '$($currentValue.$registryName)', expected '$requiredValue'."
        exit 1
    }
}
else {
    Write-Output "The registry path '$registryPath' does not exist. Audit fails."
    exit 1
}
# ```
