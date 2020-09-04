@echo off
start C:\usr\uninst.exe /S /WAIT
call C:\lac\lac.cmd uninstall
RD /S /Q "C:\lac"
cls