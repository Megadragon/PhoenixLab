program Settings;

uses
	Forms,
	Main in 'Main.pas' {frmSettings};

{$R *.res}

begin
	Application.Initialize;
	Application.Title := 'Редактор настроек Multiclip';
	Application.CreateForm(TfrmSettings, frmSettings);
	Application.Run;
end.
