@echo off
REM Script richiamato da LetturaAutomaticaContatori by stefano@clasrl.com
:: 2c4m4 2c4m_4p xerox WorkCentre 5945 5955 Altalink B8045 B8055 B8065 B8075 B8090
echo %~n0>>%parent%\lac.log

:: TOT
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1') DO set risposta=%%G
set tot=%risposta%
echo totale: %tot% Impressioni > servizio\_risultato.txt

:: BNG
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44') DO set risposta=%%G
set bngrandi=%risposta%
echo bn grandi: %bngrandi% Impressioni >> servizio\_risultato.txt

:: BLKP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.1') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.1') DO set risposta=%%G
set /a blk=(risposta*100)/totale
echo toner nero: %blk% %% rimanente >> servizio\_risultato.txt

:: DRUMP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.2') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.2') DO set risposta=%%G
set /a drum=(risposta*100)/totale
echo fotoricettore: %drum% %% rimanente >> servizio\_risultato.txt

:: FUSP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.3') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.3') DO set risposta=%%G
set /a fus=(risposta*100)/totale
echo fusore: %fus% %% rimanente >> servizio\_risultato.txt

:: BIASP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.4') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.4') DO set risposta=%%G
set /a bias=(risposta*100)/totale
echo rullo trasferta: %bias% %% rimanente >> servizio\_risultato.txt

:: risultato
type servizio\_risultato.txt>>%parent%\lac.log

:: invio
IF %invio%==debug goto FINE
IF %invio%==email goto EMAIL

::SERVER
servizio\sender.exe -z %ip_server% -s %serie% -k TOT -o %tot%
servizio\sender.exe -z %ip_server% -s %serie% -k BNgrandi -o %bngrandi%

servizio\sender.exe -z %ip_server% -s %serie% -k BLK -o %blk%
servizio\sender.exe -z %ip_server% -s %serie% -k DRUM -o %drum%
servizio\sender.exe -z %ip_server% -s %serie% -k FUS -o %fus%
servizio\sender.exe -z %ip_server% -s %serie% -k BIAS -o %bias%
goto FINE

:EMAIL
call servizio\rapporto_email.cmd

call servizio\allerta_email.cmd blk %blk%
call servizio\allerta_email.cmd drum %drum%
call servizio\allerta_email.cmd fus %fus%
call servizio\allerta_email.cmd bias %bias%
goto FINE

:FINE