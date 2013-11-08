unit uOKRightDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
	ExtCtrls, XPMan;

type
	TOKRightDlg = class(TForm)
		OKBtn: TButton;
		CancelBtn: TButton;
		rdgMode: TRadioGroup;
		rdgPlayer: TRadioGroup;
		XPManifest: TXPManifest;
		procedure rdgModeClick(Sender: TObject);
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
	end;

var
	OKRightDlg: TOKRightDlg;

implementation

uses uMain, uXO;

{$R *.dfm}

procedure TOKRightDlg.rdgModeClick(Sender: TObject);
begin
	case rdgMode.ItemIndex of
		0: begin
			rdgPlayer.Items.Clear;
			rdgPlayer.Items.Add('Игрок №1');
			rdgPlayer.Items.Add('Игрок №2');
		end;
		1: begin
			rdgPlayer.Items.Clear;
			rdgPlayer.Items.Add('Игрок');
			rdgPlayer.Items.Add('Компьютер');
		end;
		2: begin
			rdgPlayer.Items.Clear;
			rdgPlayer.Items.Add('Компьютер №1');
			rdgPlayer.Items.Add('Компьютер №2');
		end;
	end;
end;

procedure TOKRightDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
	if OKRightDlg.ModalResult = mrOk then begin
		Mode := rdgMode.ItemIndex + 1;
		Player := rdgPlayer.ItemIndex + 1;
		frmMain.Timer.Enabled := Mode > 1;
		frmMain.Show;
		CanClose := True;
	end else frmMain.Close;
end;

end.
