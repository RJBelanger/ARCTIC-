# Dynamically get the username and set the path to the directory containing log files
$userName = $ENV:USERNAME
$logDir = "C:\Users\$userName\Desktop\LogsReceived"
# Output file where the results will be saved
$outputFile = "C:\Users\$userName\Desktop\log_check_results.txt"

function Get-LastLogTimestamp {
    param (
        [string]$filePath
    )

    # Read the last line of the file
    $lastLine = Get-Content $filePath -Tail 1
    # Parse the timestamp from the last line
    $timestampStr = ($lastLine -split "Time: ")[1].Split(",")[0].Trim()
    $timestamp = [datetime]::ParseExact($timestampStr, "yyyy-MM-dd HH:mm:ss", $null)

    return $timestamp
}

function Determine-Flag {
    param (
        [datetime]$lastLogTime
    )

    $currentTime = Get-Date
    $timeDifference = $currentTime - $lastLogTime

    if ($timeDifference.TotalMinutes -le 20) {
        return 1

    } elseif ($timeDifference.TotalMinutes -le 60) {
        return 2

    } else {
        return 3
    }
}

function Check-Logs {
    # Ensure output file is cleared before writing new data
    if (Test-Path $outputFile) {
        Remove-Item $outputFile
    }

    Get-ChildItem $logDir -File | ForEach-Object {

        $filePath = $_.FullName
        $lastLogTime = Get-LastLogTimestamp -filePath $filePath
        $flag = Determine-Flag -lastLogTime $lastLogTime

        # Correctly format the VM name and flag output
        $vmName = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
        "${vmName}: ${flag}" | Out-File -FilePath $outputFile -Append
    }
    Write-Host "Log check completed."
}

# Schedule the check logs
Do {
    Check-Logs
    Start-Sleep -Seconds 20
} While ($true)
