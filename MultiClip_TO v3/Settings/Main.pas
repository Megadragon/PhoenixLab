unit Main;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, IniFiles, StdCtrls, ExtCtrls, Buttons, Spin, XPMan;

type
	TfrmSettings = class(TForm)
		bvlBorder: TBevel;
		lblWidthMin: TLabel;
		lblDelay: TLabel;
		lblAlphaBlend: TLabel;
		lblFontSz: TLabel;
		lblHKFontSz: TLabel;
		lblHKPos: TLabel;
		lblWndPos: TLabel;
		speWidthMin: TSpinEdit;
		speDelay: TSpinEdit;
		speAlphaBlend: TSpinEdit;
		speFontSz: TSpinEdit;
		speHKFontSz: TSpinEdit;
		cbbHKPos: TComboBox;
		cbbWndPos: TComboBox;
		lbeTargetWnd: TLabeledEdit;
		bbnOK: TBitBtn;
		bbnCancel: TBitBtn;
		XPM: TXPManifest;
		procedure FormCreate(Sender: TObject);
		procedure bbnOKClick(Sender: TObject);
		procedure bbnCancelClick(Sender: TObject);
	private
		FAppPath: string;
	public
		flConfig: TIniFile;
		property AppPath: string read FAppPath write FAppPath;
	end;

var
	frmSettings: TfrmSettings;

implementation

{$R *.dfm}

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
	AppPath := ExtractFilePath(Application.ExeName);
	flConfig := TIniFile.Create(AppPath + 'config.cfg');
	with flConfig do begin
		speWidthMin.Value := ReadInteger('Settings', 'WidthMin', 50);
		speAlphaBlend.Value := ReadInteger('Settings', 'AlphaBlendValue', 160);
		speDelay.Value := ReadInteger('Settings', 'DelayBeforeMinimize', 1000);
		speFontSz.Value := ReadInteger('Settings', 'FontSize', 30);
		speHKFontSz.Value := ReadInteger('Settings', 'HKFontSize', 15);
		cbbHKPos.Text := ReadString('Settings', 'HKPosition', 'Right');
		cbbWndPos.Text := ReadString('Settings', 'WindowPosition', 'Right');
		lbeTargetWnd.Text := ReadString('Settings', 'TargetWindowName', '');
	end;
end;

procedure TfrmSettings.bbnOKClick(Sender: TObject);
begin
	with flConfig do begin
		WriteInteger('Settings', 'WidthMin', speWidthMin.Value);
		WriteInteger('Settings', 'DelayBeforeMinimize', speDelay.Value);
		WriteInteger('Settings', 'AlphaBlendValue', speAlphaBlend.Value);
		WriteInteger('Settings', 'FontSize', speFontSz.Value);
		WriteInteger('Settings', 'HKFontSize', speHKFontSz.Value);
		WriteString('Settings', 'HKPosition', cbbHKPos.Text);
		WriteString('Settings', 'WindowPosition', cbbWndPos.Text);
		WriteString('Settings', 'TargetWindowName', lbeTargetWnd.Text);
		Free;
	end;
	Close;
end;

procedure TfrmSettings.bbnCancelClick(Sender: TObject);
begin
	Close;
end;

end.
