unit uMain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, ComCtrls, StdCtrls, Menus, Buttons;

type
	TMainForm = class(TForm)
		mmuMenuBar: TMainMenu;
		MenuFile: TMenuItem;
		MFileRestore: TMenuItem;
		MFileSeparator: TMenuItem;
		MFileExit: TMenuItem;
		MenuHelp: TMenuItem;
		MHelpAbout: TMenuItem;
		gpbWormSlayer: TGroupBox;
		lblWormSlayer: TLabel;
		btnWSCreate: TButton;
		btnWSDelete: TButton;
		gpbAntiRecycler: TGroupBox;
		lblAntiRecycler: TLabel;
		btnARCreate: TButton;
		btnARDelete: TButton;
		btnRestore: TButton;
		bbnAbout: TBitBtn;
		bbnClose: TBitBtn;
		StatusBar: TStatusBar;
		procedure FormCreate(Sender: TObject);
		procedure MFileRestoreClick(Sender: TObject);
		procedure MFileExitClick(Sender: TObject);
		procedure MHelpAboutClick(Sender: TObject);
		procedure btnWSCreateClick(Sender: TObject);
		procedure btnWSDeleteClick(Sender: TObject);
		procedure btnARCreateClick(Sender: TObject);
		procedure btnARDeleteClick(Sender: TObject);
	public
		TargetFlashDrive: string;
	end;

var
	MainForm: TMainForm;

implementation

uses uAbout;

const TARGET_FILE_ATTRIBUTES = FILE_ATTRIBUTE_READONLY or FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_SYSTEM;

{$R *.dfm}
{$R WindowsXP.res}

procedure TMainForm.FormCreate(Sender: TObject);
begin
	TargetFlashDrive := Copy(GetCurrentDir, 1, 3);
end;

procedure TMainForm.MFileRestoreClick(Sender: TObject);
begin
	if DirectoryExists(TargetFlashDrive + 'Autorun.inf') then
		SetFileAttributes(PChar(TargetFlashDrive + 'Autorun.inf'), FILE_ATTRIBUTE_DIRECTORY or TARGET_FILE_ATTRIBUTES);
	if FileExists(TargetFlashDrive + 'RECYCLER') then
		SetFileAttributes(PChar(TargetFlashDrive + 'RECYCLER'), TARGET_FILE_ATTRIBUTES);
end;

procedure TMainForm.MFileExitClick(Sender: TObject);
begin
	Close;
end;

procedure TMainForm.MHelpAboutClick(Sender: TObject);
begin
	AboutBox.ShowModal;
end;

procedure TMainForm.btnWSCreateClick(Sender: TObject);
begin
	if FileExists(TargetFlashDrive + 'Autorun.inf') then begin
		SetFileAttributes(PChar(TargetFlashDrive + 'Autorun.inf'), 0);
		if not DeleteFile(TargetFlashDrive + 'Autorun.inf') then begin
			StatusBar.SimpleText := 'Невозможно удалить файл «Autorun.inf». Возможно, он занят другим приложением.';
			Exit;
		end;
	end;
	if not DirectoryExists(TargetFlashDrive + 'Autorun.inf') then begin
		CreateDir(TargetFlashDrive + 'Autorun.inf');
		CreateDir('\\?\' + TargetFlashDrive + 'Autorun.inf\WormSlayer.\');
		SetFileAttributes(PChar(TargetFlashDrive + 'Autorun.inf'), FILE_ATTRIBUTE_DIRECTORY or TARGET_FILE_ATTRIBUTES);
		StatusBar.SimpleText := 'Неудаляемая папка «Autorun.inf» создана.';
	end;
end;

procedure TMainForm.btnWSDeleteClick(Sender: TObject);
begin
	SetFileAttributes(PChar(TargetFlashDrive + 'Autorun.inf'), FILE_ATTRIBUTE_DIRECTORY);
	if RemoveDir('\\?\' + TargetFlashDrive + 'Autorun.inf\WormSlayer.\') and RemoveDir(TargetFlashDrive + 'Autorun.inf')
	then StatusBar.SimpleText := 'Папка «Autorun.inf» удалена.'
	else StatusBar.SimpleText := 'Невозможно удалить папку «Autorun.inf». Возможно, она отсутствует, или занята другим приложением.';
end;

procedure TMainForm.btnARCreateClick(Sender: TObject);
var
	hRecycler: Integer;
begin
	if FileExists(TargetFlashDrive + 'RECYCLER') then
		StatusBar.SimpleText := 'Файл «RECYCLER» уже существует. Нет надобности создавать его повторно.'
	else begin
		if DirectoryExists(TargetFlashDrive + 'RECYCLER') then begin
			SetFileAttributes(PChar(TargetFlashDrive + 'RECYCLER'), FILE_ATTRIBUTE_DIRECTORY);
			RemoveDir(TargetFlashDrive + 'RECYCLER');
		end;
		hRecycler := FileCreate(TargetFlashDrive + 'RECYCLER');
		FileWrite(hRecycler, '# Этот файл создан программой WormSlayer в целях защиты от вирусов, создающих'#13#10, 79);
		FileWrite(hRecycler, '# свои копии в папке «RECYCLER» для последующего распространения. Ни в коем'#13#10, 77);
		FileWrite(hRecycler, '# случае не удаляйте этот файл, иначе вы рискуете поймать даже «устаревшие»'#13#10, 77);
		FileWrite(hRecycler, '# вирусы (т.е. те, которые не проверяют существование файла с именем'#13#10, 70);
		FileWrite(hRecycler, '# «RECYCLER»). Защиты от «новых» вирусов пока не существует, однако этот файл'#13#10, 79);
		FileWrite(hRecycler, '# можно использовать как предохранитель от них.'#13#10, 49);
		FileClose(hRecycler);
		SetFileAttributes(PChar(TargetFlashDrive + 'RECYCLER'), TARGET_FILE_ATTRIBUTES);
		StatusBar.SimpleText := 'Создание файла «RECYCLER» успешно завершено.';
	end;
end;

procedure TMainForm.btnARDeleteClick(Sender: TObject);
begin
	SetFileAttributes(PChar(TargetFlashDrive + 'RECYCLER'), 0);
	if DeleteFile(TargetFlashDrive + 'RECYCLER') then StatusBar.SimpleText := 'Файл «RECYCLER» успешно удалён.'
	else StatusBar.SimpleText := 'Невозможно удалить файл «RECYCLER». Возможно, он отсутствует, или занят другим приложением.';
end;

end.
