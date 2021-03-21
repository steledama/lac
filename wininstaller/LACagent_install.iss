; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "LAC"
#define MyAppLCShortName "lac"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Stefano Pompa"
#define MyAppURL "https://github.com/steledama/lac"
#define MyAppExeName "lac.bat"

#define MyAppIcon "web-trifecta-badge.ico"

#define NSSM "nssm.exe"
#define NSSM32 "nssm-x86.exe"
#define NSSM64 "nssm.exe"
#define NODE32 "node-v15.12.0-x86.msi"
#define NODE64 "node-v15.12.0-x64.msi"
#define NODE "node-v15.12.0-x64.msi"
#define USERPROFILE "C:\Users\stefa"


[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{44AFBA42-0ADB-4F49-8DB5-D98CA14D51FD}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName=C:\{#MyAppName}
DisableDirPage=yes
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
;LicenseFile={#USERPROFILE}\Downloads\LICENSE.txt
;InfoBeforeFile={#USERPROFILE}\Downloads\before.txt
;InfoAfterFile={#USERPROFILE}\Downloads\after.txt
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir={#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller
OutputBaseFilename={#MyAppName}agent_install
Compression=lzma
SolidCompression=yes


[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"


[Files]
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\{#MyAppIcon}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\{#NODE32}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\{#NODE64}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\{#NSSM64}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\{#NSSM32}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\scheduledTaskAgent.ps1"; DestDir: "{app}\bin"; Flags: ignoreversion
;Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\scheduledTaskServer.ps1"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\unregisterTask.ps1"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\lac.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\agent\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\node_modules\*"; DestDir: "{app}\node_modules"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files


[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppIcon}"

; Here's an example of how you could use a start menu item for just Chrome, no batch file
; Name: "{group}\{#MyAppName}"; Filename: "{pf32}\Google\Chrome\Application\chrome.exe"; Parameters: "--app=http://localhost:5566 --user-data-dir=%APPDATA%\{#MyAppName}\"; IconFilename: "{app}\{#MyAppIcon}"


[Run]
; These all run with 'runascurrentuser' (i.e. admin) whereas 'runasoriginaluser' would refer to the logged in user
; Install Node
Filename: "{sys}\msiexec.exe"; Parameters: "/passive /i ""{app}\{#NODE}""";

; Download node_modules with npm
;Filename: "{pf64}\nodejs\node.exe"; Parameters: "npm install --quiet"; Flags: runhidden;

; Add Firewall Rules
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Node In"" program=""{pf64}\nodejs\node.exe"" dir=in action=allow enable=yes"; Flags: runhidden;
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Node Out"" program=""{pf64}\nodejs\node.exe"" dir=out action=allow enable=yes"; Flags: runhidden;

; Add System Service
;Filename: "{pf64}\nodejs\node.exe"; Parameters: "{app}\bin\windows-service-installer.js"; Flags: runhidden;
Filename: "{app}\{#NSSM}"; Parameters: "install {#MyAppName} ""{pf64}\nodejs\node.exe"" ""{app}\server\server.js"""; Flags: runhidden;
Filename: "{sys}\net.exe"; Parameters: "start {#MyAppName}"; Flags: runhidden;

; Powershell scripts to create scheduled tasks: agent and server
Filename: "powershell.exe"; \
  Parameters: "-ExecutionPolicy Bypass -File ""{app}\bin\scheduledTaskAgent.ps1"""; \
  WorkingDir: {app}\bin; Flags: runhidden
;Filename: "powershell.exe"; \
  ;Parameters: "-ExecutionPolicy Bypass -File ""{app}\bin\scheduledTaskServer.ps1"""; \
  ;WorkingDir: {app}\bin; Flags: runhidden

;Postinstall launch
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: shellexec postinstall skipifsilent runhidden

; Open web browser
;Filename: http://localhost:5566; Description: "lac"; Flags: postinstall shellexec

[UninstallRun]
; Removes System Service
;Filename: "{sys}\net.exe"; Parameters: "stop {#MyAppName}"; Flags: runhidden;
;Filename: "{pf64}\nodejs\node.exe"; Parameters: "{app}\bin\windows-service-uninstall.js"; Flags: runhidden;
;Filename: "{app}\{#NSSM}"; Parameters: "remove {#MyAppName} confirm"; Flags: runhidden;

; Remove Firewall Rules
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Node In"" program=""{pf64}\nodejs\node.exe"""; Flags: runhidden;
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Node Out"" program=""{pf64}\nodejs\node.exe"""; Flags: runhidden;

; Uninstall Node
Filename: "{sys}\msiexec.exe"; Parameters: "/passive /x ""{app}\{#NODE}""";

; Powershell script to unregister scheduled task
Filename: "powershell.exe"; \
  Parameters: "-ExecutionPolicy Bypass -File ""{app}\bin\unregisterTask.ps1"""; \
  WorkingDir: {app}; Flags: runhidden

; Remove all leftovers
;Filename: "{sys}\rmdir"; Parameters: "-r ""{app}""";