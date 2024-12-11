#```powershell
# Script to audit the maximum log file size for the Application event log. 
# It checks if the size is set to 32,768 KB or greater as per the recommendations.

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$registryValueName = "MaxSize"
$requiredMinSizeKB = 32768

# Check if the registry path exists
if (Test-Path $registryPath) {
    # Retrieve the current maximum log size from the registry
    $currentLogSizeKB = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $registryValueName

    if ($currentLogSizeKB -ge $requiredMinSizeKB) {
        Write-Output "Audit Passed: Maximum log file size is set to $currentLogSizeKB KB."
        exit 0
    }
    else {
        Write-Output "Audit Failed: Maximum log file size is set to $currentLogSizeKB KB, which is less than the required $requiredMinSizeKB KB."
        exit 1
    }
} 
else {
    Write-Output "Audit Failed: The registry path $registryPath does not exist. This suggests that the policy is not configured via Group Policy."
    exit 1
}
# ```
