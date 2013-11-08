program TO_Server_List;

uses
	Forms,
	Main in 'Main.pas' {MainForm};

{$R *.res}

begin
	Application.Initialize;
	Application.Title := 'TO Server List';
	Application.CreateForm(TMainForm, MainForm);
	Application.Run;
end.
