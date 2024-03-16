$hostname ="cbssports.com"

# Use the Test-Connection cmdlet to ping the specific hostname
$pingResult = Test-Connection -ComputerName $hostname -Count 4

# Display the results
if ($pingResult) {
    Write-Host "Ping to $hostname successful!"
    Write-Host "Average Response Time: $($pingResult.AverageRoundTripTime) ms"
} else {
    Write-Host "Ping to $hostname failed."
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