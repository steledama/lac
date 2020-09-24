@echo off
REM LAC LetturaAutomaticaContatori by stefano@clasr.com
SETLOCAL
cd %~dp0
set versione=3.9.2
set lista=no
if [%1]==[] goto benvenuto
if /i %1==uninstall goto uninstall
echo Parametro non valido
goto fine

:benvenuto
echo.
echo            LAC
echo LetturaAutomaticaContatori
echo     --- %versione% ---
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
	set template=1c1m
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"3315"
"3325"
"3550"
) DO (
IF "%modello%"=="%%~G" (
	set template=1c1m1
	if /i %lista%==si goto configurazione
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
	set template=1c2m2
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"B400"
"B405"
) DO (
IF "%modello%"=="%%~G" (
	set template=1c3m2
	if /i %lista%==si goto configurazione
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
	set template=1c4m2
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"3655"
) DO (
IF "%modello%"=="%%~G" (
	set template=1c5m1
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"5325"
"5330"
"5335"
) DO (
IF "%modello%"=="%%~G" (
	set template=2c3m2
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"B7025"
"B7030"
"B7035"
) DO (
IF "%modello%"=="%%~G" (
	set template=2c4m2
	if /i %lista%==si goto configurazione
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
	set template=2c4m4
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"8570"
"8580"
) DO (
IF "%modello%"=="%%~G" (
	set template=3c6m
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"C400"
"C405"
) DO (
IF "%modello%"=="%%~G" (
	set template=3c8m5
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"6600"
"6605"
) DO (
IF "%modello%"=="%%~G" (
	set template=3c8m8
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"6700"
) DO (
IF "%modello%"=="%%~G" (
	set template=3c11m4
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"C500"
"C505"
) DO (
IF "%modello%"=="%%~G" (
	set template=3c11m8
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"6655"
) DO (
IF "%modello%"=="%%~G" (
	set template=3c12m4
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"8900"
) DO (
IF "%modello%"=="%%~G" (
	set template=4c6m
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"9303"
) DO (
IF "%modello%"=="%%~G" (
	set template=6c6m
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"7120"
"7125"
) DO (
IF "%modello%"=="%%~G" (
	set template=5c12m8
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"C7020"
"C7025"
"C7030"
) DO (
IF "%modello%"=="%%~G" (
	set template=5c12m8_2
	if /i %lista%==si goto configurazione
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
	set template=5c12m4
	if /i %lista%==si goto configurazione
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
"C9235"
"XC9235"
"XC9245"
"XC9255"
"XC9265"
) DO (
IF "%modello%"=="%%~G" (
	set template=8c13m13
	if /i %lista%==si goto configurazione
	goto conferma
	)
)

FOR %%G IN (
"XC4240"
) DO (
IF "%modello%"=="%%~G" (
	set template=6c8m8
	if /i %lista%==si goto configurazione
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
echo u. uscita
echo r. ricomincia
echo -
echo n. no
echo s. si (invio)
set conferma=s
set /p conferma = %serie% %ip% %marca% %modello% Confermi? Inserisci (s,n):
echo.
if /i %conferma%==u goto fine
if /i %conferma%==r goto goal
::-
if /i %conferma%==n goto serie
if /i %conferma%==s goto configurazione
echo Scelta conferma non valida: scegli s,n oppure u per uscire, r per ricominciare
echo.
goto conferma

:configurazione
(
echo LogType=file
echo LogFile=%~dp0 zabbix_agentd.log
echo LogFileSize=1
echo DebugLevel=3
echo.
echo StartAgents=0
echo.
echo RefreshActiveChecks=3600
echo.
echo ServerActive=print.clasrl.com
echo.
echo UserParameter=DATA,date /t
:: serie
echo Hostname=%modello%_%serie%
echo HostMetadata=%rivenditore% %template% %marca%
::ip
echo UserParameter=IP,echo %ip%
::vrs
echo UserParameter=VRS,echo %versione%
)>%modello%_%serie%.conf
:: contatori e consumabili
goto %template%

:agent
if /i %lista%==si (
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
	echo.
	pause
	goto fine
	)
@echo Scelta non valida: scegli s,n
goto agent

:lista
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
echo Servizio disinstallato correttamente.
goto fine
:killall
for /f "delims=|" %%f in ('dir /b *.conf') do call zabbix_agentd.exe --config %%~nxf --stop --multiple-agents
for /f "delims=|" %%f in ('dir /b *.conf') do call zabbix_agentd.exe --config %%~nxf --uninstall --multiple-agents
for /f "delims=|" %%f in ('dir /b *.conf') do del %%~nxf
echo Tutti i servizi sono stati disintallati.
goto fine

:profilo
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

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::MODELLI:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::1c1m xerox phaser 3200 3320 3635
:1c1m
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::1c1m1 xerox workcentre 3315 3325 3550
:1c1m1
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::1c2m2 xerox phaser 3330 3610 4600 worcentre 3335 3345 3615 4250
:1c2m2
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::1c3m2 xerox VersaLink B400 B405
:1c3m2
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=KITB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::1c4m2 xerox WorkCentre 5225 5230 Versalink B600 B610 B605 B615
:1c4m2
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BIASB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::1c5m1 xerox WorkCentre 3655
:1c5m1
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BIASP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=KITP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::2c3m2 xerox WorkCentre 5325 5330 5335
:2c3m2
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BNG[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::2c4m2 xerox VersaLink B7025 B7030 B7035
:2c4m2
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BNG[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BIASB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::2c4m4 xerox WorkCentre 5945 5955 Altalink B8045 B8055 B8065 B8075 B8090
:2c4m4
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BNG[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUST[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BIAST[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BIASR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::3c6m xerox ColorQube 8570 8580
:3c6m
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BN[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=KITP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WASB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::3c8m5 xerox VERSALINK C400 C405
:3c8m5
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BN[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WASB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=KITB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::3c8m8 xerox Phaser 6600 WorkCentre 6605
:3c8m8
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BN[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WAST[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WASR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUST[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BELTT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BELTR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::3c11m4 xerox Phaser 6700
:3c11m4
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BN[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMBP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMCP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMMP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMYP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WASB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BELTP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::3c11m8 xerox VersaLink C505 C500
:3c11m8
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BN[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WASB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMCT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMCR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMMT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMMR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMYT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMYR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=KITB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::3c12m4 xerox WorxkCentre 6655
:3c12m4
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BN[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMKP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMCP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMMP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMYP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WASP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BELTP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BIASP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::4c6m xerox ColorQube 8900
:4c6m
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL1[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL2[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL3[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WASB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=KITP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::5c12m4 xerox WORKCENTRE 7220 7225 7525 7530 7535 7545 7556 7830 7835 7845 7855 AltaLink C8035 8045 C8055 C8070
:5c12m4
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BN[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BNG[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COLG[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMKP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMCP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMMP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMYP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WASB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BELTP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BIASP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::5c12m8 xerox WorkCentre 7120 7125 VersaLink C7020 C7025 C7030
:5c12m8
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BN[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BNG[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COLG[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WASB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMYT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMYR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMMT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMMR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMCT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMCR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BIASB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BELTB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent
:5c12m8_2
goto 5c12m8

::6c6m xerox ColorQube 9303
:6c6m
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COLG[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BNG[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL1[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL2[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL3[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WASB[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=KITP[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::6c8m8 lexmark XC4240
:6c8m8
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BN[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL1[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL2[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL3[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BELTT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BELTR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=KITT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=KITR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WAST[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WASR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

::8c13m13 lexmark C9235 XC9235 XC9245 XC9255 XC9265
:8c13m13
echo UserParameter=TOT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BN[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BNG[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COLG[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL1[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL2[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=COL3[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=KITT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=KITR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DEVKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DEVKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=BLKR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DEVCT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DEVCR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMCT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMCR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=CYAR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUST[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=FUSR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMMT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMMR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=MAGR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WAST[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=WASR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMYT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=DRUMYR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELT[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
echo UserParameter=YELR[*],SNMPGET -v1 -c public %ip% $1>>%modello%_%serie%.conf
goto agent

:fine
ENDLOCAL