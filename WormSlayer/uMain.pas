unit uMain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, ComCtrls, StdCtrls, Menus, Buttons, PngBitBtn, XPMan, uAbout;

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
		bbnWSC: TPngBitBtn;
		bbnWSD: TPngBitBtn;
		gpbAntiRecycler: TGroupBox;
		lblAntiRecycler: TLabel;
		bbnARC: TPngBitBtn;
		bbnARD: TPngBitBtn;
		bbnRestore: TPngBitBtn;
		bbnAbout: TPngBitBtn;
		bbnExit: TPngBitBtn;
		StatusBar: TStatusBar;
		XPM: TXPManifest;
		procedure FormCreate(Sender: TObject);
		procedure MFileRestoreClick(Sender: TObject);
		procedure MFileExitClick(Sender: TObject);
		procedure MHelpAboutClick(Sender: TObject);
		procedure bbnWSCClick(Sender: TObject);
		procedure bbnWSDClick(Sender: TObject);
		procedure bbnARCClick(Sender: TObject);
		procedure bbnARDClick(Sender: TObject);
	private
		FAppDrive: string;
		FAppPath: string;
	public
		property AppDrive: string read FAppDrive write FAppDrive;
		property AppPath: string read FAppPath write FAppPath;
	end;

var
	MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
	AppPath := ExtractFilePath(Application.ExeName);
	AppDrive := Copy(AppPath, 1, 3);
end;

procedure TMainForm.MFileRestoreClick(Sender: TObject);
begin
	if DirectoryExists(AppDrive + 'Autorun.inf') then
		SetFileAttributes('Autorun.inf', FILE_ATTRIBUTE_READONLY or FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_SYSTEM);
	if FileExists(AppDrive + 'RECYCLER') then
		SetFileAttributes('RECYCLER', FILE_ATTRIBUTE_READONLY or FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_SYSTEM);
end;

procedure TMainForm.MFileExitClick(Sender: TObject);
begin
	Close;
end;

procedure TMainForm.MHelpAboutClick(Sender: TObject);
begin
	AboutBox.ShowModal;
end;

procedure TMainForm.bbnWSCClick(Sender: TObject);
begin
	if FileExists(AppDrive + 'Autorun.inf') then begin
		SetFileAttributes(PChar(AppDrive + 'Autorun.inf'), 0);
		if not DeleteFile(AppDrive + 'Autorun.inf') then begin
			StatusBar.SimpleText := 'Невозможно удалить файл «Autorun.inf». Возможно, он занят другим приложением.';
			Exit;
		end;
	end;
	if not DirectoryExists(AppDrive + 'Autorun.inf') then begin
		CreateDir(AppDrive + 'Autorun.inf');
		CreateDir('\\?\' + AppDrive + 'Autorun.inf\WormSlayer.\');
		SetFileAttributes(PChar(AppDrive + 'Autorun.inf'), FILE_ATTRIBUTE_READONLY or FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_SYSTEM);
		StatusBar.SimpleText := 'Неудаляемая папка «Autorun.inf» создана.';
	end;
end;

procedure TMainForm.bbnWSDClick(Sender: TObject);
begin
	SetFileAttributes(PChar(AppDrive + 'Autorun.inf'), 0);
	if RemoveDir('\\?\' + AppDrive + 'Autorun.inf\WormSlayer.\') and RemoveDir(AppDrive + 'Autorun.inf')
	then StatusBar.SimpleText := 'Папка «Autorun.inf» удалена.'
	else StatusBar.SimpleText := 'Невозможно удалить папку «Autorun.inf». Возможно, она отсутствует, или занята другим приложением.';
end;

procedure TMainForm.bbnARCClick(Sender: TObject);
var
	Recycler: TextFile;
begin
	if FileExists(AppDrive + 'RECYCLER') then
		StatusBar.SimpleText := 'Файл «RECYCLER» уже существует. Нет надобности создавать его повторно.'
	else if DirectoryExists(AppDrive + 'RECYCLER') then begin
		SetFileAttributes(PChar(AppDrive + 'RECYCLER'), 0);
		RemoveDir(AppDrive + 'RECYCLER');
		AssignFile(Recycler, AppDrive + 'RECYCLER');
		ReWrite(Recycler);
		WriteLn(Recycler, '# Этот файл создан программой WormSlayer в целях защиты от вирусов, создающих');
		WriteLn(Recycler, '# свои копии в папке «RECYCLER» для последующего распространения. Ни в коем');
		WriteLn(Recycler, '# случае не удаляйте этот файл, иначе вы рискуете поймать даже «устаревшие»');
		WriteLn(Recycler, '# вирусы (т.е. те, которые не проверяют существование файла с именем');
		WriteLn(Recycler, '# «RECYCLER»). Защиты от «новых» вирусов пока не существует, однако этот файл');
		WriteLn(Recycler, '# можно использовать как предохранитель от них.');
		CloseFile(Recycler);
		SetFileAttributes(PChar(AppDrive + 'RECYCLER'), FILE_ATTRIBUTE_READONLY or FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_SYSTEM);
		StatusBar.SimpleText := 'Создание файла «RECYCLER» успешно завершено.';
	end;
end;

procedure TMainForm.bbnARDClick(Sender: TObject);
begin
	SetFileAttributes(PChar(AppDrive + 'RECYCLER'), 0);
	if DeleteFile(AppDrive + 'RECYCLER') then StatusBar.SimpleText := 'Файл «RECYCLER» успешно удалён.'
	else StatusBar.SimpleText := 'Невозможно удалить файл «RECYCLER». Возможно, он отсутствует, или занят другим приложением.';
end;

end.
