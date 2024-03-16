class Agent{

    [int32]$time

    Agent(){}


    [string] grabUser(){
        $unrefineduser = whoami.exe
        $userArr = $unrefineduser -split "\\"
        return $userArr[1]
    }

    sleep([int]$min, [int]$max){
        $this.time = Get-Random -Minimum $min -Maximum $max
        Write-Host "Sleeping for" $this.time "seconds"
        Start-Sleep -Seconds $this.time
    }

    [string[]] collectFiles([string]$dir){    
        $unrefinedList = Get-ChildItem -Path $dir
        $list = @($unrefinedList.Name)
        return $list
    }

    [Object] randomChoice([string[]]$list){
        return $choice = Get-Random -InputObject $list
    }

}

$NewAgent = New-Object -TypeName Agent
$user = $NewAgent.grabUser()
$scriptDirectory = "$($env:USERPROFILE)\Documents\Safe Scripts"  # Using environment variable to get the user's profile path
$list = $NewAgent.collectFiles($scriptDirectory)
Write-Host "Starting Pseudo-User Actions..."

while($true){
    $NewAgent.sleep(10,20)
    $choice = $NewAgent.randomChoice($list)
    $path = Join-Path -Path $scriptDirectory -ChildPath $choice  # Handles paths with spaces
    Write-Host "Executing $choice"
    & "$path"
}
