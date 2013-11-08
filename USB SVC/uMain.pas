unit uMain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, XPMan, Grids, ValEdit, ExtCtrls;

type
	TMainForm = class(TForm)
		vleVirusCleanLog: TValueListEditor;
		tmrScanner: TTimer;
		xpmManifest: TXPManifest;
		procedure FormCreate(Sender: TObject);
		procedure tmrScannerTimer(Sender: TObject);
	private
		FAppPath: string;
	public
		procedure ScanDrive(ADriveLabel: Char);
		property AppPath: string read FAppPath write FAppPath;
	end;

var
	MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
	AppPath := ExtractFilePath(Application.ExeName);
end;

procedure TMainForm.tmrScannerTimer(Sender: TObject);
var
	Drive: Char;
begin
	for Drive := 'A' to 'Z' do
		if GetDriveType(PChar(Drive + ':\')) = 2 then begin
			tmrScanner.Enabled := False;
			ScanDrive(Drive);
		end;
end;

procedure TMainForm.ScanDrive(ADriveLabel: Char);
var
	Root: string[3];
	Search: TSearchRec;
	Result: string;
begin
	Root := ADriveLabel + ':\';
	ShowMessage('In ScanDrive for ' + ADriveLabel);
	if FindFirst(Root + '*.ini?', faAnyFile, Search) = 0 then repeat
		if not Focused then SetFocus;
		SetFileAttributes(PChar(Search.Name), 0);
		if DeleteFile(Root + Search.Name) then Result := 'Удалён' else Result := 'Ошибка удаления';
		vleVirusCleanLog.InsertRow(Search.Name, Result, True);
	until FindNext(Search) <> 0;
	if FindFirst(Root + '*.lnk', faAnyFile, Search) = 0 then repeat
		if not Focused then SetFocus;
		SetFileAttributes(PChar(Search.Name), 0);
		if DeleteFile(Root + Search.Name) then Result := 'Удалён' else Result := 'Ошибка удаления';
		vleVirusCleanLog.InsertRow(Search.Name, Result, True);
	until FindNext(Search) <> 0;
end;

end.
