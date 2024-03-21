# Start the Clock app
Start-Process ms-clock:

# Wait for 10 seconds (adjust the duration as needed)
Start-Sleep -Seconds (Get-Random -Minimum 10 -Maximum 21)

# Find and close the Clock app window
Get-Process | Where-Object {$_.MainWindowTitle -like "*Clock*"} | ForEach-Object {
    $_.CloseMainWindow()
}

# Logging starts here
# Get VM unique identifier, current time, and script name
$vmID = (Get-WmiObject -Class Win32_ComputerSystem).Name
$currentTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$scriptName = $MyInvocation.MyCommand.Name

# Define the path for the log file
$logPath = "C:\Users\User1\Desktop\logs\logFile.log"

# Format the log entry
$logEntry = "VM ID: $vmID, Time: $currentTime, Script: $scriptName"

# Write log entry to the log file
Add-Content -Path $logPath -Value $logEntry


Write-Host "Log file saved."

