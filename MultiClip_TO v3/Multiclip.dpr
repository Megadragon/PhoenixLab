program Multiclip;

uses
  Forms,
  Windows,
  uMain in 'src\uMain.pas' {MainForm},
  uAbout in 'src\uAbout.pas' {AboutBox},
  uCommandList in 'src\uCommandList.pas',
  uCommands in 'src\uCommands.pas' {frmCommands},
  uSettings in 'src\uSettings.pas' {frmSettings};

const
  sMutexName = 'Multiclip_Control_Mutex';
  sProgramAlreadyRun = 'Программа Multiclip уже запущена';

var
  hMutex: THandle;

{$R *.res}

begin
  Application.Title := 'Multiclip';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TfrmCommands, frmCommands);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TAboutBox, AboutBox);
  hMutex := OpenMutex(READ_CONTROL, True, sMutexName);
  if hMutex = 0 then begin
    hMutex := CreateMutex(nil, True, sMutexName);
    ShowWindow(Application.Handle, SW_HIDE);
    Application.Run;
    ReleaseMutex(hMutex);
  end else MessageBox(Application.Handle, sProgramAlreadyRun, PChar(Application.Title), MB_OK or MB_ICONSTOP);
  CloseHandle(hMutex);
end.

