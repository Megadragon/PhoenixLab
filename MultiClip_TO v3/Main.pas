unit Main;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, IniFiles, Menus, ExtCtrls, Clipbrd, CoolTrayIcon, ImgList,
	XPMan, About;

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
		XPM: TXPManifest;
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
		procedure Shrink;
		property AppPath: string read FAppPath write FAppPath;
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

{$R *.dfm}

type
	THotKey = packed record
		Atom: Integer;
		IsRegister: Boolean;
		Shortcut: Cardinal;
		Modifiers: Cardinal;
		VirtualCode: Cardinal;
		AsString: string;
	end;

	TCommand = packed record
		IsDelay: Boolean;
		Text: string;
		hkTeam: THotKey;
		hkGlobal: THotKey;
	end;

var
	CommandCount: Byte;
	Commands: array of TCommand;

procedure RegHK;
var
	I: Byte;
begin
	for I := 0 to CommandCount - 1 do begin
		if Commands[I].hkTeam.Atom > 0 then Commands[I].hkTeam.IsRegister :=
			RegisterHotKey(MainForm.Handle, Commands[I].hkTeam.Atom, Commands[I].hkTeam.Modifiers, Commands[I].hkTeam.VirtualCode);
		if Commands[I].hkGlobal.Atom > 0 then Commands[I].hkGlobal.IsRegister :=
			RegisterHotKey(MainForm.Handle, Commands[I].hkGlobal.Atom, Commands[I].hkGlobal.Modifiers, Commands[I].hkGlobal.VirtualCode);
	end;
end;

procedure UnregHK;
var
	I: Byte;
begin
	for I := 0 to CommandCount - 1 do begin
		if (Commands[I].hkTeam.Atom > 0) and Commands[I].hkTeam.IsRegister then
			UnregisterHotkey(MainForm.Handle, Commands[I].hkTeam.Atom);
		if (Commands[I].hkGlobal.Atom > 0) and Commands[I].hkGlobal.IsRegister then
			UnregisterHotkey(MainForm.Handle, Commands[I].hkGlobal.Atom);
	end;
end;

procedure ClickKey(Key: Word);
begin
	keybd_event(Key, 0, 0, 0);
	keybd_event(Key, 0, KEYEVENTF_KEYUP, 0);
end;

procedure SendCommand(const Number: Byte; const IsTeamChat: Boolean);
var
	IsWindowFound: Boolean;
begin
	Clipboard.AsText := Commands[Number].Text;
	if TargetWndName > '' then IsWindowFound := hActiveWnd = FindWindow(nil, @TargetWndName)
	else IsWindowFound := hActiveWnd > 0;
	SetForegroundWindow(hActiveWnd);
	if IsWindowFound then begin
		Sleep(300);
		if IsTeamChat then ClickKey(Ord('T')) else ClickKey(VK_RETURN);
		Sleep(300);
		keybd_event(VK_CONTROL, 0, 0, 0); // Press Ctrl
		ClickKey(Ord('V'));
		keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0); // Release Ctrl
		if not Commands[Number].IsDelay then ClickKey(VK_RETURN);
	end;
end;

{ TfrmMain }

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
	AppPath := ExtractFilePath(Application.ExeName);
	if IsAppWork then POnOff.Caption := 'Выключить'
	else POnOff.Caption := 'Включить';
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
	I: Byte;
begin
	UnregHK;
	for I := 0 to CommandCount - 1 do begin
		if Commands[I].hkTeam.Atom > 0 then GlobalDeleteAtom(Commands[I].hkTeam.Atom);
		if Commands[I].hkGlobal.Atom > 0 then GlobalDeleteAtom(Commands[I].hkGlobal.Atom);
	end;
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
		TextOut(Rect.Left + 2, Rect.Top, Commands[Index].Text);
		Font.Height := HKFontSz;
		if Commands[Index].hkTeam.IsRegister then Font.Color := clHKTeam else Font.Color := clRed;
		hkWidth := TextWidth(Commands[Index].hkTeam.AsString);
		if HKPos = 'Down' then TextOut(Rect.Left + 2, Rect.Bottom - HKFontSz, Commands[Index].hkTeam.AsString)
		else TextOut(Rect.Right - hkWidth - 2, Rect.Top, Commands[Index].hkTeam.AsString);
		if Commands[Index].hkGlobal.IsRegister then Font.Color := clHKGlobal else Font.Color := clRed;
		hkWidth := TextWidth(Commands[Index].hkGlobal.AsString);
		TextOut(Rect.Right - hkWidth - 2, Rect.Bottom - HKFontSz, Commands[Index].hkGlobal.AsString);
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
			lsbCommandsDrawItem(nil, Tag, ItemRect(Tag), [odDefault]);
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
		Hide;
		UnregHK;
		POnOff.Caption := 'Включить';
	end else begin
		ctiTrayIcon.IconIndex := 1;
		RegHK;
		Show;
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
	if (Tag >= 0) and (Commands[Tag].Text > '')
		and (GetKeyState(VK_SHIFT) + GetKeyState(VK_CONTROL) + GetKeyState(VK_MENU) >= 0)
	then begin
		SendCommand(Tag, IsTeamHotkey);
		tmrTargetWndActivate.Interval := 1000;
		Tag := -1;
	end;
end;

