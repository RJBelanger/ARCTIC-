$serverIP = "192.168.100.7"
$port = 5000

# Using the current user's desktop for the source directory, which makes it more dynamic
$currentUserDesktop = [Environment]::GetFolderPath("Desktop")
$sourceDir = Join-Path -Path $currentUserDesktop -ChildPath "logs"
$timestampFile = Join-Path -Path $sourceDir -ChildPath "lastSentTimestamp.txt"

# Ensure the timestamp file exists
if (-not (Test-Path $timestampFile)) {
    New-Item -Path $timestampFile -ItemType File -Value "1900-01-01 00:00:00"
}

while ($true) {
    # Read the last sent timestamp
    $lastSentTimestamp = Get-Content -Path $timestampFile
    $lastSentDateTime = [datetime]::ParseExact($lastSentTimestamp, "yyyy-MM-dd HH:mm:ss", $null)

    Get-ChildItem -Path $sourceDir -Filter "*.log" | ForEach-Object {
        $filePath = $_.FullName

        # Read only the last line of the log file
        $lastLine = Get-Content -Path $filePath | Select-Object -Last 1

        if ($lastLine) {
            if ($lastLine -match 'Time: ([\d-]+\s[\d:]+)') {
                $logTimestamp = $matches[1]
                $logDateTime = [datetime]::ParseExact($logTimestamp, "yyyy-MM-dd HH:mm:ss", $null)

                if ($logDateTime -gt $lastSentDateTime) {
                    # Log line is new, proceed with sending
                    $client = New-Object System.Net.Sockets.TcpClient($serverIP, $port)
                    $stream = $client.GetStream()
                    $encoder = [System.Text.Encoding]::ASCII
                    $byteData = $encoder.GetBytes($lastLine)
                    $stream.Write($byteData, 0, $byteData.Length)
                    $stream.Close()
                    $client.Close()
                    Write-Host "New log entry sent: $lastLine"

                    # Update last sent timestamp with the current system time
                    $newLastSentTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                    $newLastSentTimestamp | Set-Content -Path $timestampFile
                } else {
                    Write-Host "Log entry is not newer than the last sent. Skipping..."
                }
            } else {
                Write-Host "Timestamp not found in the log line. Skipping..."
            }
        }
    }
    Start-Sleep -Seconds 10 # Check every 10 seconds
}