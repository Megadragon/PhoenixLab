program Settings;

uses
	Forms,
	Main in 'Main.pas' {frmSettings};

{$R *.res}

begin
	Application.Initialize;
	Application.Title := '�������� �������� Multiclip';
	Application.CreateForm(TfrmSettings, frmSettings);
	Application.Run;
end.
