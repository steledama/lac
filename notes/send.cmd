@echo off
REM LAC_send by stefano.pompa@gmail.com
SETLOCAL

set _versione=4.1.6
set _dir=%~dp0
set _server=print.clasrl.com

set _profilo=%1
set _ip=%2
set _host=%3

set _log=%_dir%%_host%.log

echo. >> %_log%
echo %date%-%time% >> %_log%

:: CONTROLLO PING
ping -n 1 %_ip% | findstr /r /c:[0-9] *ms > nul 2>&1
if %errorlevel% == 0 (
    goto %_profilo%
) else (
    goto NO_PING
)
:NO_PING
echo NO_PING >> %_log%
echo NO_PING
goto fine

:: PROFILI ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::phaser 3200 3320 3635
:1c1m_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKP=%%G
goto 1c1m_1p

::1c1m1 xerox workcentre 3315 3325 3550
:1c1m1_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
goto 1c1m_1p

::1c2m2 xerox phaser 3330 3610 4600 worcentre 3335 3345 3615 4250
:1c2m2_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
goto 1c2m_2p

::1c3m2 xerox VersaLink B400 B405
:1c3m2_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::KITB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.40
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set KITB=%%G
goto 1c3m_2p1b

::1c4m2 xerox WorkCentre 5225 5230 Versalink B600 B610 B605 B615
:1c4m2_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::BIASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BIASB=%%G
::BIASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSB=%%G
goto 1c4m_2p2b

::1c5m1 xerox WorkCentre 3655
:1c5m1_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMP=%%G
::FUSP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSP=%%G
::BIASP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BIASP=%%G
::KITP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set KITP=%%G
goto 1c5m_5p

::2c3m2 xerox WorkCentre 5325 5330 5335
:2c3m2_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::BNG
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BNG=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::FUSB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSB=%%G
goto 2c3m_2p1b

::2c4m2 xerox VersaLink B7025 B7030 B7035
:2c4m2_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::BNG
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BNG=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::BIASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BIASB=%%G
goto %template%
::FUSB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSB=%%G
goto 2c4m_2p2b

::2c4m4 xerox WorkCentre 5945 5955 Altalink B8045 B8055 B8065 B8075 B8090
:2c4m4_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::BNG
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BNG=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::FUSP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUST=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSR=%%G
set /A FUSP=(FUSR*100)/FUST
::BIASP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BIAST=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BIASR=%%G
set /A BIASP=(BIASR*100)/BIAST
goto 2c4m_4p

::3c6m xerox ColorQube 8570 8580
:3c6m_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::COL
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL=%%G
::BN
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BN=%%G
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAP=%%G
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGP=%%G
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELP=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKP=%%G
::KITP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set KITP=%%G
::WASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASB=%%G
goto 3c6m_5p1b

::3c8m5 xerox VERSALINK C400 C405
:3c8m5_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::COL
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL=%%G
::BN
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BN=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::WASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASB=%%G
::FUSB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSB=%%G
::KITB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.39
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set KITB=%%G
::DRUMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.41
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.41
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
goto 3c8m_5p3b

::3c8m8 xerox Phaser 6600 WorkCentre 6605
:3c8m8_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::COL
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL=%%G
::BN
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BN=%%G
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DRUMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::WASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASB=%%G
::FUSB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSB=%%G
::BELTP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BELTT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BELTR=%%G
set /A BELTP=(BELTR*100)/BELTT
goto 3c8m_8p

::3c11m4 xerox Phaser 6700
:3c11m4_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::COL
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL=%%G
::BN
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BN=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::DRUMKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMKP=%%G
::DRUMCP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMCP=%%G
::DRUMMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMMP=%%G
::DRUMYP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMYP=%%G
::FUSP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSP=%%G
::WASB 100
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASB=%%G
::BELTP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.11
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BELTT=%%G
goto 3c11m_10p1b

