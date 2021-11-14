@echo off
cd C:\LAC
call "C:\Program Files\nodejs\node.exe" "C:\Program Files\nodejs\node_modules\npm\bin\npm-cli.js" install
pause
call "C:\Program Files\nodejs\node.exe" "C:\LAC\node_modules\next\dist\bin\next" build
pause
call "C:\Program Files\nodejs\node.exe" "C:\LAC\win\serviceInstall.js"