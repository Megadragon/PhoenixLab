program WormSlayer;

uses
	Forms,
	Windows,
	SysUtils,
	uMain in 'src\uMain.pas' {frmMain},
	uAbout in 'src\uAbout.pas' {AboutBox},
	uSplash in 'src\uSplash.pas' {SplashScreen},
	uDefenceUnit in 'src\uDefenceUnit.pas',
	uWormSlayer in 'src\uWormSlayer.pas',
	uAntiRecycler in 'src\uAntiRecycler.pas';

{$R *.res}

begin
	with TSplashScreen.Create(Application) do try
		Show;
		Update;
		with pgbLoadStatus do begin
			Application.Title := 'WormSlayer Ч »стребитель червей';
			StepBy(Step);
			Application.CreateForm(TfrmMain, frmMain);
			StepBy(Step);
			Application.CreateForm(TAboutBox, AboutBox);
			StepBy(Step);
		end;
	finally
		Free;
		Application.Run;
	end;
end.

