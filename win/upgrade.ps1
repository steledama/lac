# change current working directory
Set-Location -LiteralPath C:\LAC

# install node modules
& "$env:ProgramFiles\nodejs\node.exe" "C:\Program Files\nodejs\node_modules\npm\bin\npm-cli.js" install ##64

# build nextjs production app
& "$env:ProgramFiles\nodejs\node.exe" "C:\LAC\node_modules\next\dist\bin\next" build ##64

# install windows service to start the app
& "$env:ProgramFiles\nodejs\node.exe" "C:\LAC\win\serviceInstall.js" ##64

# start service
net.exe "stop LAC"

# start service
net.exe "start LAC"