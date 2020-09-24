@echo off
REM Script richiamato da LetturaAutomaticaContatori by stefano@clasrl.com
:: 3c8m8 3c8m_8p xerox Phaser 6600 WorkCentre 6605
echo %~n0>>%parent%\lac.log

:: TOT
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1') DO set risposta=%%G
set tot=%risposta%
echo totale: %tot% Impressioni > servizio\_risultato.txt

:: COL
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33') DO set risposta=%%G
set col=%risposta%
echo colore: %col% Impressioni >> servizio\_risultato.txt

:: BN
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34') DO set risposta=%%G
set bn=%risposta%
echo bn: %bn% Impressioni >> servizio\_risultato.txt

:: CYAC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.1') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.1') DO set risposta=%%G
set /a cya=(risposta*100)/totale
echo toner ciano: %cya% %% >> servizio\_risultato.txt

:: MAGC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.2') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.2') DO set risposta=%%G
set /a mag=(risposta*100)/totale
echo toner magenta: %mag% %% >> servizio\_risultato.txt

:: YELC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.3') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.3') DO set risposta=%%G
set /a yel=(risposta*100)/totale
echo toner giallo: %yel% %% >> servizio\_risultato.txt

:: BLKC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.4') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.4') DO set risposta=%%G
set /a blk=(risposta*100)/totale
echo toner nero: %blk% %% >> servizio\_risultato.txt

:: DRUMC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.5') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.5') DO set risposta=%%G
set /a img=(risposta*100)/totale
echo fotoricettore: %img% %% >> servizio\_risultato.txt

:: WASC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.6') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.6') DO set risposta=%%G
set /a was=(risposta*100)/totale
echo contenitore residui: %was% %% >> servizio\_risultato.txt

:: FUSC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.7') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.7') DO set risposta=%%G
set /a fus=(risposta*100)/totale
echo fusore: %fus% %% >> servizio\_risultato.txt

:: BELTC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.8') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.8') DO set risposta=%%G
set /a belt=(risposta*100)/totale
echo cinghia: %belt% %% >> servizio\_risultato.txt

:: risultato
type servizio\_risultato.txt>>%parent%\lac.log

:: invio
IF %invio%==debug goto FINE
IF %invio%==email goto EMAIL

::SERVER
servizio\sender.exe -z %ip_server% -s %serie% -k TOT -o %tot%
servizio\sender.exe -z %ip_server% -s %serie% -k COL -o %col%
servizio\sender.exe -z %ip_server% -s %serie% -k BN -o %bn%

servizio\sender.exe -z %ip_server% -s %serie% -k CYA -o %cya%
servizio\sender.exe -z %ip_server% -s %serie% -k MAG -o %mag%
servizio\sender.exe -z %ip_server% -s %serie% -k YEL -o %yel%
servizio\sender.exe -z %ip_server% -s %serie% -k BLK -o %blk%
servizio\sender.exe -z %ip_server% -s %serie% -k IMG -o %img%
servizio\sender.exe -z %ip_server% -s %serie% -k WAS -o %was%
servizio\sender.exe -z %ip_server% -s %serie% -k FUS -o %fus%
servizio\sender.exe -z %ip_server% -s %serie% -k BELT -o %belt%
goto FINE

:EMAIL
call servizio\rapporto_email.cmd

call servizio\allerta_email.cmd cya %cya%
call servizio\allerta_email.cmd mag %mag%
call servizio\allerta_email.cmd yel %yel%
call servizio\allerta_email.cmd blk %blk%
call servizio\allerta_email.cmd img %img%
call servizio\allerta_email.cmd was %was%
call servizio\allerta_email.cmd fus %fus%
call servizio\allerta_email.cmd belt %belt%
goto FINE

:FINE