unit Main;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, IniFiles, StdCtrls, ExtCtrls, Buttons, Spin;

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
		procedure FormCreate(Sender: TObject);
		procedure bbnOKClick(Sender: TObject);
		procedure bbnCancelClick(Sender: TObject);
	end;

var
	frmSettings: TfrmSettings;

implementation

{$R *.dfm}
{$R WindowsXP.res}

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
	with TIniFile.Create(GetCurrentDir + '\Multiclip.ini') do try
		speWidthMin.Value := ReadInteger('Settings', 'WidthMin', 50);
		speAlphaBlend.Value := ReadInteger('Settings', 'AlphaBlendValue', 160);
		speDelay.Value := ReadInteger('Settings', 'DelayBeforeMinimize', 1000);
		speFontSz.Value := ReadInteger('Settings', 'FontSize', 30);
		speHKFontSz.Value := ReadInteger('Settings', 'HKFontSize', 15);
		cbbHKPos.Text := ReadString('Settings', 'HKPosition', 'Right');
		cbbWndPos.Text := ReadString('Settings', 'WindowPosition', 'Right');
		lbeTargetWnd.Text := ReadString('Settings', 'TargetWindowName', '');
	finally
		Free;
	end;
end;

procedure TfrmSettings.bbnOKClick(Sender: TObject);
begin
	with TIniFile.Create(GetCurrentDir + '\Multiclip.ini') do try
		WriteInteger('Settings', 'WidthMin', speWidthMin.Value);
		WriteInteger('Settings', 'DelayBeforeMinimize', speDelay.Value);
		WriteInteger('Settings', 'AlphaBlendValue', speAlphaBlend.Value);
		WriteInteger('Settings', 'FontSize', speFontSz.Value);
		WriteInteger('Settings', 'HKFontSize', speHKFontSz.Value);
		WriteString('Settings', 'HKPosition', cbbHKPos.Text);
		WriteString('Settings', 'WindowPosition', cbbWndPos.Text);
		WriteString('Settings', 'TargetWindowName', lbeTargetWnd.Text);
	finally
		Free;
	end;
	Close;
end;

procedure TfrmSettings.bbnCancelClick(Sender: TObject);
begin
	Close;
end;

end.
