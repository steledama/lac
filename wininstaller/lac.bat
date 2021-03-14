:: %~dp0 is the directory where this file is located, similar to node's __dirname

:: Open App in Chrome or another application
@IF EXIST "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" (
  "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --app=http://localhost:5566 
) ELSE (
  start http://localhost:5566
)

:: Note that comments can't be nested in if blocks!

::  IF EXIST "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" (
:: Need to read more http://support.mozilla.org/en-US/questions/955250
:: https://developer.mozilla.org/en-US/docs/Getting_started_with_XULRunner
::  "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" -app %~dp0\firefox-app.ini
::  ) ELSE (
::  )