::3c11m8 xerox VersaLink C505 C500
:3c11m8_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::COL
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL=%%G
::BN
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BN=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::WASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASB=%%G
::DRUMKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMKR=%%G
set /A DRUMKP=(DRUMKR*100)/DRUMKT
::DRUMYP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMYT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMYR=%%G
set /A DRUMYP=(DRUMYR*100)/DRUMYT
::DRUMMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMMR=%%G
set /A DRUMMP=(DRUMMR*100)/DRUMMT
::DRUMCP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.9
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMCT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMCR=%%G
set /A DRUMCP=(DRUMCR*100)/DRUMCT
::FUSB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSB=%%G
::KITB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.39
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set KITB=%%G
goto 3c11m_8p3b

::3c12m4 xerox WorxkCentre 6655
:3c12m4_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::COL
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL=%%G
::BN
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BN=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::DRUMKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMKP=%%G
::DRUMCP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMCP=%%G
::DRUMMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMMP=%%G
::DRUMYP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMYP=%%G
::FUSP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSP=%%G
::WASP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASP=%%G
::BELTP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.11
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BELTP=%%G
::BIASP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BIASP=%%G
goto 3c12m_12p

::4c6m xerox ColorQube 8900
:4c6m_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::COL1
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.80
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL1=%%G
::COL2
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.81
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL2=%%G
::COL3
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.82
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL3=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKP=%%G
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAP=%%G
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGP=%%G
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELP=%%G
::WASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASB=%%G
::KITP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set KITP=%%G
goto 4c6m_5p1b

::5c12m4 xerox WORKCENTRE 7220 7225 7525 7530 7535 7545 7556 7830 7835 7845 7855 AltaLink C8035 8045 C8055 C8070
:5c12m4_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::COL
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL=%%G
::BN
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BN=%%G
::COLG
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.43
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COLG=%%G
::BNG
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BNG=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::DRUMKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMKP=%%G
::DRUMCP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMCP=%%G
::DRUMMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMMP=%%G
::DRUMYP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMYP=%%G
::FUSP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSP=%%G
::WASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASB=%%G
::BELTP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.11
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BELTP=%%G
::BIASP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BIASP=%%G
goto 5c12m_11p1b

::5c12m8 xerox WorkCentre 7120 7125
:5c12m8_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::COL
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL=%%G
::BN
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BN=%%G
::COLG
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.43
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COLG=%%G
::BNG
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BNG=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::WASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASB=%%G
::DRUMKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMKR=%%G
set /A DRUMKP=(DRUMKR*100)/DRUMKT
::DRUMYP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMYT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMYR=%%G
set /A DRUMYP=(DRUMYR*100)/DRUMYT
::DRUMMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMMR=%%G
set /A DRUMMP=(DRUMMR*100)/DRUMMT
::DRUMCP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.9
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMCT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMCR=%%G
set /A DRUMCP=(DRUMCR*100)/DRUMCT
::BIASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BIASB=%%G
::BELTB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.11
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BELTB=%%G
::FUSB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSB=%%G
goto 5c12m_8p4b

::5c12m8_2 VersaLink C7020 C7025 C7030
:5c12m8_2_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::COL
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.33
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL=%%G
::BN
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.34
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BN=%%G
::COLG
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.43
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COLG=%%G
::BNG
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BNG=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::WASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASB=%%G
::DRUMKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMKR=%%G
set /A DRUMKP=(DRUMKR*100)/DRUMKT
::DRUMYP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMYT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMYR=%%G
set /A DRUMYP=(DRUMYR*100)/DRUMYT
::DRUMMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMMR=%%G
set /A DRUMMP=(DRUMMR*100)/DRUMMT
::DRUMCP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.9
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMCT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMCR=%%G
set /A DRUMCP=(DRUMCR*100)/DRUMCT
::BIASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BIASB=%%G
::BELTB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.11
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BELTB=%%G
::FUSB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSB=%%G
goto 5c12m_8p4b

