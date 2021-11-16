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
OutputBaseFilename={#MyAppName}-v{#MyAppVersion}_setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64
; For upgrade
CreateUninstallRegKey=no
UpdateUninstallLogAppName=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"

[Files]
Source: "{#USERPROFILE}\Documents\GitHub\lac\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "\.next,\node_modules,conf.json,confAuto.json"
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "http://localhost:3000"; IconFilename: "{app}\win\lac.ico"

[Run]
; Install Node based on x86 or x64 architecture
Filename: "{sys}\msiexec.exe"; Parameters: "/passive /i ""{app}\win\{#NODE}"""; StatusMsg: "Installing nodejs..."; BeforeInstall: UpdateProgress(0); AfterInstall: UpdateProgress(40)

; Script to download node modules, build nextjs app and install windows service...
Filename: "{app}\win\{#SETUP}"; StatusMsg: "Downloading node modules, building nextjs app and installing windows service. Pleae wait..."; AfterInstall: UpdateProgress(80); Flags: runhidden shellexec waituntilterminated

; Create scheduled task for monitoring every 4 hour
Filename: "powershell.exe"; \
  Parameters: "-ExecutionPolicy Bypass -File ""{app}\win\createTask.ps1"""; \
  WorkingDir: {app}; StatusMsg: "Creating scheduled task..."; Flags: runhidden

; Add Firewall Rules
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""LAC"" program=""{app}\zabbix_sender.exe"" dir=out action=allow enable=yes"; Flags: runhidden
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Nodejs In"" program=""{commonpf}\nodejs\node.exe"" dir=in action=allow enable=yes"; Flags: runhidden
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Nodejs Out"" program=""{commonpf}\nodejs\node.exe"" dir=out action=allow enable=yes"; AfterInstall: UpdateProgress(90); Flags: runhidden

; Start service
Filename: "{sys}\net.exe"; Parameters: "start {#MyAppShortName}"; StatusMsg: "Starting service..."; Flags: runhidden;

;Postinstall launch setup.cmd
Filename: "http://localhost:3000"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: shellexec postinstall skipifsilent

[UninstallRun]
; Uninstall lac service
Filename: "{commonpf}\nodejs\node.exe"; Parameters: "{app}\win\serviceUninstall.js"; WorkingDir: {app}; Flags: runhidden shellexec waituntilterminated; RunOnceId: "Uninistall"

; Delete scheduled task
Filename: "powershell.exe"; \
  Parameters: "-ExecutionPolicy Bypass -File ""{app}\win\deleteTask.ps1"""; \
  WorkingDir: {app}; Flags: waituntilterminated runhidden shellexec; RunOnceId: "Uninistall"

; Remove Firewall Rules
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""LAC"" program=""{app}\zabbix_sender.exe"""; Flags: runhidden; RunOnceId: "Uninistall"
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""NodeJS In"" program=""{commonpf}\nodejs\node.exe"""; Flags: runhidden; RunOnceId: "Uninistall"
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""NodeJS Out"" program=""{commonpf}\nodejs\node.exe"""; Flags: runhidden; RunOnceId: "Uninistall"

; Uninstall Node
Filename: "{sys}\msiexec.exe"; Parameters: "/passive /x ""{app}\win\{#NODE}"""; RunOnceId: "Uninistall"

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

procedure UpdateProgress(Position: Integer);
begin
  WizardForm.ProgressGauge.Position :=
    Position * WizardForm.ProgressGauge.Max div 100;
end;