; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "LAC"
#define MyAppVersion "1.0.0.1"
#define MyAppPublisher "Stefano Pompa"
#define MyAppURL "https://github.com/steledama/lac"
#define MyAppExeName "monitoredPrinters.json"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{A5197861-69FA-43C4-B5C6-383DE8E45A94}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
VersionInfoVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName=C:\{#MyAppName}
DisableDirPage=yes
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir=C:\Users\stefa\Documents\GitHub\lac\install
OutputBaseFilename=lac
Compression=lzma
SolidCompression=yes

[Languages]
Name: italian; MessagesFile: compiler:Languages\Italian.isl

[Files]
Source: C:\Users\stefa\Documents\GitHub\lac\zabbix_sender.exe; DestDir: {app}; Flags: ignoreversion
Source: C:\Users\stefa\Documents\GitHub\lac\lac.js; DestDir: {app}; Flags: ignoreversion
Source: C:\Users\stefa\Documents\GitHub\lac\monitoredPrinters.json; DestDir: {app}; Flags: ignoreversion
Source: C:\Users\stefa\Documents\GitHub\lac\node_modules\*; DestDir: {app}\node_modules; Flags: ignoreversion recursesubdirs
Source: C:\Users\stefa\Documents\GitHub\lac\printersTemplates.json; DestDir: {app}; Flags: ignoreversion
Source: C:\Users\stefa\Documents\GitHub\lac\install\install.ps1; DestDir: {app}; Flags: ignoreversion
Source: C:\Users\stefa\Documents\GitHub\lac\install\uninstall.ps1; DestDir: {app}; Flags: ignoreversion
; NOTE: Don't use Flags: ignoreversion on any shared system files

[Icons]
;Name: {group}\{#MyAppName}; Filename: {app}\{#MyAppExeName}
Name: {group}\{cm:ProgramOnTheWeb,{#MyAppName}}; Filename: {#MyAppURL}
Name: {group}\{cm:UninstallProgram,{#MyAppName}}; Filename: {uninstallexe}

[Run]
Filename: "powershell.exe"; \
  Parameters: "-ExecutionPolicy Bypass -File ""{app}\install.ps1"""; \
  WorkingDir: {app}; Flags: runhidden

[UninstallRun]
Filename: "powershell.exe"; \
  Parameters: "-ExecutionPolicy Bypass -File ""{app}\uninstall.ps1"""; \
  WorkingDir: {app}; Flags: runhidden

[UninstallDelete]
Type: filesandordirs; Name: C:\{#MyAppName};