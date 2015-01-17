unit uMain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, OleCtrls, ShockwaveFlashObjects_TLB, StdCtrls, ExtCtrls;

type
	TfrmMain = class(TForm)
		swfBanner: TShockwaveFlash;
		gpbParams: TGroupBox;
		lblBrowser: TLabel;
		cbbBrowser: TComboBox;
		shpRun: TShape;
		shpClose: TShape;
		lblLanguage: TLabel;
		cbbLanguage: TComboBox;
		lblLocale: TLabel;
		cbbLocale: TComboBox;
		lblServer: TLabel;
		cbbServer: TComboBox;
		procedure FormCreate(Sender: TObject);
		procedure shpRunMouseUp(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
		procedure shpCloseMouseUp(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
		procedure cbbLocaleChange(Sender: TObject);
	public
		BrowsersList: array of string;
		procedure ScanBrowsers;
	end;

var
	frmMain: TfrmMain;

implementation

uses Registry, ShellAPI;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
	ScanBrowsers;
end;

procedure TfrmMain.ScanBrowsers;
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

procedure TfrmMain.shpRunMouseUp(Sender: TObject; Button: TMouseButton;
	Shift: TShiftState; X, Y: Integer);
var
	App, Param, Lang, Locale: string;
begin
	if cbbBrowser.ItemIndex >= 0 then App := BrowsersList[cbbBrowser.ItemIndex]
	else raise EListError.Create('Браузер не выбран!');
	case cbbLanguage.ItemIndex of
		0: Lang := 'ru';
		1: Lang := 'en';
		2: Lang := 'de';
		else raise EListError.Create('Язык не выбран!');
	end;
	case cbbLocale.ItemIndex of
		0: Locale := 'RU';
		1: Locale := 'EN';
		2: Locale := 'DE';
		else raise EListError.Create('Локаль не выбрана!');
	end;
	Param := 'http://tankionline.com/battle-' + Lang + '.html#/server='
		+ Locale + IntToStr(cbbServer.ItemIndex + 1);
	ShellExecute(0, 'open', PChar(App), PChar(Param), '', SW_SHOWMAXIMIZED);
	Close;
end;

procedure TfrmMain.shpCloseMouseUp(Sender: TObject; Button: TMouseButton;
	Shift: TShiftState; X, Y: Integer);
begin
	Close;
end;

procedure TfrmMain.cbbLocaleChange(Sender: TObject);
var
	I: Byte;
begin
	with cbbServer.Items do begin
		BeginUpdate;
		try
			Clear;
			case cbbLocale.ItemIndex of
				0: for I := 1 to 39 do Add('Сервер №' + IntToStr(I));
				1: for I := 1 to 13 do Add('Сервер №' + IntToStr(I));
				2: for I := 1 to 2 do Add('Сервер №' + IntToStr(I));
			end;
		finally
			EndUpdate;
		end;
	end;
end;

end.