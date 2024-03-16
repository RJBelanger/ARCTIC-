# Function to increase system volume
Function Increase-SystemVolume {
    # Create a COM object to access the Windows Audio API
    $shell = New-Object -ComObject "WScript.Shell"

    # Press the Volume Up key (VK_VOLUME_UP)
    $shell.SendKeys([char]175)
}
$waitTime = Get-Random -Minimum 10 -Maximum 20
Start-Sleep -Seconds $waitTime

# Increase system volume
Increase-SystemVolume

# Output the action performed
Write-Output "Increased system volume"

#Logging starts here
#Get VM unique identifier, current time, and script name
$vmID = (Get-WmiObject -Class Win32_ComputerSystem).Name
$currentTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$scriptName = $MyInvocation.MyCommand.Name

#Get the current user's desktop path
$currentDesktop = [Environment]::GetFolderPath('Desktop')

#Define the path for the log file
$logPath = Join-Path -Path $currentDesktop -ChildPath "logs\logFile.log"

#Create the logs directory if it doesn't exist
if (-not (Test-Path $logPath)) {
    New-Item -Path (Split-Path $logPath) -ItemType Directory -Force
}

#Format the log entry
$logEntry = "VM ID: $vmID, Time: $currentTime, Script: $scriptName"

#Write log entry to the log file
Add-Content -Path $logPath -Value $logEntry

Write-Host "Log file saved."