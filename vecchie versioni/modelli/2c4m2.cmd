@echo off
REM Script richiamato da LetturaAutomaticaContatori by stefano@clasrl.com
:: xerox 2c4m2 VersaLink B7025 B7030 B7035
echo %~n0>>%parent%\lac.log

:: TOT
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1') DO set risposta=%%G
set tot=%risposta%
echo totale: %tot% Impressioni > servizio\_risultato.txt

:: BNG
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44') DO set risposta=%%G
set bngrandi=%risposta%
echo bn grandi: %bngrandi% Impressioni >> servizio\_risultato.txt

:: BLKC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.1') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.1') DO set risposta=%%G
set /a blk=(risposta*100)/totale
echo toner nero: %blk% %% rimanente >> servizio\_risultato.txt

:: DRUMC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.6') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.6') DO set risposta=%%G
set /a drum=(risposta*100)/totale
echo fotoricettore: %drum% %% rimanente >> servizio\_risultato.txt

:: BIASB
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.10') DO set risposta=%%G
if %risposta%==-3 (set bias=OK) else (set fus=VERIFICARE)
echo rullo trasferta: %bias% >> servizio\_risultato.txt

:: FUSB
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.12') DO set risposta=%%G
if %risposta%==-3 (set fus=OK) else (set fus=VERIFICARE)
echo fusore: %fus% >> servizio\_risultato.txt

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
servizio\sender.exe -z %ip_server% -s %serie% -k BIAS -o %bias%
servizio\sender.exe -z %ip_server% -s %serie% -k FUS -o %fus%
goto FINE

:EMAIL
call servizio\rapporto_email.cmd

call servizio\allerta_email.cmd blk %blk%
call servizio\allerta_email.cmd drum %drum%
call servizio\allerta_email.cmd bias %bias% testo
call servizio\allerta_email.cmd fus %fus% testo
goto FINE

:FINE