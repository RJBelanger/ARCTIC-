class Agent{

    [int32]$time

    Agent(){}


    [string] grabUser(){
        $unrefineduser = whoami.exe
        $userArr = $unrefineduser -split "\\"
        return $userArr[1]
    }

    # sleep():
    # select a "random" time from 30 to 120 seconds, sleep for that amount of time
    sleep([int]$min, [int]$max){
        $this.time = Get-Random -Minimum $min -Maximum $max
        Write-Host "Sleeping for" $this.time "seconds"
        Start-Sleep -Seconds $this.time
        
    }
    # collect a list of scripts from the \scripts directory
    [string[]] collectFiles([string]$dir) {    
        $unrefinedList = Get-ChildItem -Path $dir -File
        $list = @($unrefinedList.FullName) 
        return $list
    }

    [Object] randomChoice([string[]]$list){
        return $choice = Get-Random -InputObject $list
    }

}

$NewAgent = New-Object -TypeName Agent
$user = $NewAgent.grabUser()
$good_actions = $NewAgent.collectFiles("C:\Users\$($user)\Documents\Safe Scripts")
$bad_actions = $NewAgent.collectFiles("C:\Users\$($user)\Documents\MalwareBundle")


$weighted_list = @()
$good_weight = 10
$bad_weight = 1


foreach($action in $good_actions) {
    for($i = 0; $i -lt $good_weight; $i++) {
        $weighted_list += $action
    }
}


foreach($action in $bad_actions) {
    for($i = 0; $i -lt $bad_weight; $i++) {
        $weighted_list += $action
    }
}

Write-Host "Starting Pseudo-User Actions..."

while(1){
    $NewAgent.sleep(10,20)
    $choice = $NewAgent.randomChoice($weighted_list)
    $path = $choice
    Write-Host "Executing $choice"
    & $path
}




#Write-Host $list[0]