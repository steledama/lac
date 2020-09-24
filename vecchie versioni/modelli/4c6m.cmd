@echo off
REM Script richiamato da LetturaAutomaticaContatori by stefano@clasrl.com
:: 4c6m 4c6m_5p1b xerox WorckCentre 8900
echo %~n0>>%parent%\lac.log

:: TOT
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1') DO set risposta=%%G
set tot=%risposta%
echo totale: %tot% Impressioni > servizio\_risultato.txt

:: COL1
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.80') DO set risposta=%%G
set bn=%risposta%
echo bnecolore1: %bn% Impressioni >> servizio\_risultato.txt

:: COL2
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.81') DO set risposta=%%G
set col=%risposta%
echo colore2: %col% Impressioni >> servizio\_risultato.txt

:: COL3
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.82') DO set risposta=%%G
set col3=%risposta%
echo colore3: %col3% Impressioni >> servizio\_risultato.txt

:: BLKP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.1') DO set risposta=%%G
set blk=%risposta%
echo inchiostro nero: %blk% %% >> servizio\_risultato.txt

:: CYAP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.2') DO set risposta=%%G
set cya=%risposta%
echo inchiostro ciano: %cya% %% >> servizio\_risultato.txt

:: MAGP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.3') DO set risposta=%%G
set mag=%risposta%
echo inchiostro magenta: %mag% %% >> servizio\_risultato.txt

:: YELP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.4') DO set risposta=%%G
set yel=%risposta%
echo inchiostro giallo: %yel% %% >> servizio\_risultato.txt

:: WASB
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.5') DO set risposta=%%G
if %risposta%==-3 (set was=OK) else (set was=VERIFICARE)
echo contenitore residui: %was% >> servizio\_risultato.txt

:: KITP
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.6') DO set risposta=%%G
set clean=%risposta%
echo kit manutenzione: %clean% %% >> servizio\_risultato.txt

:: risultato
type servizio\_risultato.txt>>%parent%\lac.log

:: invio
IF %invio%==debug goto FINE
IF %invio%==email goto EMAIL

::SERVER
servizio\sender.exe -z %ip_server% -s %serie% -k TOT -o %tot%
servizio\sender.exe -z %ip_server% -s %serie% -k BN -o %bn%
servizio\sender.exe -z %ip_server% -s %serie% -k COL -o %col%
servizio\sender.exe -z %ip_server% -s %serie% -k COL3 -o %col3%

servizio\sender.exe -z %ip_server% -s %serie% -k CYA -o %cya%
servizio\sender.exe -z %ip_server% -s %serie% -k MAG -o %mag%
servizio\sender.exe -z %ip_server% -s %serie% -k YEL -o %yel%
servizio\sender.exe -z %ip_server% -s %serie% -k BLK -o %blk%
servizio\sender.exe -z %ip_server% -s %serie% -k WAS -o %was%
servizio\sender.exe -z %ip_server% -s %serie% -k CLEAN -o %clean%
goto FINE

:EMAIL
call servizio\rapporto_email.cmd

call servizio\allerta_email.cmd cya %cya%
call servizio\allerta_email.cmd mag %mag%
call servizio\allerta_email.cmd yel %yel%
call servizio\allerta_email.cmd blk %blk%
call servizio\allerta_email.cmd was %was% testo
call servizio\allerta_email.cmd clean %clean%
goto FINE

:FINE