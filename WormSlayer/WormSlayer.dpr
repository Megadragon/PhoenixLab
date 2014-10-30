program WormSlayer;

uses
	Forms, Windows, SysUtils,
	uMain in 'uMain.pas' {MainForm},
	uAbout in 'uAbout.pas' {AboutBox},
	uSplash in 'uSplash.pas' {SplashScreen};

{$R *.res}

begin
	with TSplashScreen.Create(Application) do try
		Show;
		Update;
		with pgbLoadStatus do
			if GetDriveType(PChar(Copy(GetCurrentDir, 1, 3))) <> 2 then
				MessageBox(0, '������ ��������� WormSlayer �� �� ������� �������� ������������ ������!', 'WormSlayer', MB_ICONSTOP)
			else begin
				StepBy(Step);
				Application.Title := 'WormSlayer � ����������� ������';
				StepBy(Step);
				Application.CreateForm(TMainForm, MainForm);
				StepBy(Step);
				Application.CreateForm(TAboutBox, AboutBox);
				StepBy(Step);
			end;
	finally
		Free;
		Application.Run;
	end;
end.
