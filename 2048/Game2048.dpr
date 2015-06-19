program Game2048;

uses
	Forms,
	uMain in 'src\uMain.pas' {frmMain},
	uStats in 'src\uStats.pas' {frmStats},
	uAbout in 'src\uAbout.pas' {AboutBox},
	uParams in 'src\uParams.pas' {dlgParams},
	uSkins in 'src\uSkins.pas' {dlgSkins},
	uGame in 'src\uGame.pas';

{$R *.res}

begin
	Randomize;
	Application.Initialize;
	Application.Title := '2048 для Windows';
	Application.CreateForm(TfrmMain, frmMain);
	Application.CreateForm(TfrmStats, frmStats);
	Application.CreateForm(TAboutBox, AboutBox);
	Application.CreateForm(TdlgParams, dlgParams);
	Application.CreateForm(TdlgSkins, dlgSkins);
	Application.Run;
end.
