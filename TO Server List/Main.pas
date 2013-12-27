unit Main;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, OleCtrls, ShockwaveFlashObjects_TLB, StdCtrls, ExtCtrls;

type
	TMainForm = class(TForm)
		swfBanner: TShockwaveFlash;
		Panel: TPanel;
		gpbClient: TGroupBox;
		cbbBrowser: TComboBox;
		ckbFlashPlayer: TCheckBox;
		rdgServers: TRadioGroup;
		shpRun: TShape;
		shpClose: TShape;
		procedure FormCreate(Sender: TObject);
		procedure ckbFlashPlayerClick(Sender: TObject);
		procedure shpRunMouseUp(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
		procedure shpCloseMouseUp(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
	private
		FAppPath: string;
		FFlashPlayer: string;
	public
		BrowsersList: array of string;
		procedure ScanBrowsers;
		property AppPath: string read FAppPath write FAppPath;
		property FlashPlayer: string read FFlashPlayer write FFlashPlayer;
	end;

var
	MainForm: TMainForm;

implementation

uses Registry, ShellAPI;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
	AppPath := ExtractFilePath(Application.ExeName);
	ScanBrowsers;
end;

procedure TMainForm.ckbFlashPlayerClick(Sender: TObject);
begin
	cbbBrowser.Enabled := not ckbFlashPlayer.Checked;
end;

procedure TMainForm.ScanBrowsers;
const
	SHELL_OPEN_COMMAND = 'shell\open\command';
	START_MENU_INTERNET = 'SOFTWARE\Clients\StartMenuInternet';
var
	Reg: TRegistry;
	Info: TRegKeyInfo;
	List: TStringList;
	I: Byte;
begin
	Reg := TRegistry.Create;
	with Reg do try
		List := TStringList.Create;
		try
			RootKey := HKEY_LOCAL_MACHINE;
			if OpenKey(START_MENU_INTERNET, False) and GetKeyInfo(Info) then begin
				SetLength(BrowsersList, Info.NumSubKeys);
				GetKeyNames(List);
				CloseKey;
				for I := 0 to Length(BrowsersList) - 1 do
					if OpenKey(START_MENU_INTERNET + '\' + List[I], False) then begin
						cbbBrowser.Items.Add(ReadString(''));
						CloseKey;
						if OpenKey(START_MENU_INTERNET + '\' + List[I] + '\' + SHELL_OPEN_COMMAND, False) then begin
							BrowsersList[I] := ReadString('');
							CloseKey;
						end;
						if cbbBrowser.Items[I] = '' then cbbBrowser.Items[I] := BrowsersList[I];
					end;
			end;
		finally
			List.Free;
		end;
	finally
		Free;
	end;
end;

procedure TMainForm.shpRunMouseUp(Sender: TObject; Button: TMouseButton;
	Shift: TShiftState; X, Y: Integer);
var
	App, Param: string;
begin
	if rdgServers.ItemIndex < 0 then raise Exception.Create('Сервер не выбран!');
	if ckbFlashPlayer.Checked then begin
		App := AppPath + 'FlashPlayer.exe';
		Param := 'http://tankionline.com/AlternativaLoader.swf?config=c'
			+ IntToStr(rdgServers.ItemIndex)
			+ '.tankionline.com/config.xml&resources=s.tankionline.com&lang=ru&locale=ru&friend=d0068ec30';
	end else if cbbBrowser.ItemIndex < 0 then raise Exception.Create('Браузер не выбран!')
	else begin
		App := BrowsersList[cbbBrowser.ItemIndex];
		Param := 'http://tankionline.com/battle-ru'
			+ IntToStr(rdgServers.ItemIndex) + '.html#friend=d0068ec30';
	end;
	ShellExecute(0, 'Open', PChar(App), PChar(Param), '', SW_SHOWMAXIMIZED);
	Close;
end;

procedure TMainForm.shpCloseMouseUp(Sender: TObject; Button: TMouseButton;
	Shift: TShiftState; X, Y: Integer);
begin
	Close;
end;

end.
