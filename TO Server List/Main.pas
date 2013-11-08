unit Main;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, OleCtrls, ShockwaveFlashObjects_TLB, StdCtrls;

type
	TMainForm = class(TForm)
		swfBanner: TShockwaveFlash;
		sttRegInfo: TStaticText;
		btnCreateKey: TButton;
		procedure FormCreate(Sender: TObject);
		procedure btnCreateKeyClick(Sender: TObject);
	private
		FAppPath: string;
		function XorCoding(const Data, Key: string): string;
	public
		function IsReg: Boolean;
		property AppPath: string read FAppPath write FAppPath;
	end;

var
	MainForm: TMainForm;

implementation

uses Math;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
	AppPath := ExtractFilePath(Application.ExeName);
	with sttRegInfo do if IsReg then begin
		Font.Color := clGreen;
	end else begin
		Font.Color := clRed;
		Caption := 'Программа не зарегистрирована!';
	end;
end;

function TMainForm.IsReg: Boolean;
var
	RegFile: TextFile;
	ProgramName, User, Company: string;
begin
	Result := False;
	if FileExists(AppPath + 'Test.key') then begin
		AssignFile(RegFile, AppPath + 'Test.key');
		Reset(RegFile);
		ReadLn(RegFile, ProgramName);
		ReadLn(RegFile, User);
		ReadLn(RegFile, Company);
		CloseFile(RegFile);
		if XorCoding(ProgramName, 'BlaiddDrwg') = 'TO Server List' then begin
			Result := True;
			sttRegInfo.Caption := 'Программа зарегистрирована на ' + XorCoding(User, 'BlaiddDrwg') + ' из ' + XorCoding(Company, 'BlaiddDrwg');
			sttRegInfo.Hint := sttRegInfo.Caption;
			ShowMessage(XorCoding(ProgramName, 'BlaiddDrwg'));
			ShowMessage(XorCoding(User, 'BlaiddDrwg'));
			ShowMessage(XorCoding(Company, 'BlaiddDrwg'));
		end;
	end;
end;

procedure TMainForm.btnCreateKeyClick(Sender: TObject);
const
	ProgramName = 'TO Server List';
	User = 'Megadragon';
	Company = 'Phoenix Lab';
	Password = 'BlaiddDrwg';
var
	KeyFile: TextFile;
begin
	AssignFile(KeyFile, AppPath + 'Test.key');
	Rewrite(KeyFile);
	WriteLn(KeyFile, XorCoding(ProgramName, Password));
	WriteLn(KeyFile, XorCoding(User, Password));
	WriteLn(KeyFile, XorCoding(Company, Password));
	CloseFile(KeyFile);
end;

function TMainForm.XorCoding(const Data, Key: string): string;
var
	I, Len: Word;
	CryptKey: string;
begin
	Len := Length(Data);
	CryptKey := '';
	repeat
		CryptKey := CryptKey + Key;
	until Length(CryptKey) >= Len;
	CryptKey := Copy(CryptKey, 1, Len);
	SetLength(Result, Len);
	for I := 1 to Len do Result[I] := Chr(Ord(Data[I]) xor Ord(CryptKey[I]));
end;

end.
