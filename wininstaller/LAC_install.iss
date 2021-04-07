#define MyAppName "LAC"
#define MyAppLCShortName "lac"
#define MyAppVersion "1.1.0"
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
OutputDir={#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller
OutputBaseFilename={#MyAppName}_install
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"

[Files]
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\{#MyAppIcon}"; DestDir: "{app}\win"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\{#NODE32}"; DestDir: "{app}\win"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\{#NODE64}"; DestDir: "{app}\win"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\{#NSSM64}"; DestDir: "{app}\win"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\{#NSSM32}"; DestDir: "{app}\win"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\createTask.ps1"; DestDir: "{app}\win"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\deleteTask.ps1"; DestDir: "{app}\win"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\lac.bat"; DestDir: "{app}\win"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\wininstaller\installReadMe.md"; DestDir: "{app}\win"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\*"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\node_modules\*"; DestDir: "{app}\node_modules"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#USERPROFILE}\Documents\GitHub\{#MyAppName}\public\*"; DestDir: "{app}\public"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppIcon}"

[Run]
; Install Node
Filename: "{sys}\msiexec.exe"; Parameters: "/passive /i ""{app}\win\{#NODE}""";

; Add Firewall Rules
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Node In"" program=""{pf64}\nodejs\node.exe"" dir=in action=allow enable=yes"; Flags: runhidden;
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Node Out"" program=""{pf64}\nodejs\node.exe"" dir=out action=allow enable=yes"; Flags: runhidden;

; Add System Service
Filename: "{app}\win\{#NSSM}"; Parameters: "install {#MyAppName} ""{pf64}\nodejs\node.exe"" ""{app}\server.js"""; Flags: runhidden;
Filename: "{sys}\net.exe"; Parameters: "start {#MyAppName}"; Flags: runhidden;

; Powershell scripts to create scheduled tasks
Filename: "powershell.exe"; \
  Parameters: "-ExecutionPolicy Bypass -File ""{app}\win\createTask.ps1"""; \
  WorkingDir: {app}\bin; Flags: runhidden

;Postinstall launch
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: shellexec postinstall skipifsilent runhidden

[UninstallRun]
; Removes System Service
Filename: "{sys}\net.exe"; Parameters: "stop {#MyAppName}"; Flags: runhidden;
Filename: "{app}\win\{#NSSM}"; Parameters: "remove {#MyAppName} confirm"; Flags: runhidden;

; Remove Firewall Rules
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Node In"" program=""{pf64}\nodejs\node.exe"""; Flags: runhidden;
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Node Out"" program=""{pf64}\nodejs\node.exe"""; Flags: runhidden;

; Uninstall Node
Filename: "{sys}\msiexec.exe"; Parameters: "/passive /x ""{app}\{#NODE}""";

; Powershell script to unregister scheduled task
Filename: "powershell.exe"; \
  Parameters: "-ExecutionPolicy Bypass -File ""{app}\win\deleteTask.ps1"""; \
  WorkingDir: {app}; Flags: runhidden

; Remove all leftovers
;Filename: "{sys}\rmdir"; Parameters: "-r ""{app}""";