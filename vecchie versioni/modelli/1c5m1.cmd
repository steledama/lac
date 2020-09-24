@echo off
REM Script richiamato da LetturaAutomaticaContatori by stefano@clasrl.com
:: 1c5m1 xerox WorkCentre 3655
echo %~n0>>%parent%\lac.log

:: TOT
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1') DO set risposta=%%G
set tot=%risposta%
echo totale: %tot% Impressioni > servizio\_risultato.txt

:: BLKC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.1') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.1') DO set risposta=%%G
set /a blk=(risposta*100)/totale
echo toner nero: %blk% %% rimanente >> servizio\_risultato.txt

:: DRUMP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.2') DO set risposta=%%G
set drum=%risposta%
echo fotoricettore: %drum% %% rimanente >> servizio\_risultato.txt

:: FUSP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.3') DO set risposta=%%G
set fus=%risposta%
echo fusore: %fus% %% rimanente >> servizio\_risultato.txt

:: BIASP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.4') DO set risposta=%%G
set bias=%risposta%
echo rullo trasferta: %bias% %% rimanente >> servizio\_risultato.txt

:: KITP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.5') DO set risposta=%%G
set kit=%risposta%
echo kit manutenzione: %bias% %% rimanente >> servizio\_risultato.txt

:: risultato
type servizio\_risultato.txt >> %parent%\lac.log

:: invio
IF %invio%==debug goto FINE
IF %invio%==email goto EMAIL

::SERVER
servizio\sender.exe -z %ip_server% -s %serie% -k TOT -o %tot%

servizio\sender.exe -z %ip_server% -s %serie% -k BLK -o %blk%
servizio\sender.exe -z %ip_server% -s %serie% -k DRUM -o %drum%
servizio\sender.exe -z %ip_server% -s %serie% -k BIAS -o %bias%
servizio\sender.exe -z %ip_server% -s %serie% -k FUS -o %fus%
servizio\sender.exe -z %ip_server% -s %serie% -k KIT -o %kit%

goto FINE

:EMAIL
call servizio\rapporto_email.cmd

call servizio\allerta_email.cmd blk %blk%
call servizio\allerta_email.cmd drum %drum%
call servizio\allerta_email.cmd bias %bias%
call servizio\allerta_email.cmd fus %fus%
call servizio\allerta_email.cmd kit %kit%
goto FINE

:FINE