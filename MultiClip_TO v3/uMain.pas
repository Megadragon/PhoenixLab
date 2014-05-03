unit uMain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, IniFiles, Menus, ExtCtrls, Clipbrd, CoolTrayIcon, ImgList;

type
	TMainForm = class(TForm)
		ctiTrayIcon: TCoolTrayIcon;
		imlIcons: TImageList;
		lsbCommands: TListBox;
		popPopupMenu: TPopupMenu;
		POnOff: TMenuItem;
		PAbout: TMenuItem;
		PExit: TMenuItem;
		tmrMouseLeave: TTimer;
		tmrTargetWndActivate: TTimer;
		procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
			var Resize: Boolean);
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
		procedure FormCreate(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
		procedure FormResize(Sender: TObject);
		procedure lsbCommandsDrawItem(Control: TWinControl; Index: Integer;
			Rect: TRect; State: TOwnerDrawState);
		procedure lsbCommandsExit(Sender: TObject);
		procedure lsbCommandsMeasureItem(Control: TWinControl; Index: Integer;
			var Height: Integer);
		procedure lsbCommandsMouseDown(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
		procedure lsbCommandsMouseMove(Sender: TObject; Shift: TShiftState;
			X, Y: Integer);
		procedure lsbCommandsMouseUp(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
		procedure POnOffClick(Sender: TObject);
		procedure PAboutClick(Sender: TObject);
		procedure PExitClick(Sender: TObject);
		procedure tmrMouseLeaveTimer(Sender: TObject);
		procedure tmrTargetWndActivateTimer(Sender: TObject);
	private
		FAppPath: string;
		procedure WMEnterSizeMove(var Msg: TMessage); message WM_ENTERSIZEMOVE;
		procedure WMExitSizeMove(var Msg: TMessage); message WM_EXITSIZEMOVE;
		procedure WMHotkey(var Msg: TWMHotkey); message WM_HOTKEY;
		procedure WMMove(var Msg: TWMMove); message WM_MOVE;
	public
		procedure LoadCommands;
		procedure LoadFromIni;
		procedure Restore(const Forced: Boolean = False);
		procedure SaveToIni;
		procedure SendCommand(const Number: Byte; const IsTeamChat: Boolean);
		procedure Shrink;
		property AppPath: string read FAppPath;
	end;

var
	MainForm: TMainForm;

	WidthMin, WidthMax: Word;
	IsHidden, IsChangeForm: Boolean;
	FontSz, HKFontSz: Byte;

	clList, clSelected: TColor;
	clText, clSeparator: TColor;
	clHKTeam, clHKGlobal: TColor;

	hActiveWnd: THandle;
	IsTeamHotkey: Boolean;
	TargetWndName: string;
	WndPos, HKPos: string;
	IsAppWork: Boolean;

implementation

uses uAbout, uCommandList;

{$R *.dfm}
{$R WindowsXP.res}

procedure TMainForm.FormCanResize(Sender: TObject;
	var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
	if not IsChangeForm then begin
		if IsHidden then NewWidth := Width else begin
			WidthMax := NewWidth;
			if WndPos = 'Left' then Left := 0;
			if WndPos = 'Right' then Left := Screen.Width - WidthMax;
		end;
		NewHeight := Height;
		Resize := True;
	end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
	SaveToIni;
	CanClose := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
	FAppPath := GetCurrentDir;
	if IsAppWork then POnOff.Caption := 'Выключить'
	else POnOff.Caption := 'Включить';
	Commands := TCommandList.Create(AppPath + '\command.lst');
	LoadFromIni;
	LoadCommands;
	Restore(True);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
	Commands.Free;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
	lsbCommands.Repaint;
end;

procedure TMainForm.lsbCommandsDrawItem(Control: TWinControl; Index: Integer;
	Rect: TRect; State: TOwnerDrawState);
var
	hkWidth: Integer;
begin
	with lsbCommands.Canvas do if lsbCommands.Items[Index] = '' then begin
		Brush.Color := clSeparator;
		FillRect(Rect);
	end else begin
		if Index = lsbCommands.ItemIndex then Brush.Color := clSelected else Brush.Color := clList;
		Font.Height := FontSz;
		Font.Color := clText;
		FillRect(Rect);
		TextOut(Rect.Left + 2, Rect.Top, Commands.List[Index].Text);
		Font.Height := HKFontSz;
		if Commands.List[Index].hkTeam.IsRegister then Font.Color := clHKTeam else Font.Color := clRed;
		hkWidth := TextWidth(Commands.List[Index].hkTeam.AsString);
		if HKPos = 'Down' then TextOut(Rect.Left + 2, Rect.Bottom - HKFontSz, Commands.List[Index].hkTeam.AsString)
		else TextOut(Rect.Right - hkWidth - 2, Rect.Top, Commands.List[Index].hkTeam.AsString);
		if Commands.List[Index].hkGlobal.IsRegister then Font.Color := clHKGlobal else Font.Color := clRed;
		hkWidth := TextWidth(Commands.List[Index].hkGlobal.AsString);
		TextOut(Rect.Right - hkWidth - 2, Rect.Bottom - HKFontSz, Commands.List[Index].hkGlobal.AsString);
		Brush.Color := clWhite;
		Font.Color := clBlack;
	end;
end;

procedure TMainForm.lsbCommandsExit(Sender: TObject);
begin
	tmrMouseLeave.Enabled := True;
end;

procedure TMainForm.lsbCommandsMeasureItem(Control: TWinControl; Index: Integer;
	var Height: Integer);
begin
	if lsbCommands.Items[Index] = '' then Height := 2 else
		if (Pos(#9, lsbCommands.Items[Index]) > 0) and (HKPos = 'Down')
		then Height := FontSz + HKFontSz else Height := FontSz;
end;

procedure TMainForm.lsbCommandsMouseDown(Sender: TObject; Button: TMouseButton;
	Shift: TShiftState; X, Y: Integer);
var
	ItemNum: Integer;
begin
	ItemNum := lsbCommands.ItemAtPos(Point(X, Y), True);
	if lsbCommands.Items[ItemNum] > '' then SendCommand(ItemNum, Button = mbLeft);
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

procedure TMainForm.lsbCommandsMouseUp(Sender: TObject; Button: TMouseButton;
	Shift: TShiftState; X, Y: Integer);
begin
	if (lsbCommands.Items[lsbCommands.ItemIndex] > '') and not IsHidden then Shrink;
end;

procedure TMainForm.POnOffClick(Sender: TObject);
begin
	if IsAppWork then begin
		ctiTrayIcon.IconIndex := 0;
		ctiTrayIcon.HideMainForm;
		Commands.UnregHK;
		POnOff.Caption := 'Включить';
	end else begin
		ctiTrayIcon.IconIndex := 1;
		Commands.RegHK;
		ctiTrayIcon.ShowMainForm;
		POnOff.Caption := 'Выключить';
	end;
	IsAppWork := not IsAppWork;
end;

procedure TMainForm.PAboutClick(Sender: TObject);
begin
	AboutBox.ShowModal;
end;

procedure TMainForm.PExitClick(Sender: TObject);
begin
	Close;
end;

procedure TMainForm.tmrMouseLeaveTimer(Sender: TObject);
begin
	if (Mouse.CursorPos.X < Left) or (Mouse.CursorPos.Y < Top)
		or (Mouse.CursorPos.X > Left + Width) or (Mouse.CursorPos.Y > Top + Height)
	then Shrink;
end;

procedure TMainForm.tmrTargetWndActivateTimer(Sender: TObject);
var
	H: THandle;
begin
	H := GetForegroundWindow;
	if H <> Handle then hActiveWnd := H;
	if (Tag >= 0) and (Commands.List[Tag].Text > '')
		and (GetKeyState(VK_SHIFT) + GetKeyState(VK_CONTROL) + GetKeyState(VK_MENU) >= 0)
	then begin
		SendCommand(Tag, IsTeamHotkey);
		tmrTargetWndActivate.Interval := 1000;
		Tag := -1;
	end;
end;

{ Windows messages }

procedure TMainForm.WMEnterSizeMove(var Msg: TMessage);
begin
	tmrMouseLeave.Enabled := False;
end;

procedure TMainForm.WMExitSizeMove(var Msg: TMessage);
begin
	tmrMouseLeave.Enabled := True;
end;

procedure TMainForm.WMHotKey(var Msg: TWMHotKey);
var
	I: Byte;
begin
	inherited;
	tmrTargetWndActivate.Interval := 100;
	for I := 0 to Commands.Count - 1 do begin
		if Msg.HotKey = Commands.List[I].hkTeam.Atom then begin
			Tag := I;
			IsTeamHotkey := True;
			Break;
		end;
		if Msg.HotKey = Commands.List[I].hkGlobal.Atom then begin
			Tag := I;
			IsTeamHotkey := False;
			Break;
		end;
	end;
end;

procedure TMainForm.WMMove(var Msg: TWMMove);
begin
	if not IsChangeForm then begin
		IsChangeForm := True;
		if Left + Width > Screen.Width then Left := Screen.Width - Width;
		if Left < 0 then Left := 0;
		if Top + Height > Screen.Height then Top := Screen.Height - Height;
		if Top < 0 then Top := 0;
		if Left = 0 then WndPos := 'Left' else
			if Left + Width = Screen.Width then WndPos := 'Right' else
				WndPos := 'Manual';
		Repaint;
		IsChangeForm := False;
	end;
end;

{ Secondary procedures }

procedure TMainForm.LoadCommands;
var
	I: Word;
begin
	for I := 0 to Commands.Count - 1 do
		lsbCommands.Items.Add(Commands.List[I].Text);
	ClientHeight := lsbCommands.ItemRect(Commands.Count - 1).Bottom + 4;
	if Height > Screen.Height then Height := Screen.Height;
	ctiTrayIcon.IconIndex := 1;
end;

procedure TMainForm.LoadFromIni;
begin
	with TIniFile.Create(AppPath + '\config.cfg') do try
		Left := ReadInteger('Settings', 'Left', Left);
		Top := ReadInteger('Settings', 'Top', Top);
		WidthMin := ReadInteger('Settings', 'WidthMin', 35);
		WidthMax := ReadInteger('Settings', 'WidthMax', 300);
		if WidthMax < WidthMin then WidthMax := WidthMin;
		AlphaBlendValue := ReadInteger('Settings', 'AlphaBlendValue', 40);
		tmrMouseLeave.Interval := ReadInteger('Settings', 'DelayBeforeMinimize', 300);
		FontSz := ReadInteger('Settings', 'FontSize', 30);
		HKFontSz := ReadInteger('Settings', 'HKFontSize', 15);
		HKPos := ReadString('Settings', 'HKPosition', 'Down');
		if (HKPos <> 'Down') and (HKPos <> 'Right') then HKPos := 'Down';
		WndPos := ReadString('Settings', 'WindowPosition', 'Right');
		if (WndPos <> 'Left') and (WndPos <> 'Right') and (WndPos <> 'Manual') then WndPos := 'Right';
		TargetWndName := ReadString('Settings', 'TargetWindowName', '');
		clList := StringToColor(ReadString('Colors', 'List', 'clWhite'));
		clSelected := StringToColor(ReadString('Colors', 'Selected', 'clLime'));
		clText := StringToColor(ReadString('Colors', 'Text', 'clBlack'));
		clHKTeam := StringToColor(ReadString('Colors', 'HKTeam', 'clOlive'));
		clHKGlobal := StringToColor(ReadString('Colors', 'HKGlobal', 'clGreen'));
		clSeparator := StringToColor(ReadString('Colors', 'Separator', 'clBlack'));
	finally
		Free;
	end;
end;

procedure TMainForm.Restore(const Forced: Boolean);
begin
	tmrMouseLeave.Enabled := True;
	if IsHidden or Forced then begin
		IsChangeForm := True;
		if WndPos = 'Left' then Left := 0 else
			if WndPos = 'Right' then Left := Screen.Width - WidthMax;
		if WndPos <> 'Manual' then Width := WidthMax;
		AlphaBlend := False;
		IsChangeForm := False;
	end;
	IsHidden := False;
end;

procedure TMainForm.SaveToIni;
begin
	with TIniFile.Create(AppPath + '\config.cfg') do try
		if Left <> ReadInteger('Settings', 'Left', 0) then
			WriteInteger('Settings', 'Left', Left);
		if Top <> ReadInteger('Settings', 'Top', 0) then
			WriteInteger('Settings', 'Top', Top);
		if WidthMin <> ReadInteger('Settings', 'WidthMin', 0) then
			WriteInteger('Settings', 'WidthMin', WidthMin);
		if WidthMax <> ReadInteger('Settings', 'WidthMax', 0) then
			WriteInteger('Settings', 'WidthMax', WidthMax);
		if WndPos <> ReadString('Settings', 'WindowPosition', '') then
			WriteString('Settings', 'WindowPosition', WndPos);
	finally
		Free;
	end;
end;

procedure TMainForm.SendCommand(const Number: Byte; const IsTeamChat: Boolean);
var
	IsWindowFound: Boolean;
	CurrKbdLayout: HKL;

	procedure ClickKey(Key: Word);
	begin
		keybd_event(Key, MapVirtualKey(Key, 0), 0, 0);
		keybd_event(Key, MapVirtualKey(Key, 0), KEYEVENTF_KEYUP, 0);
	end;

begin
	CurrKbdLayout := GetKeyboardLayout(0);
	ActivateKeyboardLayout($0419, KLF_ACTIVATE);
	Clipboard.AsText := Commands.List[Number].Text;
	ActivateKeyboardLayout(CurrKbdLayout, KLF_ACTIVATE);
	if TargetWndName > '' then
		IsWindowFound := hActiveWnd = FindWindow(nil, @TargetWndName)
	else IsWindowFound := hActiveWnd > 0;
	SetForegroundWindow(hActiveWnd);
	if IsWindowFound then begin
		Sleep(300);
		if IsTeamChat then ClickKey(Ord('T')) else ClickKey(VK_RETURN);
		Sleep(300);
		keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0); // Press Ctrl
		ClickKey(Ord('V'));
		keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0); // Release Ctrl
		if not Commands.List[Number].IsDelay then ClickKey(VK_RETURN);
	end;
end;

procedure TMainForm.Shrink;
begin
	tmrMouseLeave.Enabled := False;
	if not IsHidden then begin
		IsChangeForm := True;
		if WndPos = 'Left' then Left := 0 else
			if WndPos = 'Right' then Left := Screen.Width - WidthMin;
		if WndPos <> 'Manual' then Width := WidthMin;
		AlphaBlend := True;
		IsHidden := True;
		IsChangeForm := False;
	end;
end;

initialization

	IsHidden := True;
	IsChangeForm := True;
	IsAppWork := True;

end.