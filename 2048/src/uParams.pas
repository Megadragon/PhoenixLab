unit uParams;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
	Buttons, ExtCtrls, Spin;

type
	TdlgParams = class(TForm)
		bbnOK: TBitBtn;
		bbnCancel: TBitBtn;
		rdgMode: TRadioGroup;
		lblSize: TLabel;
		speSize: TSpinEdit;
		lblTarget: TLabel;
		cbbTarget: TComboBox;
		ckbLoadOnStart: TCheckBox;
		ckbSaveOnExit: TCheckBox;
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
	end;

var
	dlgParams: TdlgParams;

implementation

uses uMain;

{$R *.dfm}

procedure TdlgParams.FormCreate(Sender: TObject);
begin
	rdgMode.ItemIndex := idxMode;
	speSize.Value := Size;
	cbbTarget.ItemIndex := cbbTarget.Items.IndexOf(IntToStr(Target));
	ckbLoadOnStart.Checked := IsLoadOnStart;
	ckbSaveOnExit.Checked := IsSaveOnExit;
end;

procedure TdlgParams.FormShow(Sender: TObject);
begin
	rdgMode.Tag := rdgMode.ItemIndex;
	speSize.Tag := speSize.Value;
	cbbTarget.Tag := cbbTarget.ItemIndex;
	with ckbLoadOnStart do if Checked then Tag := 1 else Tag := 0;
	with ckbSaveOnExit do if Checked then Tag := 1 else Tag := 0;
end;

procedure TdlgParams.FormCloseQuery(Sender: TObject;
	var CanClose: Boolean);
begin
	if ModalResult <> mrOk then begin
		rdgMode.ItemIndex := rdgMode.Tag;
		speSize.Value := speSize.Tag;
		cbbTarget.ItemIndex := cbbTarget.Tag;
		ckbLoadOnStart.Checked := ckbLoadOnStart.Tag = 1;
		ckbSaveOnExit.Checked := ckbSaveOnExit.Tag = 1;
	end;
end;

end.
