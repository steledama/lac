@echo off
cd C:\LAC
call "C:\Program Files (x86)\nodejs\node.exe" "C:\Program Files (x86)\nodejs\node_modules\npm\bin\npm-cli.js" install
call "C:\Program Files (x86)\nodejs\node.exe" "C:\LAC\node_modules\.bin\next.cmd" build
call "C:\Program Files (x86)\nodejs\node.exe" C:\LAC\win\serviceInstall.js