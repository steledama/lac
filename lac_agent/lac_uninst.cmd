@echo off
start C:\usr\uninst.exe /S /WAIT
for /f delims=| %%f in ('dir /b *.conf') do call zabbix_agentd.exe --config %%~nxf --stop --multiple-agents
for /f delims=| %%f in ('dir /b *.conf') do call zabbix_agentd.exe --config %%~nxf --uninstall --multiple-agents
echo All services are uninstalled >> %_log%
exit