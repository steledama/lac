@echo off
REM Script richiamato da LetturaAutomaticaContatori by stefano@clasrl.com
:: 1C_1c_1p
:: 1c1m xerox PHASER 3200 3320 3635 
echo %~n0>>%parent%\lac.log

:: TOT
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1') DO set risposta=%%G
set tot=%risposta%
echo totale: %tot% Impressioni > servizio\_risultato.txt

:: BLKP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.1') DO set risposta=%%G
set blk=%risposta%
echo toner nero: %blk%%% Rimanente >> servizio\_risultato.txt

:: risultato
type servizio\_risultato.txt>>%parent%\lac.log

:: invio
IF %invio%==debug goto FINE
IF %invio%==email goto EMAIL

::SERVER
servizio\sender.exe -z %ip_server% -s %serie% -k TOT -o %tot%

servizio\sender.exe -z %ip_server% -s %serie% -k BLK -o %blk%
goto FINE

:EMAIL
call servizio\rapporto_email.cmd

call servizio\allerta_email.cmd blk %blk%
goto FINE

:FINE