program Commands;

uses
	Forms,
	Main in 'Main.pas' {frmCommands};

{$R *.res}

begin
	Application.Initialize;
	Application.Title := '�������� ������� ������';
	Application.CreateForm(TfrmCommands, frmCommands);
	Application.Run;
end.
