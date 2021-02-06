# Install nodejs with Chocolatey
    $Packages = 'nodejs'
    If(Test-Path -Path "$env:ProgramData\Chocolatey") {
    # DoYourPackageInstallStuff
    ForEach ($PackageName in $Packages)
        {
            choco install $PackageName -y
        }
    }
    Else {
    # InstallChoco
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))      

    # DoYourPackageInstallStuff
    ForEach ($PackageName in $Packages)
        {
            choco install $PackageName -y
        }
    }
#install npm modules
    Set-Location -Path C:\lac
    npm install
# Create a new task action
    $taskAction = New-ScheduledTaskAction `
        -Execute 'node' `
        -Argument '-File C:\LAC\lac.js'
    $taskAction
# Create a new trigger (Daily at time of installation)
    $time = Get-Date -DisplayHint time
    $taskTrigger = New-ScheduledTaskTrigger -Daily -At $time
    $tasktrigger
# Register the new Node scheduled task
# The name of your scheduled task.
    $taskName = "LAC"
# Describe the scheduled task.
    $description = "Multi Function Printer (MFP) consumables and page monitoring system"
# Register the scheduled task
    Register-ScheduledTask `
        -TaskName $taskName `
        -Action $taskAction `
        -Trigger $taskTrigger `
        -Description $description
#Configure Scheduled Task
    $Task = Get-ScheduledTask -TaskName "LAC"
    $Task.Triggers.Repetition.Interval = "PT4H"
#Update Scheduled Task
    $Task | Set-ScheduledTask -User "NT AUTHORITY\SYSTEM"