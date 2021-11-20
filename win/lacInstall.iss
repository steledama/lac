; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "LAC"
#define MyAppVersion "1.0.2"
#define MyAppPublisher "steledama"
#define MyAppURL "https://github.com/steledama/lac"
;#define USERPROFILE "C:\Users\stefano"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{E16C8990-2083-4CB6-893E-21E6617F9578}
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
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=C:\Users\stefano\Desktop
OutputBaseFilename=LAC-v{#MyAppVersion}_setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"

[Files]
Source: "C:\Users\stefano\Documents\GitHub\lac\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "\.next,\node_modules,conf.json,confAuto.json"
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "http://localhost:3000"; IconFilename: "{app}\win\lac.ico"

[Run]
; Run install script
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\win\lacInstall.ps1"""; StatusMsg: "Downloading node modules, building nextjs app and installing windows service. Please wait..."; Flags: runhidden; BeforeInstall: UpdateProgress(60)

;Postinstall launch setup.cmd
Filename: "http://localhost:3000"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: shellexec postinstall skipifsilent

[UninstallRun]
; Run uninstall script
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\win\lacUninstall.ps1"""; Flags: runhidden; RunOnceId: "Uninistall"

[UninstallDelete]
Type: filesandordirs; Name: "C:\LAC"

[Code]
procedure UpdateProgress(Position: Integer);
begin
  WizardForm.ProgressGauge.Position :=
    Position * WizardForm.ProgressGauge.Max div 100;
end;