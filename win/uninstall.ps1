# uninstall windows service
C:\Program Files\nodejs\node.exe "C:\LAC\win\serviceUninstall.js" ##64

# Unregister the LAC scheduled task
Unregister-ScheduledTask -TaskName 'LAC' -Confirm:$false

# delete firewall rules
netsh.exe "advfirewall firewall delete rule name=""LAC"" program=""C:\LAC\zabbix_sender.exe"" dir=out action=allow enable=yes"
netsh.exe "advfirewall firewall delete rule name=""Nodejs In"" program=""C:\Program Files\nodejs\node.exe"" dir=in action=allow enable=yes" ##64
netsh.exe "advfirewall firewall delete rule name=""Nodejs Out"" program=""C:\Program Files\nodejs\node.exe"" dir=out action=allow enable=yes" ##64

# uninstall node
msiexec.exe /passive /x "C:\LAC\win\node-v16.13.0-x64.msi"