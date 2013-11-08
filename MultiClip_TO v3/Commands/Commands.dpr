program Commands;

uses
	Forms,
	Main in 'Main.pas' {frmCommands};

{$R *.res}

begin
	Application.Initialize;
	Application.Title := 'Редактор быстрых команд';
	Application.CreateForm(TfrmCommands, frmCommands);
	Application.Run;
end.
