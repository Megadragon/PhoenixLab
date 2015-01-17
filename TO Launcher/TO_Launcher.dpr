program TO_Launcher;

uses
	Forms,
	uMain in 'uMain.pas' {frmMain};

{$R *.res}

begin
	Application.Initialize;
	Application.Title := 'TO Launcher';
	Application.CreateForm(TfrmMain, frmMain);
	Application.Run;
end.