::6c6m xerox ColorQube 9303
:6c6m_xerox
::TOT
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::COLG
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.43
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COLG=%%G
::BNG
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.44
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BNG=%%G
::COL1
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.80
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL1=%%G
::COL2
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.81
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL2=%%G
::COL3
set _oid=SNMPv2-SMI::enterprises.253.8.53.13.2.1.6.1.20.82
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL3=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKP=%%G
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAP=%%G
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGP=%%G
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELP=%%G
::WASB
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASB=%%G
::KITP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set KITP=%%G
goto 6c6m_5p1b

::LEXMARK:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::6c8m8 lexmark XC4240
:6c8m8_lexmark
::TOT
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::BN
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BN=%%G
::COL
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL=%%G
::COL3
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.22
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL3=%%G
::COL2
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.23
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL2=%%G
::COL1
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.24
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL1=%%G
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.2
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::BELTP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BELTT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BELTR=%%G
set /A BELTP=(BELTR*100)/BELTT
::DRUMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.4
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMR=%%G
set /A DRUMP=(DRUMR*100)/DRUMT
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::KITP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set KITT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set KITR=%%G
set /A KITP=(KITR*100)/KITT
::WASP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WAST=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASR=%%G
set /A WASP=(WASR*100)/WAST
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
goto 6c8m_8p

::8c13m13 lexmark C9235 XC9235 XC9245 XC9255 XC9265
:8c13m13_lexmark
::TOT
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set TOT=%%G
::BN
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BN=%%G
::COL
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL=%%G
::BNG
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.2.1.4.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BNG=%%G
::COLG
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.2.1.5.1.1
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COLG=%%G
::COL3
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.22
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL3=%%G
::COL2
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.23
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL2=%%G
::COL1
set _oid=SNMPv2-SMI::enterprises.641.6.4.2.1.1.4.1.24
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set COL1=%%G
::KITP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set KITT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.3
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set KITR=%%G
set /A KITP=(KITR*100)/KITT
::DEVKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DEVKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.5
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DEVKR=%%G
set /A DEVKP=(DEVKR*100)/DEVKT
::DRUMKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.6
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMKR=%%G
set /A DRUMKP=(DRUMKR*100)/DRUMKT
::BLKP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.7
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set BLKR=%%G
set /A BLKP=(BLKR*100)/BLKT
::DEVCP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DEVCT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.8
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DEVCR=%%G
set /A DEVCP=(DEVCR*100)/DEVCT
::DRUMCP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.9
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMCT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.9
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMCR=%%G
set /A DRUMCP=(DRUMCR*100)/DRUMCT
::CYAP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.10
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.10
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set CYAR=%%G
set /A CYAP=(CYAR*100)/CYAT
::FUSP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.11
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUST=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.11
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set FUSR=%%G
set /A FUSP=(FUSR*100)/FUST
::DRUMMP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.12
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMMT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.12
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMMR=%%G
set /A DRUMMP=(DRUMMR*100)/DRUMMT
::MAGP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.13
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.13
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set MAGR=%%G
set /A MAGP=(MAGR*100)/MAGT
::WASP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.14
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WAST=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.14
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set WASR=%%G
set /A WASP=(WASR*100)/WAST
::DRUMYP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.15
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMYT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.15
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set DRUMYR=%%G
set /A DRUMYP=(DRUMYR*100)/DRUMYT
::YELP
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.8.1.16
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELT=%%G
set _oid=SNMPv2-SMI::mib-2.43.11.1.1.9.1.16
for /F tokens=4 %%G in ('SNMPWALK -v1 -c public %_ip% %_oid%') do set YELR=%%G
set /A YELP=(YELR*100)/YELT
goto 8c13m_13p

