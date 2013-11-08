program Multiclip;

uses
	Forms, Windows,
	Main in 'Main.pas' {MainForm},
	About in 'About.pas' {AboutBox};

{$R *.res}

var
	hMutex: THandle;

procedure CheckMutex;
begin
	hMutex := OpenMutex(MUTEX_ALL_ACCESS, False, 'Multiclip_Control_Mutex');
	if hMutex <> 0 then begin
		MessageBox(Application.Handle, 'Программа Multiclip уже запущена.', 'Multiclip', MB_OK or MB_ICONERROR);
		CloseHandle(hMutex);
		Application.Terminate;
	end else hMutex := CreateMutex(nil, False, 'Multiclip_Control_Mutex');
end;

begin
	InitProc := @CheckMutex;
	Application.Initialize;
	Application.Title := 'Multiclip';
	Application.CreateForm(TMainForm, MainForm);
	Application.CreateForm(TAboutBox, AboutBox);
	Application.ShowMainForm := False;
	MainForm.LoadFromIni;
	MainForm.LoadCommands;
	MainForm.Restore(True);
	MainForm.Visible := True;
	MainForm.ctiTrayIcon.HideTaskbarIcon;
	Application.Run;
	ReleaseMutex(hMutex);
end.