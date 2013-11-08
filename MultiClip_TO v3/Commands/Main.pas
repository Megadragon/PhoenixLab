unit Main;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, XPMan, Menus;

type
	TfrmCommands = class(TForm)
		mmoEditor: TMemo;
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
		XPM: TXPManifest;
		procedure FormCreate(Sender: TObject);
		procedure bbnOKClick(Sender: TObject);
		procedure bbnCancelClick(Sender: TObject);
		procedure btnAddCommandClick(Sender: TObject);
		procedure btnSeparatorClick(Sender: TObject);
		procedure btnDeleteClick(Sender: TObject);
	private
		FAppPath: string;
	public
		property AppPath: string read FAppPath write FAppPath;
	end;

var
	frmCommands: TfrmCommands;

implementation

{$R *.dfm}

procedure TfrmCommands.FormCreate(Sender: TObject);
begin
	AppPath := ExtractFilePath(Application.ExeName);
	if FileExists(AppPath + 'command.lst') then
		mmoEditor.Lines.LoadFromFile(AppPath + 'command.lst')
	else begin
		MessageBox(Handle, 'Файл списка команд command.lst не найден.', 'Редактор быстрых команд', MB_OK or MB_ICONWARNING);
		Application.Terminate;
	end;
end;

procedure TfrmCommands.bbnOKClick(Sender: TObject);
begin
	mmoEditor.Lines.SaveToFile(AppPath + 'command.lst');
	Close;
end;

procedure TfrmCommands.bbnCancelClick(Sender: TObject);
begin
	Close;
end;

procedure TfrmCommands.btnAddCommandClick(Sender: TObject);
var
	Buffer: string;
begin
	Buffer := '';
	if lbeText.Text = '' then begin
		MessageBox(Handle, 'Добавление пустой команды не имеет смысла.', 'Редактор быстрых команд', MB_OK or MB_ICONWARNING);
		Exit;
	end else begin
		if chbDelay.Checked then Buffer := '%';
		Buffer := Buffer + lbeText.Text + #9 + ShortCutToText(htkTeam.HotKey) + #9 + ShortCutToText(htkGlobal.HotKey);
		mmoEditor.Lines.Insert(mmoEditor.CaretPos.Y, Buffer);
	end;
	chbDelay.Checked := False;
	lbeText.Text := '';
	htkTeam.HotKey := TextToShortCut('');
	htkGlobal.HotKey := TextToShortCut('');
	mmoEditor.SetFocus;
end;

procedure TfrmCommands.btnSeparatorClick(Sender: TObject);
begin
	if mmoEditor.CaretPos.Y > 0 then
		if (mmoEditor.Lines[mmoEditor.CaretPos.Y] = '') or (mmoEditor.Lines[mmoEditor.CaretPos.Y - 1] = '')
		then MessageBox(Handle, 'Двойной разделитель не имеет смысла.', 'Редактор быстрых команд', MB_OK or MB_ICONWARNING)
		else mmoEditor.Lines.Insert(mmoEditor.CaretPos.Y, '')
	else MessageBox(Handle, 'Разделитель в начале списка не имеет смысла.', 'Редактор быстрых команд', MB_OK or MB_ICONWARNING);
	mmoEditor.SetFocus;
end;

procedure TfrmCommands.btnDeleteClick(Sender: TObject);
begin
	mmoEditor.Lines.Delete(mmoEditor.CaretPos.Y);
	mmoEditor.SetFocus;
end;

end.