::: TEMPLATE ::::::::::::::::::::::::::::::::::::::::::::::::::::::
::1c1m_1p xerox phaser 3200 3320 3635 xerox workcentre 3315 3325 3550
:1c1m_1p
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
goto chiudi

::1c2m_2p xerox phaser 3330 3610 4600 worcentre 3335 3345 3615 4250
:1c2m_2p
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMP -o %DRUMP% >> %_log%
goto chiudi

::1c3m_2p1b xerox VersaLink B400 B405
:1c3m_2p1b
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMP -o %DRUMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k KITB -o %KITB% >> %_log%
goto chiudi

::1c4m_2p2b xerox WorkCentre 5225 5230 Versalink B600 B610 B605 B615
:1c4m_2p2b
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMP -o %DRUMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BIASB -o %BIASB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSB -o %FUSB% >> %_log%
goto chiudi

::1c5m_5p xerox WorkCentre 3655
:1c5m_5p
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMP -o %DRUMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSP -o %FUSP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BIASP -o %BIASP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k KITP -o %KITP% >> %_log%
goto chiudi

::2c3m_2p1b xerox WorkCentre 5325 5330 5335
:2c3m_2p1b
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BNG -o %BNG% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMP -o %DRUMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSB -o %FUSB% >> %_log%
goto chiudi

::2c4m_2p2b xerox VersaLink B7025 B7030 B7035
:2c4m_2p2b
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BNG -o %BNG% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMP -o %DRUMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BIASB -o %BIASB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSB -o %FUSB% >> %_log%
goto chiudi

::2c4m_4p xerox WorkCentre 5945 5955 Altalink B8045 B8055 B8065 B8075 B8090
:2c4m_4p
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BNG -o %BNG% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMP -o %DRUMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSP -o %FUSP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BIASP -o %BIASP% >> %_log%
goto chiudi

::3c6m_5p1b xerox ColorCube 8570 8580
:3c6m_5p1b
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL -o %COL% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BN -o %BN% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k CYAP -o %CYAP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k MAGP -o %MAGP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k YELP -o %YELP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k KITP -o %KITP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k WASB -o %WASB% >> %_log%
goto chiudi

::3c8m_5p3b xerox VersaLink C400 C405
:3c8m_5p3b
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL -o %COL% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BN -o %BN% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k CYAP -o %CYAP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k MAGP -o %MAGP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k YELP -o %YELP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k KITB -o %KITB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k WASB -o %WASB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSB -o %FUSB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMP -o %DRUMP% >> %_log%
goto chiudi

::3c8m_8p xerox Phaser 6600 WorkCentre 6605
:3c8m_8p
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL -o %COL% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BN -o %BN% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k CYAP -o %CYAP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k MAGP -o %MAGP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k YELP -o %YELP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMP -o %DRUMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k WASB -o %WASB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSB -o %FUSB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BELTP -o %BELTP% >> %_log%
goto chiudi

::3c11m_10p1b xerox Phaser 6700
:3c11m_10p1b
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL -o %COL% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BN -o %BN% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k CYAP -o %CYAP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k MAGP -o %MAGP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k YELP -o %YELP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMKP -o %DRUMKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMCP -o %DRUMCP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMMP -o %DRUMMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMYP -o %DRUMYP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSP -o %FUSP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k WASB -o %WASB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BELTP -o %BELTP% >> %_log%
goto chiudi

::3c11m_8p3b xerox VersaLink C505 C500
:3c11m_8p3b
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL -o %COL% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BN -o %BN% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k CYAP -o %CYAP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k MAGP -o %MAGP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k YELP -o %YELP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k WASB -o %WASB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMKP -o %DRUMKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMCP -o %DRUMCP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMMP -o %DRUMMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMYP -o %DRUMYP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSB -o %FUSB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k KITB -o %KITB% >> %_log%
goto chiudi

