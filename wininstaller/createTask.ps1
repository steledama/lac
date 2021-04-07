# Create a new task action
    $taskAction = New-ScheduledTaskAction `
        -Execute '"C:\Program Files\nodejs\node.exe"' `
        -Argument 'C:\LAC\scheduled.js'
    $taskAction
# Create a new trigger (Daily at time of installation)
    $time = Get-Date -DisplayHint time
    $taskTrigger = New-ScheduledTaskTrigger -Daily -At $time
    $tasktrigger
# Register the new Node scheduled task
# The name of your scheduled task.
    $taskName = "LAC"
# Describe the scheduled task.
    $description = "LAC MFP supplies and usage monitoring system"
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