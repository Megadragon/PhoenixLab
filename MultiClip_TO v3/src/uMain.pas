unit uMain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, ExtCtrls, AppEvnts, Menus;

type
	TMainForm = class(TForm)
		mmnMenuBar: TMainMenu;
		mniFile: TMenuItem;
		mniFileOpen: TMenuItem;
		mniFileSaveAs: TMenuItem;
		mniFileSeparator: TMenuItem;
		mniFileExit: TMenuItem;
		mniTools: TMenuItem;
		mniToolsOnOff: TMenuItem;
		mniToolsCommands: TMenuItem;
		mniToolsSettings: TMenuItem;
		mniHelp: TMenuItem;
		mniHelpAbout: TMenuItem;
		lsbCommands: TListBox;
		apeEvents: TApplicationEvents;
		tmrMouseLeave: TTimer;
		tmrTargetWndActivate: TTimer;
		ondCommandList: TOpenDialog;
		svdCommandList: TSaveDialog;
		procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
			var Resize: Boolean);
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
		procedure FormCreate(Sender: TObject);
		procedure FormResize(Sender: TObject);
		procedure lsbCommandsClick(Sender: TObject);
		procedure lsbCommandsContextPopup(Sender: TObject; MousePos: TPoint;
			var Handled: Boolean);
		procedure lsbCommandsDrawItem(Control: TWinControl; Index: Integer;
			Rect: TRect; State: TOwnerDrawState);
		procedure lsbCommandsMeasureItem(Control: TWinControl; Index: Integer;
			var Height: Integer);
		procedure lsbCommandsMouseMove(Sender: TObject; Shift: TShiftState;
			X, Y: Integer);
		procedure apeEventsMinimize(Sender: TObject);
		procedure apeEventsRestore(Sender: TObject);
		procedure tmrMouseLeaveTimer(Sender: TObject);
		procedure tmrTargetWndActivateTimer(Sender: TObject);
		procedure mniFileOpenClick(Sender: TObject);
		procedure mniFileSaveAsClick(Sender: TObject);
		procedure mniFileExitClick(Sender: TObject);
		procedure mniToolsOnOffClick(Sender: TObject);
		procedure mniToolsCommandsClick(Sender: TObject);
		procedure mniToolsSettingsClick(Sender: TObject);
		procedure mniHelpAboutClick(Sender: TObject);
	public
		procedure LoadCommands;
		procedure LoadFromIni;
		procedure Restore;
		procedure SaveToIni;
		procedure SendCommand(const Index: Byte; const AMouseButton: TMouseButton);
		procedure Shrink;
		procedure WndProc(var Msg: TMessage); override;
	end;

var
	MainForm: TMainForm;

implementation

uses Clipbrd, IniFiles, uAbout, uCommandList, uCommands, uSettings;

const
	sCommandFileName = 'command.lst';

var
	WidthMin, WidthMax: Word;
	IsHidden, IsChangeForm: Boolean;
	CommandFontSize, HotKeyFontSize: Byte;

	clList, clSelected, clText, clSeparator, clHotKey, clAltHotKey: TColor;

	hActiveWindow: THandle;
	CommandList, WindowPosition, HotKeyPosition: string;

{$R *.dfm}