::3c12m_12p xerox WorxkCentre 6655
:3c12m_12p
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL -o %COL% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BN -o %BN% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k CYAP -o %CYAP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k MAGP -o %MAGP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k YELP -o %YELP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMKP -o %DRUMKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMCP -o %DRUMCP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMMP -o %DRUMMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMYP -o %DRUMYP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSP -o %FUSP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k WASP -o %WASP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BELTP -o %BELTP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BIASP -o %BIASP% >> %_log%
goto chiudi

::4c6m_5p1b xerox WorckCentre 8900
:4c6m_5p1b
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL1 -o %COL1% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL2 -o %COL2% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL3 -o %COL3% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k CYAP -o %CYAP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k MAGP -o %MAGP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k YELP -o %YELP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k WASB -o %WASB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k KITP -o %KITP% >> %_log%
goto chiudi

::5c12m_11p1b xerox WorkCentre 7220 7225 7525 7530 7535 7545 7556 7830 7835 7845 7855 AltaLink C8035 8045 C8055 C8070
:5c12m_11p1b
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL -o %COL% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BN -o %BN% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COLG -o %COLG% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BNG -o %BNG% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k CYAP -o %CYAP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k MAGP -o %MAGP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k YELP -o %YELP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMKP -o %DRUMKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMCP -o %DRUMCP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMMP -o %DRUMMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMYP -o %DRUMYP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSP -o %FUSP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k WASB -o %WASB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BELTP -o %BELTP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BIASP -o %BIASP% >> %_log%
goto chiudi

::5c12m_8p4b xerox WorkCentre 7120 7125 VersaLink C7020 C7025 C7030
:5c12m_8p4b
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL -o %COL% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BN -o %BN% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COLG -o %COLG% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BNG -o %BNG% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k CYAP -o %CYAP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k MAGP -o %MAGP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k YELP -o %YELP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMKP -o %DRUMKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMCP -o %DRUMCP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMMP -o %DRUMMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMYP -o %DRUMYP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k WASB -o %WASB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BIASB -o %BIASB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BELTB -o %BELTB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSB -o %FUSB% >> %_log%
goto chiudi

::6c6m_5p1b xerox ColorQube 9303
:6c6m_5p1b
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COLG -o %COLG% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BNG -o %BNG% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL1 -o %COL1% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL2 -o %COL2% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL3 -o %COL3% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k CYAP -o %CYAP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k MAGP -o %MAGP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k YELP -o %YELP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k WASB -o %WASB% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k KITP -o %KITP% >> %_log%
goto chiudi

::6c8m_8p lexmark XC4240
:6c8m_8p
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BN -o %BN% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL -o %COL% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL3 -o %COL3% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL2 -o %COL2% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL1 -o %COL1% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k CYAP -o %CYAP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BELTP -o %BELTP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMP -o %DRUMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k MAGP -o %MAGP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k KITP -o %KITP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k WASP -o %WASP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k YELP -o %YELP% >> %_log%
goto chiudi

::8c13m_13p lexmark XC9235 XC9245 XC9255 XC9265
:8c13m_13p
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k TOT -o %TOT% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BN -o %BN% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL -o %COL% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BNG -o %BNG% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COLG -o %COLG% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL3 -o %COL3% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL2 -o %COL2% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k COL1 -o %COL1% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k KITP -o %KITP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DEVKP -o %DEVKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMKP -o %DRUMKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k BLKP -o %BLKP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DEVCP -o %DEVCP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMCP -o %DRUMCP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k CYAP -o %CYAP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k FUSP -o %FUSP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMMP -o %DRUMMP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k MAGP -o %MAGP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k WASP -o %WASP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DRUMYP -o %DRUMYP% >> %_log%
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k YELP -o %YELP% >> %_log%
goto chiudi

:chiudi
%_dir%zabbix_sender.exe -z %_server% -s %_host% -k DATA -o %date% >> %_log%
echo spediti dati >> %_log%
rmdir %_lck%
echo rimosso lock >> %_log%
echo OK >> %_log%
echo OK
goto fine

:fine
ENDLOCAL