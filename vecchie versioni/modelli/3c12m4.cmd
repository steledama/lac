@echo off
REM Script richiamato da LetturaAutomaticaContatori by stefano@clasrl.com
:: 3c12m4 3c12m_12p xerox WorxkCentre 6655
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

:: BLKC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.1') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.1') DO set risposta=%%G
set /a blk=(risposta*100)/totale
echo toner nero: %blk% %% >> servizio\_risultato.txt

:: CYAC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.2') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.2') DO set risposta=%%G
set /a cya=(risposta*100)/totale
echo toner ciano: %cya% %% >> servizio\_risultato.txt

:: MAGC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.3') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.3') DO set risposta=%%G
set /a mag=(risposta*100)/totale
echo toner magenta: %mag% %% >> servizio\_risultato.txt

:: YELC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.4') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.4') DO set risposta=%%G
set /a yel=(risposta*100)/totale
echo toner giallo: %yel% %% >> servizio\_risultato.txt

:: DRUMKP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.5') DO set risposta=%%G
set drum1=%risposta%
echo fotoricettore R1: %drum1% %% rimanente >> servizio\_risultato.txt

:: DRUMCP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.6') DO set risposta=%%G
set drum2=%risposta%
echo fotoricettore R2: %drum2% %% rimanente >> servizio\_risultato.txt

:: DRUMMP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.7') DO set risposta=%%G
set drum3=%risposta%
echo fotoricettore R3: %drum3% %% rimanente >> servizio\_risultato.txt

:: DRUMYP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.8') DO set risposta=%%G
set drum4=%risposta%
echo fotoricettore R4: %drum4% %% rimanente >> servizio\_risultato.txt

:: FUSP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.9') DO set risposta=%%G
set fus=%risposta%
echo fusore: %fus% %% rimanente >> servizio\_risultato.txt

:: WASP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.10') DO set risposta=%%G
set was=%risposta%
echo contenitore residui: %was% >> servizio\_risultato.txt

:: BELTP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.11') DO set risposta=%%G
set belt=%risposta%
echo (pulitore) cinghia: %belt% %% rimanente >> servizio\_risultato.txt

:: BIASP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.12') DO set risposta=%%G
set bias=%risposta%
echo rullo trasferta: %bias% %% rimanente >> servizio\_risultato.txt

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
servizio\sender.exe -z %ip_server% -s %serie% -k DRUM1 -o %drum1%
servizio\sender.exe -z %ip_server% -s %serie% -k DRUM2 -o %drum2%
servizio\sender.exe -z %ip_server% -s %serie% -k DRUM3 -o %drum3%
servizio\sender.exe -z %ip_server% -s %serie% -k DRUM4 -o %drum4%
servizio\sender.exe -z %ip_server% -s %serie% -k WAS -o %was%
servizio\sender.exe -z %ip_server% -s %serie% -k FUS -o %fus%
servizio\sender.exe -z %ip_server% -s %serie% -k BELT -o %belt%
servizio\sender.exe -z %ip_server% -s %serie% -k BIAS -o %bias%
goto FINE

:EMAIL
call servizio\rapporto_email.cmd

call servizio\allerta_email.cmd cya %cya%
call servizio\allerta_email.cmd mag %mag%
call servizio\allerta_email.cmd yel %yel%
call servizio\allerta_email.cmd blk %blk%
call servizio\allerta_email.cmd drum1 %drum1%
call servizio\allerta_email.cmd drum2 %drum2%
call servizio\allerta_email.cmd drum3 %drum3%
call servizio\allerta_email.cmd drum4 %drum4%
call servizio\allerta_email.cmd was %was%
call servizio\allerta_email.cmd bias %bias%
call servizio\allerta_email.cmd belt %belt%
call servizio\allerta_email.cmd fus %fus%
goto FINE

:FINE