unit Main;

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
		lblGlobalHotkey: TLabel;
		htkTeam: THotKey;
		htkGlobal: THotKey;
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
	public
		procedure LoadFromFile(const Filename: string);
		procedure SaveToFile(const Filename: string);
	end;

var
	frmCommands: TfrmCommands;

implementation

{$R *.dfm}
{$R WindowsXP.res}

procedure TfrmCommands.FormCreate(Sender: TObject);
begin
	if FileExists(GetCurrentDir + '\command.lst') then
		LoadFromFile(GetCurrentDir + '\command.lst')
	else begin
		MessageBox(Handle, 'Файл списка команд command.lst не найден.', 'Редактор быстрых команд', MB_OK or MB_ICONSTOP);
		Application.Terminate;
	end;
end;

procedure TfrmCommands.bbnOKClick(Sender: TObject);
begin
	SaveToFile(GetCurrentDir + '\command.lst');
	Close;
end;

procedure TfrmCommands.bbnCancelClick(Sender: TObject);
begin
	Close;
end;

procedure TfrmCommands.btnAddCommandClick(Sender: TObject);
begin
	if lbeText.Text = '' then begin
		MessageBox(Handle, 'Добавление пустой команды не имеет смысла.', 'Редактор быстрых команд', MB_OK or MB_ICONWARNING);
		Exit;
	end else with ltvCommandList.Items.Insert(ltvCommandList.ItemIndex) do begin
		Caption := lbeText.Text;
		Checked := chbDelay.Checked;
		SubItems.Add(ShortCutToText(htkTeam.HotKey));
		SubItems.Add(ShortCutToText(htkGlobal.HotKey));
	end;
	chbDelay.Checked := False;
	lbeText.Text := '';
	htkTeam.HotKey := TextToShortCut('');
	htkGlobal.HotKey := TextToShortCut('');
end;

procedure TfrmCommands.btnSeparatorClick(Sender: TObject);
begin
	if ltvCommandList.ItemIndex > 0 then
		if (ltvCommandList.Selected.Caption = '')
		then MessageBox(Handle, 'Двойной разделитель не имеет смысла.', 'Редактор быстрых команд', MB_OK or MB_ICONWARNING)
		else ltvCommandList.Items.Insert(ltvCommandList.ItemIndex).Caption := ''
	else MessageBox(Handle, 'Разделитель в начале списка не имеет смысла.', 'Редактор быстрых команд', MB_OK or MB_ICONWARNING);
end;

procedure TfrmCommands.btnDeleteClick(Sender: TObject);
begin
	ltvCommandList.DeleteSelected;
end;

procedure TfrmCommands.LoadFromFile(const Filename: string);
var
	CmdFile: TextFile;
	Buffer, Text: string;
	TabPos: Byte;
begin
	AssignFile(CmdFile, Filename);
	Reset(CmdFile);
	while not Eof(CmdFile) do begin
		ReadLn(CmdFile, Buffer);
		if Buffer = '' then ltvCommandList.Items.Add.Caption := '' else
			with ltvCommandList.Items.Add do begin
				TabPos := Pos(#9, Buffer);
				if TabPos > 0 then begin
					Text := Copy(Buffer, 1, TabPos - 1);
					Checked := Text[1] = '%';
					if Checked then System.Delete(Text, 1, 1);
					Caption := Text;
					System.Delete(Buffer, 1, TabPos);
					TabPos := Pos(#9, Buffer);
					if TabPos > 0 then begin
						SubItems.Add(Copy(Buffer, 1, TabPos - 1));
						System.Delete(Buffer, 1, TabPos);
					end;
					SubItems.Add(Buffer);
				end else Caption := Buffer;
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
			if SubItems.Count > 1 then Write(CmdFile, #9, SubItems[1]);
			if I + 1 < ltvCommandList.Items.Count then WriteLn(CmdFile);
		end;
	CloseFile(CmdFile);
end;

end.
