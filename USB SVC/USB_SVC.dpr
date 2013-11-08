program USB_SVC;

uses
  Forms,
  uMain in 'uMain.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'USB Selflink Virus Cleaner';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
