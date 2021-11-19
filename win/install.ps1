
if ((gwmi win32_operatingsystem | Select-Object osarchitecture).osarchitecture -eq "64-bit") {
    $node = "C:\LAC\win\node-v16.13.0-x64.msi"
}
else {
    $node = "C:\LAC\win\node-v16.13.0-x86.msi"
}

# install node
msiexec.exe /passive /i "$node"

# change current working directory
Set-Location -LiteralPath C:\LAC

# install node modules
& "$env:ProgramFiles\nodejs\node.exe" "$env:ProgramFiles\nodejs\node_modules\npm\bin\npm-cli.js" install ##64

# build nextjs production app
& "$env:ProgramFiles\nodejs\node.exe" "C:\LAC\node_modules\next\dist\bin\next" build ##64

# install windows service to start the app
& "$env:ProgramFiles\nodejs\node.exe" "C:\LAC\win\serviceInstall.js" ##64

############################ scheduled task for monitoring #######################################
# Create a new task action
$taskAction = New-ScheduledTaskAction `
    -Execute 'node' `
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
$description = "Snmp agent to monitor remote zabbix hosts"
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
###############################################################################

# add firewall rules
netsh.exe "advfirewall firewall add rule name=""LAC"" program=""C:\LAC\zabbix_sender.exe"" dir=out action=allow enable=yes"
netsh.exe "advfirewall firewall add rule name=""Nodejs In"" program=""$env:ProgramFiles\nodejs\node.exe"" dir=in action=allow enable=yes" ##64
netsh.exe "advfirewall firewall add rule name=""Nodejs Out"" program=""$env:ProgramFiles\nodejs\node.exe"" dir=out action=allow enable=yes" ##64

# start service
net.exe "start LAC"