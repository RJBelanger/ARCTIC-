# Open Control Panel
Start-Process "control.exe" 

# Generate random wait time between 10 to 20 seconds
$waitTime = Get-Random -Minimum 10 -Maximum 20

# Wait for the random time
Start-Sleep -Seconds $waitTime

# Find the Control Panel window process
$controlPanelProcess = Get-Process | Where-Object { $_.MainWindowTitle -like "*Control Panel*" }

# Close Control Panel window if found
if ($controlPanelProcess -ne $null) {
    Stop-Process -Id $controlPanelProcess.Id -Force
} else {
    Write-Host "Control Panel process not found."
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