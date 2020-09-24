@echo off
REM LAC LetturaAutomaticaContatori by stefano@clasrl.com

SETLOCAL
set _versione=4.0.8
set _dir=%~dp0
set _log="%_dir%lac.log"
set _server=print.clasrl.com
set _lista=no

cd %_dir%
echo %date%-%time% >> %_log%

if [%1]==[] goto benvenuto
if /i %1==uninstall goto killall
if /i %1==send goto send
echo Parametro non valido
goto fine

:benvenuto
echo benvenuto >> %_log%
echo.
echo            LAC
echo LetturaAutomaticaContatori
echo     --- %_versione% ---
echo   by stefano@clasrl.com
echo.
echo u. uscita
echo -
set rivenditore=CLA
set /p rivenditore=Inserisci la tua sigla:
echo.
if %rivenditore%==CLA goto goal
if %rivenditore%==PAN goto goal
if %rivenditore%==ELL goto goal
if %rivenditore%==TER goto goal
if %rivenditore%==SAM goto goal
if %rivenditore%==OAS goto goal
:: ---
if /i %rivenditore%==u goto fine
@echo Nome non valido: Inserisci la tua sigla in MAIUSCOLO oppure u per uscire
echo.
goto benvenuto

:goal
echo u. uscita
echo r. ricomincia
echo -
echo p. profila un dispositivo
echo l. lista di dispositivi
echo d. disinstalla uno o tutti i servizi
echo i. installa servizio di monitoraggio (invio)
set goal=i
set /p goal=Cosa vuoi fare? Inserisci (i,d,l,p):
echo.
if /i %goal%==u goto fine
if /i %goal%==r goto goal
:: -
if /i %goal%==p goto profilo
if /i %goal%==l goto lista
if /i %goal%==d goto uninstall
if /i %goal%==i goto ip
echo Scelta non valida: scegli a,d,l oppure u per uscire, r per ricominciare
echo.
goto goal

:ip
echo installa >> %_log%
set /p ip=Scrivi l'indirizzo IP:
echo.
:serie
set /p serie=%ip% Scrivi il numero di SERIE:
echo.
:marca
echo u. uscita
echo r. ricomincia
echo -
echo l. lexmark
echo x. xerox (invio)
set marca=x
set /p marca=%ip% %serie% Seleziona la marca.Inserisci (x,l):
echo.
if /i %marca%==u goto fine
if /i %marca%==r goto goal
:: -
if /i %marca%==l goto lexmark
if /i %marca%==x goto xerox
@echo Scelta non valida: scegli x,l oppure u per uscire, r per ricominciare
echo.
goto marca

