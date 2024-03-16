# Start the Photos app
Start-Process ms-photos:

# Wait for 10 seconds (adjust the duration as needed)
Start-Sleep -Seconds (Get-Random -Minimum 10 -Maximum 21)

# Find and close the Photos app window
Get-Process | Where-Object {$_.MainWindowTitle -like "*Photos*"} | ForEach-Object {
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