procedure TMainForm.FormCanResize(Sender: TObject;
	var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
	if not IsChangeForm then begin
		if IsHidden then NewWidth := Width else begin
			WidthMax := NewWidth;
			if WindowPosition = 'Left' then Left := 0 else
				if WindowPosition = 'Right' then Left := Screen.WorkAreaWidth - WidthMax;
		end;
		NewHeight := Height;
	end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
	SaveToIni;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
	ondCommandList.InitialDir := GetCurrentDir;
	svdCommandList.InitialDir := GetCurrentDir;
	LoadFromIni;
	LoadCommands;
	Restore;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
	lsbCommands.Refresh;
end;

procedure TMainForm.lsbCommandsClick(Sender: TObject);
begin
	with lsbCommands do if Items[ItemIndex] > EmptyStr then begin
		SendCommand(ItemIndex, mbLeft);
		if not IsHidden then Shrink;
	end;
end;

procedure TMainForm.lsbCommandsContextPopup(Sender: TObject;
	MousePos: TPoint; var Handled: Boolean);
begin
	with lsbCommands do if Items[ItemAtPos(MousePos, True)] > EmptyStr then begin
		SendCommand(ItemAtPos(MousePos, True), mbRight);
		Handled := True;
	end;
end;

procedure TMainForm.lsbCommandsDrawItem(Control: TWinControl; Index: Integer;
	Rect: TRect; State: TOwnerDrawState);
const
	Gap = 2;
var
	HotKeyWidth: Integer;
begin
	with lsbCommands.Canvas do if lsbCommands.Items[Index] = EmptyStr then begin
		State := [odDisabled];
		Brush.Color := clSeparator;
		FillRect(Rect);
	end else begin
		if Index = lsbCommands.ItemIndex then begin
			State := [odSelected];
			Brush.Color := clSelected;
		end else begin
			State := [odDefault];
			Brush.Color := clList;
		end;
		FillRect(Rect);
		Font.Height := CommandFontSize;
		Font.Color := clText;
		TextOut(Rect.Left + Gap, Rect.Top, Commands[Index].Text);
		Font.Height := HotKeyFontSize;
		if Commands[Index].HotKey.IsRegister then Font.Color := clHotKey else Font.Color := clRed;
		HotKeyWidth := TextWidth(Commands[Index].HotKey.AsString);
		if HotKeyPosition = 'Down' then TextOut(Rect.Left + Gap, Rect.Bottom - Font.Height, Commands[Index].HotKey.AsString)
		else TextOut(Rect.Right - HotKeyWidth - 2, Rect.Top, Commands[Index].HotKey.AsString);
		if Commands[Index].AltHotKey.IsRegister then Font.Color := clAltHotKey else Font.Color := clRed;
		HotKeyWidth := TextWidth(Commands[Index].AltHotKey.AsString);
		TextOut(Rect.Right - HotKeyWidth - 2, Rect.Top, Commands[Index].AltHotKey.AsString);
	end;
end;

procedure TMainForm.lsbCommandsMeasureItem(Control: TWinControl; Index: Integer;
	var Height: Integer);
begin
	if lsbCommands.Items[Index] = EmptyStr then Height := 2 else
		if HotkeyPosition = 'Down' then Height := CommandFontSize + HotKeyFontSize else Height := CommandFontSize;
end;

procedure TMainForm.lsbCommandsMouseMove(Sender: TObject; Shift: TShiftState;
	X, Y: Integer);
begin
	tmrMouseLeave.Enabled := False;
	if IsHidden then Restore;
	with lsbCommands do begin
		ItemIndex := ItemAtPos(Point(X, Y), True);
		if (Tag >= 0) and (Tag <> ItemIndex) then
			lsbCommandsDrawItem(lsbCommands, Tag, ItemRect(Tag), [odDefault]);
		Tag := ItemIndex;
	end;
	tmrMouseLeave.Enabled := True;
end;

procedure TMainForm.apeEventsMinimize(Sender: TObject);
begin
	Commands.UnregisterHotKeys;
	ShowWindow(Application.Handle, SW_SHOW);
end;

procedure TMainForm.apeEventsRestore(Sender: TObject);
begin
	Commands.RegisterHotKeys;
	ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TMainForm.tmrMouseLeaveTimer(Sender: TObject);
begin
	if not PtInRect(BoundsRect, Mouse.CursorPos) then Shrink;
end;

procedure TMainForm.tmrTargetWndActivateTimer(Sender: TObject);
var
	H: THandle;
begin
	H := GetForegroundWindow;
	if H <> Handle then hActiveWindow := H;
	if (Tag >= 0) and (GetKeyState(VK_SHIFT) + GetKeyState(VK_CONTROL) + GetKeyState(VK_MENU) >= 0)
	then SendCommand(Tag, mbMiddle);
end;

{ Public procedures }

procedure TMainForm.LoadCommands;
var
	I: Shortint;
begin
	lsbCommands.Items.BeginUpdate;
	for I := 0 to Commands.Count - 1 do lsbCommands.Items.Add(Commands[I].Text);
	lsbCommands.Items.EndUpdate;
	ClientHeight := lsbCommands.ItemRect(lsbCommands.Count - 1).Bottom;
	if Height > Screen.WorkAreaHeight then Height := Screen.WorkAreaHeight;
end;

procedure TMainForm.LoadFromIni;
begin
	with TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini')) do try
		Left := ReadInteger('Settings', 'Left', Left);
		Top := ReadInteger('Settings', 'Top', Top);
		WidthMin := ReadInteger('Settings', 'WidthMin', 132);
		WidthMax := ReadInteger('Settings', 'WidthMax', 300);
		if WidthMax < WidthMin then WidthMax := WidthMin;
		AlphaBlendValue := ReadInteger('Settings', 'AlphaBlendValue', 40);
		tmrMouseLeave.Interval := ReadInteger('Settings', 'DelayBeforeMinimize', 300);
		CommandFontSize := ReadInteger('Settings', 'FontSize', 30);
		HotkeyFontSize := ReadInteger('Settings', 'HKFontSize', 15);
		WindowPosition := ReadString('Settings', 'WindowPosition', 'Right');
		if (WindowPosition <> 'Left') and (WindowPosition <> 'Right') and (WindowPosition <> 'Manual') then WindowPosition := 'Right';
		HotkeyPosition := ReadString('Settings', 'HotkeyPosition', 'Down');
		if (HotkeyPosition <> 'Down') and (HotkeyPosition <> 'Right') then HotkeyPosition := 'Right';
		CommandList := ReadString('Settings', 'CommandList', EmptyStr);
		clList := StringToColor(ReadString('Colors', 'List', 'clWhite'));
		clSelected := StringToColor(ReadString('Colors', 'Selected', 'clLime'));
		clText := StringToColor(ReadString('Colors', 'Text', 'clBlack'));
		clHotkey := StringToColor(ReadString('Colors', 'Hotkey', 'clOlive'));
		clAltHotkey := StringToColor(ReadString('Colors', 'AltHotkey', 'clGreen'));
		clSeparator := StringToColor(ReadString('Colors', 'Separator', 'clBlack'));
	finally
		Free;
	end;
end;

procedure TMainForm.Restore;
begin
	if IsHidden then begin
		IsChangeForm := True;
		if WindowPosition <> 'Manual' then Width := WidthMax;
		if WindowPosition = 'Left' then Left := 0 else
			if WindowPosition = 'Right' then Left := Screen.Width - Width;
		AlphaBlend := False;
		IsChangeForm := False;
	end;
	IsHidden := False;
	tmrMouseLeave.Enabled := True;
end;

procedure TMainForm.SaveToIni;
begin
	with TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini')) do try
		WriteInteger('Settings', 'Left', Left);
		WriteInteger('Settings', 'Top', Top);
		WriteInteger('Settings', 'WidthMax', WidthMax);
		WriteString('Settings', 'WindowPosition', WindowPosition);
		WriteString('Settings', 'HotkeyPosition', HotkeyPosition);
	finally
		Free;
	end;
end;

procedure TMainForm.SendCommand(const Index: Byte; const AMouseButton: TMouseButton);
var
	IsWindowFound: Boolean;
	CurrentKeyboardLayout: HKL;

	procedure ClickKey(Key: Word);
	begin
		keybd_event(Key, 0, 0, 0);
		keybd_event(Key, 0, KEYEVENTF_KEYUP, 0);
	end;

begin
	CurrentKeyboardLayout := ActivateKeyboardLayout($0419, KLF_ACTIVATE);
	Clipboard.AsText := Commands[Index].Text;
	ActivateKeyboardLayout(CurrentKeyboardLayout, KLF_ACTIVATE);
	if Commands.Header[0] = EmptyStr then IsWindowFound := hActiveWindow > 0
	else IsWindowFound := hActiveWindow = FindWindow(nil, PChar(Commands.Header[0]));
	SetForegroundWindow(hActiveWindow);
	if IsWindowFound then begin
		ClickKey(VK_RETURN);
		Sleep(100);
		keybd_event(VK_CONTROL, 0, 0, 0); // Press Ctrl
		ClickKey(Ord('V'));
		keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0); // Release Ctrl
		Sleep(100);
		if not Commands[Index].IsDelay then ClickKey(VK_RETURN);
	end;
	Tag := -1;
