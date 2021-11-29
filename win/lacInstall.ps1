# determining the os architecture
if ((Get-CimInStance CIM_OperatingSystem).OSArchitecture -eq "64 bit") {
    $node = "C:\LAC\win\node-v16.13.0-x64.msi"
    $program = "C:\Program Files"
}
else {
    $node = "C:\LAC\win\node-v16.13.0-x86.msi"
    $program = "C:\Program Files (x86)"
}

# install node
Start-Process "msiexec.exe" "/passive /i $node" -NoNewWindow -Wait

# add firewall rules
Start-Process "netsh.exe" "advfirewall firewall add rule name=""LAC"" program=""C:\LAC\zabbix_sender.exe"" dir=out action=allow enable=yes" -NoNewWindow -Wait
Start-Process "netsh.exe" "advfirewall firewall add rule name=""Nodejs In"" program=""$program\nodejs\node.exe"" dir=in action=allow enable=yes" -NoNewWindow -Wait
Start-Process "netsh.exe" "advfirewall firewall add rule name=""Nodejs Out"" program=""$program\nodejs\node.exe"" dir=out action=allow enable=yes" -NoNewWindow -Wait

# change current working directory
Set-Location -LiteralPath C:\LAC

# install node modules
& "$program\nodejs\node.exe" "$program\nodejs\node_modules\npm\bin\npm-cli.js" "install" -NoNewWindow -Wait

# build nextjs production app
Start-Process "$program\nodejs\node.exe" "C:\LAC\node_modules\next\dist\bin\next build" -NoNewWindow -Wait

# install windows service to start the app
Start-Process "$program\nodejs\node.exe" "C:\LAC\win\serviceInstall.js" -NoNewWindow -Wait

# start service
Start-Process "net.exe" "start LAC" -NoNewWindow -Wait

# Create a new task action
$taskAction = New-ScheduledTaskAction `
    -Execute 'node' `
    -Argument 'C:\LAC\scheduled.js' `
    -WorkingDirectory 'C:\LAC'
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

# pause for debugging
# Write-Host -NoNewLine 'Press any key to continue...';
# $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');