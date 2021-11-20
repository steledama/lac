# determining the os architecture
if ((Get-CimInStance CIM_OperatingSystem).OSArchitecture -eq "64 bit") {
    $node = "C:\LAC\win\node-v16.13.0-x64.msi"
    $program = "C:\Program Files"
}
else {
    $node = "C:\LAC\win\node-v16.13.0-x86.msi"
    $program = "C:\Program Files (x86)"
}

# uninstall windows service
Start-Process "$program\nodejs\node.exe" "C:\LAC\win\serviceUninstall.js" -NoNewWindow -Wait

# Unregister the LAC scheduled task
Unregister-ScheduledTask -TaskName 'LAC' -Confirm:$false

# delete firewall rules
Start-Process "netsh.exe" "advfirewall firewall delete rule name=""LAC"" program=""C:\LAC\zabbix_sender.exe"" dir=out" -NoNewWindow -Wait
Start-Process "netsh.exe" "advfirewall firewall delete rule name=""Nodejs In"" program=""$program\nodejs\node.exe"" dir=in" -NoNewWindow -Wait
Start-Process "netsh.exe" "advfirewall firewall delete rule name=""Nodejs Out"" program=""$program\nodejs\node.exe"" dir=out" -NoNewWindow -Wait

# uninstall node
Start-Process "msiexec.exe" "/passive /x $node" -NoNewWindow -Wait

# pause for debugging
# Write-Host -NoNewLine 'Press any key to continue...';
# $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');