:xerox
set marca=xerox
set /p modello=%ip% %serie% %marca% Inserisci il modello:
echo.
:xerox_modelli
FOR %%G IN (
"3200"
"3320"
"3635"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=1c1m
	set template=1c1m_1p
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"3315"
"3325"
"3550"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=1c1m1
	set template=1c1m_1p
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"3330"
"3610"
"4600"
"3335"
"3345"
"3615"
"4250"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=1c2m2
	set template=1c2m_2p
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"B400"
"B405"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=1c3m2
	set template=1c3m_2p1b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"5225"
"5230"
"B600"
"B610"
"B605"
"B615"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=1c4m2
	set template=1c4m_2p2b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"3655"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=1c5m1
	set template=1c5m_5p
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"5325"
"5330"
"5335"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=2c3m2
	set template=2c3m_2p1b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"B7025"
"B7030"
"B7035"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=2c4m2
	set template=2c4m_2p2b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"5945"
"5955"
"B8045"
"B8055"
"B8065"
"B8075"
"B8090"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=2c4m4
	set template=2c4m_4p
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"8570"
"8580"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=3c6m
	set template=3c6m_5p1b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"C400"
"C405"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=3c8m5
	set template=3c8m_5p3b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"6600"
"6605"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=3c8m8
	set template=3c8m_8p
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"6700"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=3c11m4
	set template=3c11m_10p1b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"C500"
"C505"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=3c11m8
	set template=3c11m_8p3b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"6655"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=3c12m4
	set template=3c12m_12p
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"8900"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=4c6m
	set template=4c6m_5p1b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"7120"
"7125"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=5c12m8
	set template=5c12m_8p4b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"C7020"
"C7025"
"C7030"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=5c12m8_2
	set template=5c12m_8p4b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"7220"
"7225"
"7525"
"7530"
"7535"
"7545"
"7556"
"7800"
"7830"
"7835"
"7845"
"7855"
"C8035"
"C8045"
"C8055"
"C8070"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=5c12m4
	set template=5c12m_11p1b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"9303"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=6c6m
	set template=6c6m_5p1b
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

echo Modello non valido. ATTENZIONE alle minuscole. Inserisci solo la sigla finale tra la seguente lista:
echo.
echo AltaLink C8035 C8045 C8055 C8070
echo AltaLink B8045 B8055 B8065 B8075 B8090
echo ColorQube 8570 8580
echo ColorQube 8900
echo ColorQube 9303
echo Phaser 3200
echo Phaser 3320
echo Phaser 3330
echo Phaser 3610
echo Phaser 3635
echo Phaser 4600
echo Phaser 6600
echo Phaser 6700
echo Phaser 7800
echo VersaLink B400 e B405
echo VersaLink C400 e C405
echo VersaLink B7025 B7030 B7035
echo VersaLink C500 e C505
echo VersaLink C7020 C7025 C7030
echo Versalink B600 B610 B605 B615
echo WorkCentre 3315 3325
echo WorkCentre 3335 3345
echo WorkCentre 3550
echo WorkCentre 3615
echo WorkCentre 3655
echo WorkCentre 4250
echo WorkCentre 5225 5230
echo WorkCentre 5325 5330 5335
echo WorkCentre 5945 5955
echo WorkCentre 6605
echo WorkCentre 6655
echo WorkCentre 7120 7125
echo WorkCentre 7220 7225
echo WorkCentre 7525 7530 7535 7545 7556
echo WorkCentre 7830 7835 7845 7855
echo.
echo Es. per una Xerox WorkCentre 7220 inserire solo '7220' (senza virgolette)
echo Es. per una Xerox Versalink C7020 inserire solo 'C7020' (senza virgolette con la C maiuscola)
echo.
pause
GOTO xerox

:lexmark
set marca=lexmark
set /p modello=%ip% %serie% %marca% Inserisci il modello:
echo.
:lexmark_modelli
FOR %%G IN (
"XC4240"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=6c8m8
	set template=6c8m_8p
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"C9235"
"XC9235"
"XC9245"
"XC9255"
"XC9265"
) DO (
IF "%modello%"=="%%~G" (
	set profilo=8c13m13
	set template=8c13m_13p
	if /i %_lista%==si goto configurazione
	goto conferma
	)
)

echo Modello non valido. ATTENZIONE alle minuscole. Inserisci un modello tra la seguente lista:
echo.
echo Lexmark C9235
echo Lexmark XC9235 XC9245 XC9255 XC9265
echo Lexmark XC4240
echo.
echo Es. per una Lexmark XC9235 inserire solo 'XC9235' (senza virgolette con XC maiuscole)
echo.
pause
GOTO lexmark

:conferma
echo conferma >> %_log%
echo u. uscita
echo r. ricomincia
echo -
echo n. no
echo s. si (invio)
set conferma=s
set /p conferma=marca:%marca% modello:%modello% serie:%serie% ip:%ip% Confermi? Inserisci (s,n):
echo.
if /i %conferma%==u goto fine
if /i %conferma%==r goto goal
::-
if /i %conferma%==n goto ip
if /i %conferma%==s goto configurazione
echo Scelta conferma non valida: scegli s,n oppure u per uscire, r per ricominciare
echo.
goto conferma

:configurazione
echo configura >> %_log%
(
echo LogType=file
echo LogFile=%_dir%zabbix_agentd.log
echo LogFileSize=1
echo DebugLevel=3
echo.
echo StartAgents=0
echo.
echo RefreshActiveChecks=3600
echo.
echo Timeout=30
echo.
echo ServerActive=%_server%
echo.
:: serie
echo Hostname=%modello%_%serie%
echo HostMetadata=%rivenditore% %template%
::ip
echo UserParameter=IP,echo %ip%
::vrs
echo UserParameter=VRS,echo %_versione%
::LAC
echo UserParameter=LAC,"%_dir%lac.cmd" send %profilo%_%marca% %ip% %modello%_%serie%
)>%modello%_%serie%.conf

:agent
echo agent >> %_log%
if /i %_lista%==si (
	call zabbix_agentd.exe --config %modello%_%serie%.conf --install --multiple-agents
	call zabbix_agentd.exe --config %modello%_%serie%.conf --start --multiple-agents
	exit /b
	)
echo s. si
echo n. no (invio)
set multiplo=n
set /p multiplo=Vuoi installare un'altro servizio? Inserisci (s,n):
echo.
if /i %multiplo%==s (
	call zabbix_agentd.exe --config %modello%_%serie%.conf --install --multiple-agents
	call zabbix_agentd.exe --config %modello%_%serie%.conf --start --multiple-agents
	goto marca
	)
if /i %multiplo%==n (
	call zabbix_agentd.exe --config %modello%_%serie%.conf --install --multiple-agents
	call zabbix_agentd.exe --config %modello%_%serie%.conf --start --multiple-agents
	echo Installazione servizio completata >> %_log%
	pause
	goto fine
	)
echo Scelta non valida: scegli s,n
goto agent

:lista
echo lista >> %_log%
set lista=si
set /p file=Scrivi il nome del file che contiene la lista di dispositivi da monitorare:
echo.
IF not exist %file%.txt (
	echo Il file deve essere in formato .txt e deve essere nella stessa cartella di lax_zabbix.exe e contenere la lista delle macchine da monitorare nel formato MARCA MODELLO SERIE IP
	goto lista
	)
for /F "tokens=1,2,3,4" %%a in (%file%.txt) do (
	call :variabili %%a %%b %%c %%d
	)
goto fine
:variabili
set marca=%1
set modello=%2
set serie=%3
set ip=%4
call :%marca%_modelli
exit /b

:uninstall
echo uninstall >> %_log%
echo u. uscita
echo r. ricomincia
echo -
echo e. elenca i servizi
echo t. tutti i servizi (invio)
set chi=t
set /p chi=Cosa vuoi fare? Inserisci (t,e):
echo.
if /i %chi%==u goto fine
if /i %chi%==r goto goal
:: -
if /i %chi%==e goto elenca
if /i %chi%==t goto killall
echo Scelta non valida: scegli t,e oppure u per uscire, r per ricominciare
echo.
goto uninstall
:elenca
echo Di seguito i servizi attualmente installati:
for /f "delims=|" %%f in ('dir /b *.conf') do echo %%~nf
echo.
set /p kill=inserisci il nome (o una parte) del servizio da disinstallare:
echo.
for /f "delims=|" %%f in ('dir /b *%kill%*.conf') do call zabbix_agentd.exe --config %%~nxf --stop --multiple-agents
for /f "delims=|" %%f in ('dir /b *%kill%*.conf') do call zabbix_agentd.exe --config %%~nxf --uninstall --multiple-agents
for /f "delims=|" %%f in ('dir /b *%kill%*.conf') do del %%~nxf
echo Servizio disinstallato correttamente >> %_log%
echo Servizio disinstallato correttamente
pause
goto fine
:killall
for /f "delims=|" %%f in ('dir /b *.conf') do call zabbix_agentd.exe --config %%~nxf --stop --multiple-agents
for /f "delims=|" %%f in ('dir /b *.conf') do call zabbix_agentd.exe --config %%~nxf --uninstall --multiple-agents
for /f "delims=|" %%f in ('dir /b *.conf') do del %%~nxf
echo Tutti i servizi sono stati disintallati >> %_log%
goto fine

:profilo
echo profilo >> %_log%
set /p ip_profilo=Inserisci l'indirizzo ip:
echo.
set /p modello_profilo=Inserisci il modello da profilare:
echo.
:marca_profilo
echo u. uscita
echo r. ricomincia
echo -
echo a. altro
echo l. lexmark
echo x. xerox (invio)
set marca_profilo=x
set /p marca_profilo=Seleziona la marca del dispositivo da profilare. Inserisci (x,l,a):
echo.
if /i %marca_profilo%==u goto fine
if /i %marca_profilo%==r goto goal
:: -
if /i %marca_profilo%==a goto tutto_profilo
if /i %marca_profilo%==l goto lexmark_profilo
if /i %marca_profilo%==x goto xerox_profilo
@echo Scelta non valida: scegli x,l,a oppure u per uscire, r per ricominciare
echo.
goto profilo
:xerox_profilo
set marca_profilo=xerox
set mib_contatori=1.3.6.1.4.1.253.8.53.13.2.1
goto profila
:lexmark_profilo
set marca_profilo=lexmark
set mib_contatori=SNMPv2-SMI::enterprises.641.6.4.2
goto profila
:profila
set mib_consumabili=1.3.6.1.2.1.43.11.1.1
echo CONTATORI > %marca_profilo%_%modello_profilo%.txt
SNMPWALK -v1 -c public %ip_profilo% %mib_contatori% >> %marca_profilo%_%modello_profilo%.txt
echo. >> %marca_profilo%_%modello_profilo%.txt
echo COMSUMABILI >> %marca_profilo%_%modello_profilo%.txt
SNMPWALK -v1 -c public %ip_profilo% %mib_consumabili% >> %marca_profilo%_%modello_profilo%.txt
goto fine
:tutto_profilo
set marca_profilo=altro
echo GENERALE > %marca_profilo%_%modello_profilo%.txt
snmpwalk -v 2c -c public %ip_profilo% >> %marca_profilo%_%modello_profilo%.txt
echo. >> %marca_profilo%_%modello_profilo%.txt
echo MIB-2 >> %marca_profilo%_%modello_profilo%.txt
snmpwalk -v 1 -c public %ip_profilo% mib-2 >> %marca_profilo%_%modello_profilo%.txt
echo. >> %marca_profilo%_%modello_profilo%.txt
echo PRIVATE >> %marca_profilo%_%modello_profilo%.txt
snmpwalk -v 1 -c public %ip_profilo% private >> %marca_profilo%_%modello_profilo%.txt
echo. >> %marca_profilo%_%modello_profilo%.txt
echo MGMT >> %marca_profilo%_%modello_profilo%.txt
snmpwalk -v 1 -c public %ip_profilo% mgmt >> %marca_profilo%_%modello_profilo%.txt
goto fine

:send
set _profilo=%2
set ip=%3
set host=%4
::SET check for, and create lock file to ensure concurrent runs aren't possible
set _lck="%_dir%lac.lck"
echo send %host% >> %_log%

:: CONTROLLO PING
ping -n 1 "%ip%" | findstr /r /c:"[0-9] *ms" > nul 2>&1
if %errorlevel% == 0 (
    goto controllo_lck
) else (
    goto NO_PING
)
:NO_PING
echo NO_PING >> %_log%
echo NO_PING
goto fine

:controllo_lck
set /a _tentativi=0
:recheck
if exist %_lck%\ goto locked_recheck
mkdir %_lck%
echo creato lock >> %_log%
goto %_profilo%

:locked_recheck
:: Come here to Pause the script with a loopback ping to nul for 3 seconds
if %_tentativi% lss 10 (
	echo processo occupato %_tentativi% >> %_log%
	ping 127.0.0.1 -n 3 > nul
	set /a _tentativi+=1
	echo riprovo >> %_log%
	goto :recheck
)
echo troppi tentativi >> %_log%
goto fine

:: PROFILI ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::phaser 3200 3320 3635
:1c1m_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKP=%%G
goto 1c1m_1p

::1c1m1 xerox workcentre 3315 3325 3550
:1c1m1_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
goto 1c1m_1p

::1c2m2 xerox phaser 3330 3610 4600 worcentre 3335 3345 3615 4250
:1c2m2_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
goto 1c2m_2p

::1c3m2 xerox VersaLink B400 B405
:1c3m2_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::KITB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.40
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set KITB=%%G
goto 1c3m_2p1b

::1c4m2 xerox WorkCentre 5225 5230 Versalink B600 B610 B605 B615
:1c4m2_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::BIASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BIASB=%%G
::BIASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSB=%%G
goto 1c4m_2p2b

::1c5m1 xerox WorkCentre 3655
:1c5m1_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMP=%%G
::FUSP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSP=%%G
::BIASP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BIASP=%%G
::KITP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set KITP=%%G
goto 1c5m_5p

::2c3m2 xerox WorkCentre 5325 5330 5335
:2c3m2_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::BNG
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BNG=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::FUSB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSB=%%G
goto 2c3m_2p1b

::2c4m2 xerox VersaLink B7025 B7030 B7035
:2c4m2_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::BNG
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BNG=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::BIASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BIASB=%%G
goto %template%
::FUSB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSB=%%G
goto 2c4m_2p2b

::2c4m4 xerox WorkCentre 5945 5955 Altalink B8045 B8055 B8065 B8075 B8090
:2c4m4_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::BNG
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BNG=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::FUSP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUST=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSR=%%G
set /A FUSP=(FUSR*100)/FUST
::BIASP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BIAST=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BIASR=%%G
set /A BIASP=(BIASR*100)/BIAST
goto 2c4m_4p

::3c6m xerox ColorQube 8570 8580
:3c6m_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::COL
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL=%%G
::BN
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BN=%%G
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAP=%%G
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGP=%%G
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELP=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKP=%%G
::KITP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set KITP=%%G
::WASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASB=%%G
goto 3c6m_5p1b

::3c8m5 xerox VERSALINK C400 C405
:3c8m5_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::COL
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL=%%G
::BN
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BN=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::WASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASB=%%G
::FUSB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSB=%%G
::KITB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.39
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set KITB=%%G
::DRUMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.41
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.41
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
goto 3c8m_5p3b

::3c8m8 xerox Phaser 6600 WorkCentre 6605
:3c8m8_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::COL
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL=%%G
::BN
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BN=%%G
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::WASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASB=%%G
::FUSB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSB=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
::BELTP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BELTT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BELTR=%%G
set /A BELTP=(BELTR*100)/BELTT
goto 3c8m_8p

::3c11m4 xerox Phaser 6700
:3c11m4_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::COL
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL=%%G
::BN
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BN=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::DRUMKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMKP=%%G
::DRUMCP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMCP=%%G
::DRUMMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMMP=%%G
::DRUMYP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMYP=%%G
::FUSP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSP=%%G
::WASB 100
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASB=%%G
::BELTP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.11
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BELTT=%%G
goto 3c11m_10p1b

::3c11m8 xerox VersaLink C505 C500
:3c11m8_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::COL
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL=%%G
::BN
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BN=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::WASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASB=%%G
::DRUMKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMKR=%%G
set /A DRUMKP=(DRUMKR*100)/DRUMKT
::DRUMYP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMYT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMYR=%%G
set /A DRUMYP=(DRUMYR*100)/DRUMYT
::DRUMMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMMR=%%G
set /A DRUMMP=(DRUMMR*100)/DRUMMT
::DRUMCP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.9
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMCT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMCR=%%G
set /A DRUMCP=(DRUMCR*100)/DRUMCT
::FUSB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSB=%%G
::KITB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.39
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set KITB=%%G
goto 3c11m_8p3b

::3c12m4 xerox WorxkCentre 6655
:3c12m4_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::COL
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL=%%G
::BN
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BN=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::DRUMKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMKP=%%G
::DRUMCP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMCP=%%G
::DRUMMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMMP=%%G
::DRUMYP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMYP=%%G
::FUSP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSP=%%G
::WASP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASP=%%G
::BELTP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.11
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BELTP=%%G
::BIASP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BIASP=%%G
goto 3c12m_12p

::4c6m xerox ColorQube 8900
:4c6m_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::COL1
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.80
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL1=%%G
::COL2
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.81
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL2=%%G
::COL3
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.82
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL3=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKP=%%G
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAP=%%G
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGP=%%G
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELP=%%G
::WASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASB=%%G
::KITP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set KITP=%%G
goto 4c6m_5p1b

::5c12m4 xerox WORKCENTRE 7220 7225 7525 7530 7535 7545 7556 7830 7835 7845 7855 AltaLink C8035 8045 C8055 C8070
:5c12m4_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::COL
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL=%%G
::BN
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BN=%%G
::COLG
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.43
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COLG=%%G
::BNG
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BNG=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::DRUMKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMKP=%%G
::DRUMCP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMCP=%%G
::DRUMMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMMP=%%G
::DRUMYP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMYP=%%G
::FUSP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSP=%%G
::WASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASB=%%G
::BELTP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.11
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BELTP=%%G
::BIASP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BIASP=%%G
goto 5c12m_11p1b

::5c12m8 xerox WorkCentre 7120 7125
:5c12m8_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::COL
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL=%%G
::BN
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BN=%%G
::COLG
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.43
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COLG=%%G
::BNG
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BNG=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::WASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASB=%%G
::DRUMKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMKR=%%G
set /A DRUMKP=(DRUMKR*100)/DRUMKT
::DRUMYP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMYT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMYR=%%G
set /A DRUMYP=(DRUMYR*100)/DRUMYT
::DRUMMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMMR=%%G
set /A DRUMMP=(DRUMMR*100)/DRUMMT
::DRUMCP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.9
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMCT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMCR=%%G
set /A DRUMCP=(DRUMCR*100)/DRUMCT
::BIASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BIASB=%%G
::BELTB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.11
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BELTB=%%G
::FUSB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSB=%%G
goto 5c12m_8p4b

::5c12m8_2 VersaLink C7020 C7025 C7030
:5c12m8_2_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::COL
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL=%%G
::BN
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BN=%%G
::COLG
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.43
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COLG=%%G
::BNG
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BNG=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::WASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASB=%%G
::DRUMKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMKR=%%G
set /A DRUMKP=(DRUMKR*100)/DRUMKT
::DRUMYP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMYT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMYR=%%G
set /A DRUMYP=(DRUMYR*100)/DRUMYT
::DRUMMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMMR=%%G
set /A DRUMMP=(DRUMMR*100)/DRUMMT
::DRUMCP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.9
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMCT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMCR=%%G
set /A DRUMCP=(DRUMCR*100)/DRUMCT
::BIASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BIASB=%%G
::BELTB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.11
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BELTB=%%G
::FUSB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSB=%%G
goto 5c12m_8p4b

::6c6m xerox ColorQube 9303
:6c6m_xerox
::TOT
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::COLG
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.43
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COLG=%%G
::BNG
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BNG=%%G
::COL1
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.80
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL1=%%G
::COL2
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.81
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL2=%%G
::COL3
set oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.82
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL3=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKP=%%G
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAP=%%G
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGP=%%G
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELP=%%G
::WASB
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASB=%%G
::KITP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set KITP=%%G
goto 6c6m_5p1b

::LEXMARK:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::6c8m8 lexmark XC4240
:6c8m8_lexmark
::TOT
set oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::BN
set oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BN=%%G
::COL
set oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL=%%G
::COL3
set oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.22
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL3=%%G
::COL2
set oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.23
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL2=%%G
::COL1
set oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.24
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL1=%%G
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::BELTP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BELTT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BELTR=%%G
set /A BELTP=(BELTR*100)/BELTT
::DRUMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::KITP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set KITT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set KITR=%%G
set /A KITP=(KITR*100)/KITT
::WASP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WAST=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASR=%%G
set /A WASP=(WASR*100)/WAST
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
goto 6c8m_8p

::8c13m13 lexmark C9235 XC9235 XC9245 XC9255 XC9265
:8c13m13_lexmark
::TOT
set oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set TOT=%%G
::BN
set oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BN=%%G
::COL
set oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL=%%G
::BNG
set oid=SNMPv2-SMI::enterprises.641.6.4.2.2.1.4.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BNG=%%G
::COLG
set oid=SNMPv2-SMI::enterprises.641.6.4.2.2.1.5.1.1
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COLG=%%G
::COL3
set oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.22
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL3=%%G
::COL2
set oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.23
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL2=%%G
::COL1
set oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.24
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set COL1=%%G
::KITP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set KITT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set KITR=%%G
set /A KITP=(KITR*100)/KITT
::DEVKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DEVKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DEVKR=%%G
set /A DEVKP=(DEVKR*100)/DEVKT
::DRUMKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMKR=%%G
set /A DRUMKP=(DRUMKR*100)/DRUMKT
::BLKP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DEVCP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DEVCT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DEVCR=%%G
set /A DEVCP=(DEVCR*100)/DEVCT
::DRUMCP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.9
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMCT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMCR=%%G
set /A DRUMCP=(DRUMCR*100)/DRUMCT
::CYAP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.10
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::FUSP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.11
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUST=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.11
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set FUSR=%%G
set /A FUSP=(FUSR*100)/FUST
::DRUMMP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.12
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMMT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMMR=%%G
set /A DRUMMP=(DRUMMR*100)/DRUMMT
::MAGP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.13
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.13
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::WASP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.14
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WAST=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.14
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set WASR=%%G
set /A WASP=(WASR*100)/WAST
::DRUMYP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.15
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMYT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.15
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set DRUMYR=%%G
set /A DRUMYP=(DRUMYR*100)/DRUMYT
::YELP
set oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.16
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELT=%%G
set oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.16
for /F "tokens=4" %%G in ('SNMPWALK -v1 -c public %ip% %oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
goto 8c13m_13p

::: TEMPLATE ::::::::::::::::::::::::::::::::::::::::::::::::::::::
::1c1m_1p xerox phaser 3200 3320 3635 xerox workcentre 3315 3325 3550
:1c1m_1p
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
goto chiudi

::1c2m_2p xerox phaser 3330 3610 4600 worcentre 3335 3345 3615 4250
:1c2m_2p
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMP -o %DRUMP% >> %_log%
goto chiudi

::1c3m_2p1b xerox VersaLink B400 B405
:1c3m_2p1b
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMP -o %DRUMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k KITB -o %KITB% >> %_log%
goto chiudi

::1c4m_2p2b xerox WorkCentre 5225 5230 Versalink B600 B610 B605 B615
:1c4m_2p2b
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMP -o %DRUMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BIASB -o %BIASB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSB -o %FUSB% >> %_log%
goto chiudi

::1c5m_5p xerox WorkCentre 3655
:1c5m_5p
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMP -o %DRUMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSP -o %FUSP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BIASP -o %BIASP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k KITP -o %KITP% >> %_log%
goto chiudi

::2c3m_2p1b xerox WorkCentre 5325 5330 5335
:2c3m_2p1b
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BNG -o %BNG% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMP -o %DRUMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSB -o %FUSB% >> %_log%
goto chiudi

::2c4m_2p2b xerox VersaLink B7025 B7030 B7035
:2c4m_2p2b
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BNG -o %BNG% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMP -o %DRUMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BIASB -o %BIASB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSB -o %FUSB% >> %_log%
goto chiudi

::2c4m_4p xerox WorkCentre 5945 5955 Altalink B8045 B8055 B8065 B8075 B8090
:2c4m_4p
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BNG -o %BNG% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMP -o %DRUMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSP -o %FUSP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BIASP -o %BIASP% >> %_log%
goto chiudi

::3c6m_5p1b xerox ColorCube 8570 8580
:3c6m_5p1b
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL -o %COL% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BN -o %BN% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k CYAP -o %CYAP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k MAGP -o %MAGP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k YELP -o %YELP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k KITP -o %KITP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k WASB -o %WASB% >> %_log%
goto chiudi

::3c8m_5p3b xerox VersaLink C400 C405
:3c8m_5p3b
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL -o %COL% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BN -o %BN% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k CYAP -o %CYAP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k MAGP -o %MAGP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k YELP -o %YELP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k KITB -o %KITB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k WASB -o %WASB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSB -o %FUSB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMP -o %DRUMP% >> %_log%
goto chiudi

::3c8m_8p xerox Phaser 6600 WorkCentre 6605
:3c8m_8p
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL -o %COL% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BN -o %BN% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k CYAP -o %CYAP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k MAGP -o %MAGP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k YELP -o %YELP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMP -o %DRUMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k WASB -o %WASB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSB -o %FUSB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BELTP -o %BELTP% >> %_log%
goto chiudi

::3c11m_10p1b xerox Phaser 6700
:3c11m_10p1b
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL -o %COL% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BN -o %BN% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k CYAP -o %CYAP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k MAGP -o %MAGP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k YELP -o %YELP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMKP -o %DRUMKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMCP -o %DRUMCP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMMP -o %DRUMMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMYP -o %DRUMYP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSP -o %FUSP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k WASB -o %WASB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BELTP -o %BELTP% >> %_log%
goto chiudi

::3c11m_8p3b xerox VersaLink C505 C500
:3c11m_8p3b
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL -o %COL% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BN -o %BN% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k CYAP -o %CYAP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k MAGP -o %MAGP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k YELP -o %YELP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k WASB -o %WASB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMKP -o %DRUMKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMCP -o %DRUMCP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMMP -o %DRUMMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMYP -o %DRUMYP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSB -o %FUSB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k KITB -o %KITB% >> %_log%
goto chiudi

::3c12m_12p xerox WorxkCentre 6655
:3c12m_12p
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL -o %COL% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BN -o %BN% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k CYAP -o %CYAP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k MAGP -o %MAGP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k YELP -o %YELP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMKP -o %DRUMKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMCP -o %DRUMCP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMMP -o %DRUMMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMYP -o %DRUMYP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSP -o %FUSP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k WASP -o %WASP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BELTP -o %BELTP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BIASP -o %BIASP% >> %_log%
goto chiudi

::4c6m_5p1b xerox WorckCentre 8900
:4c6m_5p1b
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL1 -o %COL1% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL2 -o %COL2% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL3 -o %COL3% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k CYAP -o %CYAP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k MAGP -o %MAGP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k YELP -o %YELP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k WASB -o %WASB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k KITP -o %KITP% >> %_log%
goto chiudi

::5c12m_11p1b xerox WorkCentre 7220 7225 7525 7530 7535 7545 7556 7830 7835 7845 7855 AltaLink C8035 8045 C8055 C8070
:5c12m_11p1b
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL -o %COL% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BN -o %BN% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COLG -o %COLG% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BNG -o %BNG% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k CYAP -o %CYAP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k MAGP -o %MAGP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k YELP -o %YELP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMKP -o %DRUMKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMCP -o %DRUMCP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMMP -o %DRUMMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMYP -o %DRUMYP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSP -o %FUSP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k WASB -o %WASB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BELTP -o %BELTP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BIASP -o %BIASP% >> %_log%
goto chiudi

::5c12m_8p4b xerox WorkCentre 7120 7125 VersaLink C7020 C7025 C7030
:5c12m_8p4b
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL -o %COL% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BN -o %BN% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COLG -o %COLG% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BNG -o %BNG% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k CYAP -o %CYAP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k MAGP -o %MAGP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k YELP -o %YELP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMKP -o %DRUMKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMCP -o %DRUMCP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMMP -o %DRUMMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMYP -o %DRUMYP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k WASB -o %WASB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BIASB -o %BIASB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BELTB -o %BELTB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSB -o %FUSB% >> %_log%
goto chiudi

::6c6m_5p1b xerox ColorQube 9303
:6c6m_5p1b
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COLG -o %COLG% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BNG -o %BNG% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL1 -o %COL1% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL2 -o %COL2% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL3 -o %COL3% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k CYAP -o %CYAP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k MAGP -o %MAGP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k YELP -o %YELP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k WASB -o %WASB% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k KITP -o %KITP% >> %_log%
goto chiudi

::6c8m_8p lexmark XC4240
:6c8m_8p
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BN -o %BN% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL -o %COL% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL3 -o %COL3% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL2 -o %COL2% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL1 -o %COL1% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k CYAP -o %CYAP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BELTP -o %BELTP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMP -o %DRUMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k MAGP -o %MAGP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k KITP -o %KITP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k WASP -o %WASP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k YELP -o %YELP% >> %_log%
goto chiudi

::8c13m_13p lexmark XC9235 XC9245 XC9255 XC9265
:8c13m_13p
zabbix_sender.exe -z %_server% -s %host% -k TOT -o %TOT% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BN -o %BN% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL -o %COL% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BNG -o %BNG% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COLG -o %COLG% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL3 -o %COL3% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL2 -o %COL2% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k COL1 -o %COL1% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k KITP -o %KITP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DEVKP -o %DEVKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMKP -o %DRUMKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k BLKP -o %BLKP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DEVCP -o %DEVCP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMCP -o %DRUMCP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k CYAP -o %CYAP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k FUSP -o %FUSP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMMP -o %DRUMMP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k MAGP -o %MAGP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k WASP -o %WASP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k DRUMYP -o %DRUMYP% >> %_log%
zabbix_sender.exe -z %_server% -s %host% -k YELP -o %YELP% >> %_log%
goto chiudi

:chiudi
zabbix_sender.exe -z %_server% -s %host% -k DATA -o "%date%" >> %_log%
echo spediti dati >> %_log%
rmdir %_lck%
echo rimosso lock >> %_log%
echo OK >> %_log%
echo. >> %_log%
echo OK
goto fine

:fine
ENDLOCAL