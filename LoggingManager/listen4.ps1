# Listen on port 5000
$listener = New-Object System.Net.Sockets.TcpListener '0.0.0.0', 5000
$listener.Start()

Write-Host "Server is listening..."

while ($true) {
    try {
        $client = $listener.AcceptTcpClient()
        $stream = $client.GetStream()
        $buffer = New-Object System.Byte[] 1024
        $receivedData = ""
        $encoding = New-Object System.Text.ASCIIEncoding

        do {
            $read = $stream.Read($buffer, 0, $buffer.Length)
            $receivedData += $encoding.GetString($buffer, 0, $read)
        }
        while ($stream.DataAvailable)

        # Assume receivedData contains the latest log line
        if ($receivedData -match 'VM ID: ([^\,]+),') {
            $vmID = $matches[1].Trim()

            # Dynamically get the Desktop path
            $desktopPath = [System.Environment]::GetFolderPath('Desktop')
            # Combine the Desktop path with your log file directory and name
            $logFilePath = Join-Path -Path $desktopPath -ChildPath "LogsReceived\$vmID.log"

            # Ensure the LogsReceived directory exists on the Desktop
            $logDir = Join-Path -Path $desktopPath -ChildPath "LogsReceived"
            if (-not (Test-Path -Path $logDir)) {
                New-Item -Path $logDir -ItemType Directory | Out-Null
            }

            # Append the received log line to the VM's log file
            $receivedData | Out-File -FilePath $logFilePath -Append
            Write-Host "Log line for VM $vmID appended."
        }
    } catch {
        Write-Host "An error occurred: $_"
    } finally {
        if ($client -ne $null) {
            $client.Close()
        }
    }
}

$listener.Stop()
