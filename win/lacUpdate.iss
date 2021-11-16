#define MyAppName "LAC"
#define MyAppVersion "1.0.1"
#define MyAppPublisher "Stefano Pompa"
#define MyAppURL "https://github.com/steledama/lac"
#define NODE "{code:GetNODE}"
#define SETUP "{code:GetSETUP}"
#define USERPROFILE "C:\Users\stefa"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{CCBF0BED-21E8-435A-8525-FA5B656072DA}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName=C:\{#MyAppName}
; not let user chose install directory
DisableDirPage=yes
; If this is set to yes, Setup will not show the Select Start Menu Folder wizard page.
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
; Where the installer wil be produced
OutputDir={#USERPROFILE}\Desktop
OutputBaseFilename={#MyAppName}-v{#MyAppVersion}_update
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"

[Files]
; update without node
Source: "{#USERPROFILE}\Documents\GitHub\lac\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "\.next,\node_modules,conf.json,confAuto.json,\win\node-v*"
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

; update without icon
; [Icons]
; Name: "{group}\{#MyAppName}"; Filename: "http://localhost:3000"; IconFilename: "{app}\win\lac.ico"

[Run]
; Install Node based on x86 or x64 architecture
; update without installing node
;Filename: "{sys}\msiexec.exe"; Parameters: "/passive /i ""{app}\win\{#NODE}"""; Flags: waituntilterminated

; Script to download node modules, build nextjs app and install windows service...
Filename: "{app}\win\{#SETUP}"; Description: "Downloading node modules, building nextjs app and installing windows service..."; Flags: waituntilterminated runhidden

; Create scheduled task for monitoring every 4 hour
; update without scheduled task
; Filename: "powershell.exe"; \
;   Parameters: "-ExecutionPolicy Bypass -File ""{app}\win\createTask.ps1"""; \
;   WorkingDir: {app}; Flags: waituntilterminated runhidden

; Add Firewall Rules
; update without changing firewall rules
; Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""LAC"" program=""{app}\zabbix_sender.exe"" dir=out action=allow enable=yes"; Flags: waituntilterminated runhidden
; Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Nodejs In"" program=""{commonpf}\nodejs\node.exe"" dir=in action=allow enable=yes"; Flags: waituntilterminated runhidden
; Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Nodejs Out"" program=""{commonpf}\nodejs\node.exe"" dir=out action=allow enable=yes"; Flags: waituntilterminated runhidden

; Start service
; update without starting service
; Filename: "{sys}\net.exe"; Parameters: "start {#MyAppShortName}"; Flags: runhidden;

;Postinstall launch setup.cmd
Filename: "http://localhost:3000"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: shellexec postinstall skipifsilent

[UninstallRun]
; Uninstall lac service
Filename: "{commonpf}\nodejs\node.exe"; Parameters: "{app}\win\serviceUninstall.js"; WorkingDir: {app}; Flags: waituntilterminated runhidden shellexec

; Delete scheduled task
Filename: "powershell.exe"; \
  Parameters: "-ExecutionPolicy Bypass -File ""{app}\win\deleteTask.ps1"""; \
  WorkingDir: {app}; Flags: waituntilterminated runhidden shellexec

; Remove Firewall Rules
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""LAC"" program=""{app}\zabbix_sender.exe"""; Flags: waituntilterminated runhidden
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""NodeJS In"" program=""{commonpf}\nodejs\node.exe"""; Flags: waituntilterminated runhidden
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""NodeJS Out"" program=""{commonpf}\nodejs\node.exe"""; Flags: waituntilterminated runhidden

; Uninstall Node
Filename: "{sys}\msiexec.exe"; Parameters: "/passive /x ""{app}\win\{#NODE}"""

[UninstallDelete]
Type: filesandordirs; Name: "C:\LAC"

[Code]
function GetNODE(Param: string): string;
begin
  if IsWin64 then Result := 'node-v16.13.0-x64.msi'
    else Result := 'node-v16.13.0-x86.msi';
end;

function GetSETUP(Param: string): string;
begin
  if IsWin64 then Result := 'setup-x64.cmd'
    else Result := 'setup-x86.cmd';
end;