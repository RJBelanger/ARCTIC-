# Start the Settings app
Start-Process ms-settings:

# Wait for another random duration between 10 and 20 seconds
$randomSeconds = Get-Random -Minimum 10 -Maximum 21

# Wait for the random duration
Start-Sleep -Seconds $randomSeconds

# Find and close the Settings app window
Get-Process | Where-Object {$_.MainWindowTitle -like "*Settings*"} | ForEach-Object {
    $_.CloseMainWindow()
}

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