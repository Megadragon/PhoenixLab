program XO;

uses
	Forms,
	uMain in 'uMain.pas' {frmMain},
	uOKRightDlg in 'uOKRightDlg.pas' {OKRightDlg},
	uXO in 'uXO.pas';

{$R *.res}

begin
	Application.Initialize;
	Application.Title := '��������-������';
	Application.CreateForm(TfrmMain, frmMain);
	Application.CreateForm(TOKRightDlg, OKRightDlg);
	Application.ShowMainForm := False;
	OKRightDlg.ShowModal;
	Application.Run;
end.