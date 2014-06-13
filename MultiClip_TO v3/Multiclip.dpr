program Multiclip;

uses
	Forms, Windows,
	uMain in 'uMain.pas' {MainForm},
	uAbout in 'uAbout.pas' {AboutBox},
	uCommandList in 'uCommandList.pas';

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
	ShowWindow(Application.Handle, SW_HIDE);
	Application.Run;
	ReleaseMutex(hMutex);
end.