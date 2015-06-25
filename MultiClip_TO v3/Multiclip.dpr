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
	sProgramName = 'Multiclip';
	sCommandsModeKey = '/commands';
	sSettingsModeKey = '/settings';

var
	hMutex: THandle;

{$R *.res}

function CheckMutex: Boolean;
begin
	hMutex := OpenMutex(MUTEX_ALL_ACCESS, False, sMutexName);
	Result := hMutex = 0;
	if Result then hMutex := CreateMutex(nil, False, sMutexName)
	else begin
		CloseHandle(hMutex);
		MessageBox(Application.Handle, sProgramAlreadyRun, sProgramName, MB_OK or MB_ICONERROR);
	end;
end;

begin
	if CheckMutex then begin
		Application.Title := 'Multiclip';
		if ParamCount = 0 then begin
			Application.CreateForm(TMainForm, MainForm);
			Application.CreateForm(TAboutBox, AboutBox);
			ShowWindow(Application.Handle, SW_HIDE);
		end else if ParamStr(1) = sSettingsModeKey then Application.CreateForm(TfrmSettings, frmSettings)
		else if ParamStr(1) = sCommandsModeKey then Application.CreateForm(TfrmCommands, frmCommands);
		Application.Run;
		ReleaseMutex(hMutex);
		CloseHandle(hMutex);
	end;
end.

