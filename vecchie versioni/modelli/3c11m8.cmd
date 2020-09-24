@echo off
REM Script richiamato da LetturaAutomaticaContatori by stefano@clasrl.com
:: 3c11m8 3c11m_8p3b xerox VersaLink C505 C500
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

:: YELC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.2') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.2') DO set risposta=%%G
set /a yel=(risposta*100)/totale
echo toner giallo: %yel% %% >> servizio\_risultato.txt

:: MAGC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.3') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.3') DO set risposta=%%G
set /a mag=(risposta*100)/totale
echo toner magenta: %mag% %% >> servizio\_risultato.txt

:: CYAC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.4') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.4') DO set risposta=%%G
set /a cya=(risposta*100)/totale
echo toner ciano: %cya% %% >> servizio\_risultato.txt

:: WASB
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.5') DO set risposta=%%G
if %risposta%==-3 (set was=OK) else (set was=VERIFICARE)
echo contenitore residui: %was% >> servizio\_risultato.txt

:: DRUMKC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.6') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.6') DO set risposta=%%G
set /a drum1=(risposta*100)/totale
echo fotoricettore nero R1: %drum1% %% rimanente >> servizio\_risultato.txt

:: DRUMYC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.7') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.7') DO set risposta=%%G
set /a drum4=(risposta*100)/totale
echo fotoricettore giallo R4: %drum4% %% rimanente >> servizio\_risultato.txt

:: DRUMMC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.8') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.8') DO set risposta=%%G
set /a drum3=(risposta*100)/totale
echo fotoricettore magenta R3: %drum3% %% rimanente >> servizio\_risultato.txt

:: DRUMCC
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.8.1.9') DO set risposta=%%G
set totale=%risposta%
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.9') DO set risposta=%%G
set /a drum2=(risposta*100)/totale
echo fotoricettore ciano R2: %drum2% %% rimanente >> servizio\_risultato.txt

:: FUSB
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.12') DO set risposta=%%G
if %risposta%==-3 (set fus=OK) else (set fus=VERIFICARE)
echo fusore: %fus% >> servizio\_risultato.txt

:: roll
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.18') DO set risposta=%%G
if %risposta%==-3 (set roll=OK) else (set roll=VERIFICARE)
echo rullo alimentazione v1: %roll% >> servizio\_risultato.txt

:: KITB
FOR /F "tokens=4" %%G IN ('SNMPWALK -v1 -c public %ip% SNMPv2-SMI::mib-2.43.11.1.1.9.1.39') DO set risposta=%%G
if %risposta%==-3 (set kit=OK) else (set kit=VERIFICARE)
echo kit manutenzione: %kit% >> servizio\_risultato.txt

:: RISULTATO
type servizio\_risultato.txt>>%parent%\lac.log

:: invio
IF %invio%==debug goto FINE
IF %invio%==email goto EMAIL

::SERVER
servizio\sender.exe -z %ip_server% -s %serie% -k TOT -o %tot%
servizio\sender.exe -z %ip_server% -s %serie% -k COL -o %col%
servizio\sender.exe -z %ip_server% -s %serie% -k BN -o %bn%

servizio\sender.exe -z %ip_server% -s %serie% -k BLK -o %blk%
servizio\sender.exe -z %ip_server% -s %serie% -k YEL -o %yel%
servizio\sender.exe -z %ip_server% -s %serie% -k MAG -o %mag%
servizio\sender.exe -z %ip_server% -s %serie% -k CYA -o %cya%
servizio\sender.exe -z %ip_server% -s %serie% -k WAS -o %was%
servizio\sender.exe -z %ip_server% -s %serie% -k DRUM1 -o %drum1%
servizio\sender.exe -z %ip_server% -s %serie% -k DRUM4 -o %drum4%
servizio\sender.exe -z %ip_server% -s %serie% -k DRUM3 -o %drum3%
servizio\sender.exe -z %ip_server% -s %serie% -k DRUM2 -o %drum2%
servizio\sender.exe -z %ip_server% -s %serie% -k FUS -o %fus%
servizio\sender.exe -z %ip_server% -s %serie% -k ROLL -o %roll%
servizio\sender.exe -z %ip_server% -s %serie% -k KIT -o %kit%
goto FINE

:EMAIL
echo Verifica email>>%parent%\lac.log
call servizio\rapporto_email.cmd

call servizio\allerta_email.cmd blk %blk%
call servizio\allerta_email.cmd yel %yel%
call servizio\allerta_email.cmd mag %mag%
call servizio\allerta_email.cmd cya %cya%
call servizio\allerta_email.cmd was %was% testo
call servizio\allerta_email.cmd drum1 %drum1%
call servizio\allerta_email.cmd drum2 %drum2%
call servizio\allerta_email.cmd drum3 %drum3%
call servizio\allerta_email.cmd drum4 %drum4%
call servizio\allerta_email.cmd fus %fus% testo
call servizio\allerta_email.cmd roll %roll% testo
call servizio\allerta_email.cmd kit %kit% testo
goto FINE

:FINE