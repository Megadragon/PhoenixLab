program USB_Autorun_Menu;

uses
	Forms,
	uMainForm in 'uMainForm.pas' {MainForm};

{$R *.res}

begin
	Application.Initialize;
	Application.Title := 'USB Autorun Menu';
	Application.CreateForm(TMainForm, MainForm);
	Application.Run;
end.