{ TfrmMain.private }

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
	for I := 0 to CommandCount - 1 do begin
		if Msg.HotKey = Commands[I].hkTeam.Atom then begin
			Tag := I;
			IsTeamHotkey := True;
			Break;
		end;
		if Msg.HotKey = Commands[I].hkGlobal.Atom then begin
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

{ TfrmMain.public }

procedure TMainForm.LoadCommands;
var
	I, J: Byte;
	Buffer: string;
begin
	if FileExists(AppPath + 'command.lst') then begin
		lsbCommands.Items.LoadFromFile(AppPath + 'command.lst');
		CommandCount := lsbCommands.Count;
		SetLength(Commands, CommandCount);
		ClientHeight := lsbCommands.ItemRect(CommandCount - 1).Bottom + 4;
		if Height > Screen.Height then Height := Screen.Height;
		for I := 0 to CommandCount - 1 do begin
			Commands[I].hkTeam.Atom := 0;
			Commands[I].hkTeam.IsRegister := False;
			Commands[I].hkGlobal.Atom := 0;
			Commands[I].hkGlobal.IsRegister := False;
			Buffer := lsbCommands.Items[I];
			if Buffer = '' then Continue;
			Commands[I].IsDelay := Buffer[1] = '%';
			if Commands[I].IsDelay then Delete(Buffer, 1, 1);
			J := Pos(#9, Buffer);
			if J > 0 then begin
				Commands[I].Text := Copy(Buffer, 1, J - 1);
				Delete(Buffer, 1, J);
				J := Pos(#9, Buffer);
				if J > 0 then begin
					Commands[I].hkTeam.AsString := Copy(Buffer, 1, J - 1);
					Delete(Buffer, 1, J);
					Commands[I].hkGlobal.AsString := Buffer;
				end else Commands[I].hkTeam.AsString := Buffer;
				Commands[I].hkTeam.Shortcut := TextToShortCut(Commands[I].hkTeam.AsString);
				if Commands[I].hkTeam.Shortcut > 0 then begin
					Commands[I].hkTeam.Atom := GlobalAddAtom(PAnsiChar('T' + IntToStr(I)));
					Commands[I].hkTeam.Modifiers := 0;
					if (Commands[I].hkTeam.Shortcut and scShift) <> 0 then Commands[I].hkTeam.Modifiers := Commands[I].hkTeam.Modifiers or MOD_SHIFT;
					if (Commands[I].hkTeam.Shortcut and scAlt) <> 0 then Commands[I].hkTeam.Modifiers := Commands[I].hkTeam.Modifiers or MOD_ALT;
					if (Commands[I].hkTeam.Shortcut and scCtrl) <> 0 then Commands[I].hkTeam.Modifiers := Commands[I].hkTeam.Modifiers or MOD_CONTROL;
					Commands[I].hkTeam.VirtualCode := LOBYTE(Commands[I].hkTeam.Shortcut);
				end;
				Commands[I].hkGlobal.Shortcut := TextToShortCut(Commands[I].hkGlobal.AsString);
				if Commands[I].hkGlobal.Shortcut > 0 then begin
					Commands[I].hkGlobal.Atom := GlobalAddAtom(PAnsiChar('G' + IntToStr(I)));
					Commands[I].hkGlobal.Modifiers := 0;
					if (Commands[I].hkGlobal.Shortcut and scShift) <> 0 then Commands[I].hkGlobal.Modifiers := Commands[I].hkGlobal.Modifiers or MOD_SHIFT;
					if (Commands[I].hkGlobal.Shortcut and scAlt) <> 0 then Commands[I].hkGlobal.Modifiers := Commands[I].hkGlobal.Modifiers or MOD_ALT;
					if (Commands[I].hkGlobal.Shortcut and scCtrl) <> 0 then Commands[I].hkGlobal.Modifiers := Commands[I].hkGlobal.Modifiers or MOD_CONTROL;
					Commands[I].hkGlobal.VirtualCode := LOBYTE(Commands[I].hkGlobal.Shortcut);
				end;
			end else Commands[I].Text := Buffer;
		end;
		RegHK;
	end else Close;
	ctiTrayIcon.IconIndex := 1;
end;

procedure TMainForm.LoadFromIni;
begin
	with TIniFile.Create(AppPath + 'config.cfg') do try
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
	with TIniFile.Create(AppPath + 'config.cfg') do try
		WriteInteger('Settings', 'Left', Left);
		WriteInteger('Settings', 'Top', Top);
		WriteInteger('Settings', 'WidthMin', WidthMin);
		WriteInteger('Settings', 'WidthMax', WidthMax);
		WriteInteger('Settings', 'AlphaBlendValue', AlphaBlendValue);
		WriteInteger('Settings', 'DelayBeforeMinimize', tmrMouseLeave.Interval);
		WriteInteger('Settings', 'FontSize', FontSz);
		WriteInteger('Settings', 'HKFontSize', HKFontSz);
		WriteString('Settings', 'HKPosition', HKPos);
		WriteString('Settings', 'WindowPosition', WndPos);
		WriteString('Settings', 'TargetWindowName', TargetWndName);
		WriteString('Colors', 'List', ColorToString(clList));
		WriteString('Colors', 'Selected', ColorToString(clSelected));
		WriteString('Colors', 'Text', ColorToString(clText));
		WriteString('Colors', 'HKTeam', ColorToString(clHKTeam));
		WriteString('Colors', 'HKGlobal', ColorToString(clHKGlobal));
		WriteString('Colors', 'Separator', ColorToString(clSeparator));
	finally
		Free;
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