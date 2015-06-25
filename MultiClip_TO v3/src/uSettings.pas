unit uSettings;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, IniFiles, StdCtrls, ExtCtrls, Buttons, Spin, ComCtrls;

type
	TfrmSettings = class(TForm)
		pgcTabs: TPageControl;
		tbsForm: TTabSheet;
		lblWidthMin: TLabel;
		lblAlpha: TLabel;
		lblDelay: TLabel;
		lblWndPos: TLabel;
		speWidthMin: TSpinEdit;
		speAlpha: TSpinEdit;
		speDelay: TSpinEdit;
		cbbWndPos: TComboBox;
		lblTargetWnd: TLabel;
		cbbTargetWnd: TComboBox;
		tbsList: TTabSheet;
		lblFontSz: TLabel;
		lblHKFontSz: TLabel;
		speFontSz: TSpinEdit;
		speHKFontSz: TSpinEdit;
		bvlSeparator: TBevel;
		lblList: TLabel;
		lblSelected: TLabel;
		lblText: TLabel;
		lblHotkey: TLabel;
		lblSeparator: TLabel;
		crbList: TColorBox;
		crbSelected: TColorBox;
		crbText: TColorBox;
		crbHotkey: TColorBox;
		crbSeparator: TColorBox;
		bbnOK: TBitBtn;
		bbnCancel: TBitBtn;
		procedure FormCreate(Sender: TObject);
		procedure ColorBoxSelect(Sender: TObject);
		procedure bbnOKClick(Sender: TObject);
		procedure bbnCancelClick(Sender: TObject);
	private
		function GetApplicationPath: string;
	end;

var
	frmSettings: TfrmSettings;

implementation

const
	sSettingsFileName = 'Multiclip.ini';

{$R *.dfm}

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
	with TIniFile.Create(GetApplicationPath + sSettingsFileName) do try
		speWidthMin.Value := ReadInteger('Settings', 'WidthMin', speWidthMin.Value);
		speAlpha.Value := ReadInteger('Settings', 'AlphaBlendValue', speAlpha.Value);
		speDelay.Value := ReadInteger('Settings', 'DelayBeforeMinimize', speDelay.Value);
		cbbWndPos.Text := ReadString('Settings', 'WindowPosition', cbbWndPos.Text);
		cbbTargetWnd.Text := ReadString('Settings', 'TargetWindowName', cbbTargetWnd.Text);
		speFontSz.Value := ReadInteger('Settings', 'FontSize', speFontSz.Value);
		speHKFontSz.Value := ReadInteger('Settings', 'HKFontSize', speHKFontSz.Value);
		crbList.Selected := StringToColor(ReadString('Colors', 'List', ColorToString(crbList.Selected)));
		crbSelected.Selected := StringToColor(ReadString('Colors', 'Selected', ColorToString(crbSelected.Selected)));
		crbText.Selected := StringToColor(ReadString('Colors', 'Text', ColorToString(crbText.Selected)));
		crbHotkey.Selected := StringToColor(ReadString('Colors', 'Hotkey', ColorToString(crbHotkey.Selected)));
		crbSeparator.Selected := StringToColor(ReadString('Colors', 'Separator', ColorToString(crbSeparator.Selected)));
	finally
		Free;
	end;
end;

procedure TfrmSettings.ColorBoxSelect(Sender: TObject);
begin
	if Sender is TColorBox then with (Sender as TColorBox) do
		if Selected = clRed then Selected := DefaultColorColor;
end;

procedure TfrmSettings.bbnCancelClick(Sender: TObject);
begin
	Close;
end;

procedure TfrmSettings.bbnOKClick(Sender: TObject);
begin
	with TIniFile.Create(GetApplicationPath + sSettingsFileName) do try
		WriteInteger('Settings', 'WidthMin', speWidthMin.Value);
		WriteInteger('Settings', 'AlphaBlendValue', speAlpha.Value);
		WriteInteger('Settings', 'DelayBeforeMinimize', speDelay.Value);
		WriteString('Settings', 'WindowPosition', cbbWndPos.Text);
		WriteString('Settings', 'TargetWindowName', cbbTargetWnd.Text);
		WriteInteger('Settings', 'FontSize', speFontSz.Value);
		WriteInteger('Settings', 'HKFontSize', speHKFontSz.Value);
		WriteString('Colors', 'List', ColorToString(crbList.Selected));
		WriteString('Colors', 'Selected', ColorToString(crbSelected.Selected));
		WriteString('Colors', 'Text', ColorToString(crbText.Selected));
		WriteString('Colors', 'Hotkey', ColorToString(crbHotkey.Selected));
		WriteString('Colors', 'Separator', ColorToString(crbSeparator.Selected));
	finally
		Free;
	end;
	Close;
end;

function TfrmSettings.GetApplicationPath: string;
begin
	Result := ExtractFilePath(Application.ExeName);
end;

end.

