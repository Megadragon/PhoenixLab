program Multiclip;

uses
	Forms,
	Windows,
	uMain in 'uMain.pas' {MainForm},
	uAbout in 'uAbout.pas' {AboutBox},
	uCommandList in 'uCommandList.pas',
	uCommands in 'uCommands.pas' {frmCommands},
	uSettings in 'uSettings.pas' {frmSettings};

{$R *.res}
{$R WindowsXP.res}

var
	hMutex: THandle;

function CheckMutex: Boolean;
begin
	hMutex := OpenMutex(MUTEX_ALL_ACCESS, False, 'Multiclip_Control_Mutex');
	Result := hMutex = 0;
	if Result then hMutex := CreateMutex(nil, False, 'Multiclip_Control_Mutex')
	else begin
		CloseHandle(hMutex);
		MessageBox(Application.Handle, 'Программа Multiclip уже запущена.', 'Multiclip', MB_OK or MB_ICONERROR);
	end;
end;

begin
	if CheckMutex then begin
		Application.Title := 'Multiclip';
		if ParamCount = 0 then begin
			Application.CreateForm(TMainForm, MainForm);
			Application.CreateForm(TAboutBox, AboutBox);
			ShowWindow(Application.Handle, SW_HIDE);
		end else if ParamStr(1) = '/settings' then Application.CreateForm(TfrmSettings, frmSettings)
		else if ParamStr(1) = '/commands' then Application.CreateForm(TfrmCommands, frmCommands);
		Application.Run;
		ReleaseMutex(hMutex);
	end;
end.