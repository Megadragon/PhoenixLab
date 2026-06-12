unit uCommands;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, Menus;

type
	TfrmCommands = class(TForm)
		gpbHeader: TGroupBox;
		lbeTargetWindowName: TLabeledEdit;
		spbChooseTargetWindow: TSpeedButton;
		lblOpenKey: TLabel;
		lblSendKey: TLabel;
		lblAltOpenKey: TLabel;
		lblAltSendKey: TLabel;
		htkOpenKey: THotKey;
		htkSendKey: THotKey;
		htkAltSendKey: THotKey;
		htkAltOpenKey: THotKey;
		ltvCommandList: TListView;
		gpbCommand: TGroupBox;
		chbDelay: TCheckBox;
		lbeText: TLabeledEdit;
		lblHotkey: TLabel;
		htkHotkey: THotKey;
		lblAltHotKey: TLabel;
		htkAltHotKey: THotKey;
		btnAddCommand: TButton;
		btnSeparator: TButton;
		btnDelete: TButton;
		bbnOK: TBitBtn;
		bbnCancel: TBitBtn;
		procedure btnAddCommandClick(Sender: TObject);
		procedure btnSeparatorClick(Sender: TObject);
		procedure btnDeleteClick(Sender: TObject);
		procedure spbChooseTargetWindowClick(Sender: TObject);
	private
		procedure LoadFromFile(const AFileName: string);
		procedure SaveToFile(const AFileName: string);
	end;

var
	frmCommands: TfrmCommands;

implementation

const
	sAddDoubleSeparator = 'Двойной разделитель не имеет смысла.';
	sAddEmptyString = 'Добавление пустой команды не имеет смысла.';
	sAddSeparatorToBeginning = 'Разделитель в начале списка не имеет смысла.';
	sFileNotFound = 'Файл списка команд command.lst не найден.';

{$R *.dfm}

procedure TfrmCommands.btnAddCommandClick(Sender: TObject);
begin
	if lbeText.Text = EmptyStr then
		Application.MessageBox(sAddEmptyString, PChar(Application.Title), MB_OK or MB_ICONERROR)
	else with ltvCommandList.Items.Insert(ltvCommandList.ItemIndex) do begin
		Caption := lbeText.Text;
		Checked := chbDelay.Checked;
		SubItems.Add(ShortCutToText(htkHotkey.HotKey));
		SubItems.Add(ShortCutToText(htkAltHotKey.HotKey));
	end;
	chbDelay.Checked := False;
	lbeText.Text := EmptyStr;
	htkHotkey.HotKey := TextToShortCut(EmptyStr);
	htkAltHotKey.HotKey := TextToShortCut(EmptyStr);
end;

procedure TfrmCommands.btnSeparatorClick(Sender: TObject);
begin
	if ltvCommandList.ItemIndex > 0 then
		if ltvCommandList.Selected.Caption = EmptyStr then
			Application.MessageBox(sAddDoubleSeparator, PChar(Application.Title), MB_OK or MB_ICONERROR)
		else ltvCommandList.Items.Insert(ltvCommandList.ItemIndex).Caption := EmptyStr
	else Application.MessageBox(sAddSeparatorToBeginning, PChar(Application.Title), MB_OK or MB_ICONERROR);
end;

procedure TfrmCommands.btnDeleteClick(Sender: TObject);
begin
	ltvCommandList.DeleteSelected;
end;

procedure TfrmCommands.LoadFromFile(const AFileName: string);
var
	CmdFile: TextFile;
	Buffer: string;
	TabPos: Byte;
begin
	AssignFile(CmdFile, AFileName);
	Reset(CmdFile);
	while not Eof(CmdFile) do begin
		ReadLn(CmdFile, Buffer);
		if Buffer = EmptyStr then ltvCommandList.Items.Add.Caption := EmptyStr else
			with ltvCommandList.Items.Add do begin
				TabPos := Pos(#9, Buffer);
				if TabPos = 0 then Caption := Buffer else begin
					Caption := Copy(Buffer, 1, TabPos - 1);
					System.Delete(Buffer, 1, TabPos);
					if TextToShortCut(Buffer) > 0 then SubItems.Add(Buffer);
				end;
				Checked := Caption[1] = '%';
				if Checked then Caption := Copy(Caption, 2, 255);
			end;
	end;
	CloseFile(CmdFile);
end;

procedure TfrmCommands.SaveToFile(const AFileName: string);
var
	CmdFile: TextFile;
	I: Byte;
begin
	AssignFile(CmdFile, AFileName);
	Rewrite(CmdFile);
	for I := 0 to ltvCommandList.Items.Count - 1 do
		if ltvCommandList.Items[I].Caption = EmptyStr then WriteLn(CmdFile)
		else with ltvCommandList.Items[I] do begin
			if Checked then Write(CmdFile, '%');
			Write(CmdFile, Caption);
			if SubItems.Count > 0 then Write(CmdFile, #9, SubItems[0]);
			if I + 1 < ltvCommandList.Items.Count then WriteLn(CmdFile);
		end;
	CloseFile(CmdFile);
end;

procedure TfrmCommands.spbChooseTargetWindowClick(Sender: TObject);
begin
	{ TODO Catch target window }
end;

end.

