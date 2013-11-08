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
			StatusBar.SimpleText := '���������� ������� ���� �Autorun.inf�. ��������, �� ����� ������ �����������.';
			Exit;
		end;
	end;
	if not DirectoryExists(AppDrive + 'Autorun.inf') then begin
		CreateDir(AppDrive + 'Autorun.inf');
		CreateDir('\\?\' + AppDrive + 'Autorun.inf\WormSlayer.\');
		SetFileAttributes(PChar(AppDrive + 'Autorun.inf'), FILE_ATTRIBUTE_READONLY or FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_SYSTEM);
		StatusBar.SimpleText := '����������� ����� �Autorun.inf� �������.';
	end;
end;

procedure TMainForm.bbnWSDClick(Sender: TObject);
begin
	SetFileAttributes(PChar(AppDrive + 'Autorun.inf'), 0);
	if RemoveDir('\\?\' + AppDrive + 'Autorun.inf\WormSlayer.\') and RemoveDir(AppDrive + 'Autorun.inf')
	then StatusBar.SimpleText := '����� �Autorun.inf� �������.'
	else StatusBar.SimpleText := '���������� ������� ����� �Autorun.inf�. ��������, ��� �����������, ��� ������ ������ �����������.';
end;

procedure TMainForm.bbnARCClick(Sender: TObject);
var
	Recycler: TextFile;
begin
	if FileExists(AppDrive + 'RECYCLER') then
		StatusBar.SimpleText := '���� �RECYCLER� ��� ����������. ��� ���������� ��������� ��� ��������.'
	else if DirectoryExists(AppDrive + 'RECYCLER') then begin
		SetFileAttributes(PChar(AppDrive + 'RECYCLER'), 0);
		RemoveDir(AppDrive + 'RECYCLER');
		AssignFile(Recycler, AppDrive + 'RECYCLER');
		ReWrite(Recycler);
		WriteLn(Recycler, '# ���� ���� ������ ���������� WormSlayer � ����� ������ �� �������, ���������');
		WriteLn(Recycler, '# ���� ����� � ����� �RECYCLER� ��� ������������ ���������������. �� � ����');
		WriteLn(Recycler, '# ������ �� �������� ���� ����, ����� �� �������� ������� ���� �����������');
		WriteLn(Recycler, '# ������ (�.�. ��, ������� �� ��������� ������������� ����� � ������');
		WriteLn(Recycler, '# �RECYCLER�). ������ �� ������� ������� ���� �� ����������, ������ ���� ����');
		WriteLn(Recycler, '# ����� ������������ ��� �������������� �� ���.');
		CloseFile(Recycler);
		SetFileAttributes(PChar(AppDrive + 'RECYCLER'), FILE_ATTRIBUTE_READONLY or FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_SYSTEM);
		StatusBar.SimpleText := '�������� ����� �RECYCLER� ������� ���������.';
	end;
end;

procedure TMainForm.bbnARDClick(Sender: TObject);
begin
	SetFileAttributes(PChar(AppDrive + 'RECYCLER'), 0);
	if DeleteFile(AppDrive + 'RECYCLER') then StatusBar.SimpleText := '���� �RECYCLER� ������� �����.'
	else StatusBar.SimpleText := '���������� ������� ���� �RECYCLER�. ��������, �� �����������, ��� ����� ������ �����������.';
end;

end.