end;

procedure TMainForm.Shrink;
begin
	tmrMouseLeave.Enabled := False;
	if not IsHidden then begin
		IsChangeForm := True;
		if WindowPosition <> 'Manual' then Width := WidthMin;
		if WindowPosition = 'Left' then Left := 0 else
			if WindowPosition = 'Right' then Left := Screen.Width - Width;
		AlphaBlend := True;
		IsHidden := True;
		IsChangeForm := False;
	end;
end;

procedure TMainForm.WndProc(var Msg: TMessage);
var
	I: Shortint;
begin
	case Msg.Msg of
		WM_ENTERSIZEMOVE: tmrMouseLeave.Enabled := False;
		WM_EXITSIZEMOVE: tmrMouseLeave.Enabled := True;
		WM_HOTKEY: for I := 0 to Commands.Count - 1 do
			if Msg.wParam = Commands[I].HotKey.Atom then Tag := I;
		WM_MOVE: if not IsChangeForm then begin
			IsChangeForm := True;
			if Left = 0 then WindowPosition := 'Left' else
				if Left + Width = Screen.WorkAreaWidth then WindowPosition := 'Right'
				else WindowPosition := 'Manual';
			IsChangeForm := False;
		end;
		WM_MOVING: begin
			if PRect(Msg.lParam)^.Left < Screen.WorkAreaLeft then
				OffsetRect(PRect(Msg.lParam)^, Screen.WorkAreaLeft - PRect(Msg.lParam)^.Left, 0);
			if PRect(Msg.lParam)^.Top < Screen.WorkAreaTop then
				OffsetRect(PRect(Msg.lParam)^, 0, Screen.WorkAreaTop - PRect(Msg.lParam)^.Top);
			if PRect(Msg.lParam)^.Right > Screen.WorkAreaRect.Right then
				OffsetRect(PRect(Msg.lParam)^, Screen.WorkAreaRect.Right - PRect(Msg.lParam)^.Right, 0);
			if PRect(Msg.lParam)^.Bottom > Screen.WorkAreaRect.Bottom then
				OffsetRect(PRect(Msg.lParam)^, 0, Screen.WorkAreaRect.Bottom - PRect(Msg.lParam)^.Bottom);
		end;
		else inherited;
	end;
end;

procedure TMainForm.mniFileOpenClick(Sender: TObject);
begin
	if ondCommandList.Execute then LoadCommands;
end;

procedure TMainForm.mniFileSaveAsClick(Sender: TObject);
begin
	if svdCommandList.Execute then ;
end;

procedure TMainForm.mniFileExitClick(Sender: TObject);
begin
	Close;
end;

procedure TMainForm.mniToolsOnOffClick(Sender: TObject);
begin
	with mniToolsOnOff do if Checked then Caption := 'Включить' else Caption := 'Выключить';
end;

procedure TMainForm.mniToolsCommandsClick(Sender: TObject);
begin
	frmCommands.ShowModal;
end;

procedure TMainForm.mniToolsSettingsClick(Sender: TObject);
begin
	frmSettings.ShowModal;
end;

procedure TMainForm.mniHelpAboutClick(Sender: TObject);
begin
	AboutBox.ShowModal;
end;

initialization

	IsHidden := True;
	IsChangeForm := True;

end.

