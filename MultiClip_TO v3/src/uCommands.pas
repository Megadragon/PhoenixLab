unit uCommands;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, Menus;

type
	TfrmCommands = class(TForm)
		ltvCommandList: TListView;
		gpbCommand: TGroupBox;
		chbDelay: TCheckBox;
		lbeText: TLabeledEdit;
		lblTeamHotkey: TLabel;
		htkHotkey: THotKey;
		btnAddCommand: TButton;
		bvlControl: TBevel;
		btnSeparator: TButton;
		btnDelete: TButton;
		bbnOK: TBitBtn;
		bbnCancel: TBitBtn;
		procedure FormCreate(Sender: TObject);
		procedure bbnOKClick(Sender: TObject);
		procedure bbnCancelClick(Sender: TObject);
		procedure btnAddCommandClick(Sender: TObject);
		procedure btnSeparatorClick(Sender: TObject);
		procedure btnDeleteClick(Sender: TObject);
	private
		function GetApplicationPath: string;
		procedure LoadFromFile(const Filename: string);
		procedure SaveToFile(const Filename: string);
	end;

var
	frmCommands: TfrmCommands;

implementation

const
	sAddDoubleSeparator = 'Двойной разделитель не имеет смысла.';
	sAddEmptyString = 'Добавление пустой команды не имеет смысла.';
	sAddSeparatorToBeginning = 'Разделитель в начале списка не имеет смысла.';
	sCommandFileName = 'command.lst';
	sFileNotFound = 'Файл списка команд command.lst не найден.';
	sProgramName = 'Редактор быстрых команд';

{$R *.dfm}

procedure TfrmCommands.FormCreate(Sender: TObject);
begin
	if FileExists(GetApplicationPath + sCommandFileName) then
		LoadFromFile(GetApplicationPath + sCommandFileName)
	else begin
		MessageBox(Handle, sFileNotFound, sProgramName, MB_OK or MB_ICONSTOP or MB_SYSTEMMODAL);
		Application.Terminate;
	end;
end;

procedure TfrmCommands.bbnOKClick(Sender: TObject);
begin
	SaveToFile(GetApplicationPath + sCommandFileName);
	Close;
end;

procedure TfrmCommands.bbnCancelClick(Sender: TObject);
begin
	Close;
end;

procedure TfrmCommands.btnAddCommandClick(Sender: TObject);
begin
	if lbeText.Text = '' then
		MessageBox(Handle, sAddEmptyString, sProgramName, MB_OK or MB_ICONWARNING)
	else with ltvCommandList.Items.Insert(ltvCommandList.ItemIndex) do begin
		Caption := lbeText.Text;
		Checked := chbDelay.Checked;
		SubItems.Add(ShortCutToText(htkHotkey.HotKey));
	end;
	chbDelay.Checked := False;
	lbeText.Text := '';
	htkHotkey.HotKey := TextToShortCut('');
end;

procedure TfrmCommands.btnSeparatorClick(Sender: TObject);
begin
	if ltvCommandList.ItemIndex > 0 then
		if ltvCommandList.Selected.Caption = '' then
			MessageBox(Handle, sAddDoubleSeparator, sProgramName, MB_OK or MB_ICONWARNING)
		else ltvCommandList.Items.Insert(ltvCommandList.ItemIndex).Caption := ''
	else MessageBox(Handle, sAddSeparatorToBeginning, sProgramName, MB_OK or MB_ICONWARNING);
end;

procedure TfrmCommands.btnDeleteClick(Sender: TObject);
begin
	ltvCommandList.DeleteSelected;
end;

function TfrmCommands.GetApplicationPath: string;
begin
	Result := ExtractFilePath(Application.ExeName);
end;

procedure TfrmCommands.LoadFromFile(const Filename: string);
var
	CmdFile: TextFile;
	Buffer: string;
	TabPos: Byte;
begin
	AssignFile(CmdFile, Filename);
	Reset(CmdFile);
	while not Eof(CmdFile) do begin
		ReadLn(CmdFile, Buffer);
		if Buffer = '' then ltvCommandList.Items.Add.Caption := '' else
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

procedure TfrmCommands.SaveToFile(const Filename: string);
var
	CmdFile: TextFile;
	I: Byte;
begin
	AssignFile(CmdFile, Filename);
	Rewrite(CmdFile);
	for I := 0 to ltvCommandList.Items.Count - 1 do
		if ltvCommandList.Items[I].Caption = '' then WriteLn(CmdFile)
		else with ltvCommandList.Items[I] do begin
			if Checked then Write(CmdFile, '%');
			Write(CmdFile, Caption);
			if SubItems.Count > 0 then Write(CmdFile, #9, SubItems[0]);
			if I + 1 < ltvCommandList.Items.Count then WriteLn(CmdFile);
		end;
	CloseFile(CmdFile);
end;

end.

