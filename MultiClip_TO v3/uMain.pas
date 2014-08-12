unit uMain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, ExtCtrls, ToolWin, ActnMan, ActnCtrls, ActnMenus, ActnList,
	StdActns, XPStyleActnCtrls;

type
	TMainForm = class(TForm)
		lsbCommands: TListBox;
		tmrMouseLeave: TTimer;
		tmrTargetWndActivate: TTimer;
		acmActions: TActionManager;
		afeExit: TFileExit;
		acnAbout: TAction;
		ammMenuBar: TActionMainMenuBar;
		procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
			var Resize: Boolean);
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
		procedure FormCreate(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
		procedure FormResize(Sender: TObject);
		procedure lsbCommandsClick(Sender: TObject);
		procedure lsbCommandsContextPopup(Sender: TObject; MousePos: TPoint;
			var Handled: Boolean);
		procedure lsbCommandsDrawItem(Control: TWinControl; Index: Integer;
			Rect: TRect; State: TOwnerDrawState);
		procedure lsbCommandsExit(Sender: TObject);
		procedure lsbCommandsMeasureItem(Control: TWinControl; Index: Integer;
			var Height: Integer);
		procedure lsbCommandsMouseMove(Sender: TObject; Shift: TShiftState;
			X, Y: Integer);
		procedure acnAboutExecute(Sender: TObject);
		procedure tmrMouseLeaveTimer(Sender: TObject);
		procedure tmrTargetWndActivateTimer(Sender: TObject);
	private
		procedure WMEnterSizeMove(var Msg: TMessage); message WM_ENTERSIZEMOVE;
		procedure WMExitSizeMove(var Msg: TMessage); message WM_EXITSIZEMOVE;
		procedure WMHotkey(var Msg: TWMHotkey); message WM_HOTKEY;
		procedure WMMove(var Msg: TWMMove); message WM_MOVE;
		procedure WMMoving(var Msg: TWMMoving); message WM_MOVING;
	public
		procedure LoadCommands;
		procedure LoadFromIni;
		procedure Restore(const Forced: Boolean = False);
		procedure SaveToIni;
		procedure SendCommand(const Number: Byte; const IsTeamChat: Boolean);
		procedure Shrink;
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

implementation

uses Clipbrd, IniFiles, uAbout, uCommandList;

{$R *.dfm}

procedure TMainForm.FormCanResize(Sender: TObject;
	var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
	if not IsChangeForm then begin
		if IsHidden then NewWidth := Width else begin
			WidthMax := NewWidth;
			if WndPos = 'Left' then Left := 0 else
				if WndPos = 'Right' then Left := Screen.Width - WidthMax;
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
	Commands := TCommandList.Create(Handle, GetCurrentDir + '\command.lst');
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

procedure TMainForm.lsbCommandsClick(Sender: TObject);
begin
	with lsbCommands do if Items[ItemIndex] > '' then begin
		SendCommand(ItemIndex, True);
		if not IsHidden then Shrink;
	end;
end;

procedure TMainForm.lsbCommandsContextPopup(Sender: TObject;
	MousePos: TPoint; var Handled: Boolean);
begin
	with lsbCommands do if Items[ItemIndex] > '' then begin
		SendCommand(ItemIndex, False);
		if not IsHidden then Shrink;
	end;
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
		if Index = lsbCommands.ItemIndex then Brush.Color := clSelected
		else Brush.Color := clList;
		FillRect(Rect);
		Font.Height := FontSz;
		Font.Color := clText;
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
		if (HKPos = 'Down') and (Commands[Index].hkTeam.Atom or Commands[Index].hkGlobal.Atom <> 0)
		then Height := FontSz + HKFontSz else Height := FontSz;
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

procedure TMainForm.acnAboutExecute(Sender: TObject);
begin
	AboutBox.ShowModal;
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
	if H <> Handle then hActiveWnd := H;
	if (Tag >= 0) and (Commands[Tag].Text > '')
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
	for I := 0 to Commands.Count - 1 do begin
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
	tmrTargetWndActivate.Interval := 100;
end;

procedure TMainForm.WMMove(var Msg: TWMMove);
begin
	if not IsChangeForm then begin
		IsChangeForm := True;
		if Left = 0 then WndPos := 'Left' else
			if Left + Width = Screen.Width then WndPos := 'Right' else
				WndPos := 'Manual';
		IsChangeForm := False;
	end;
end;

procedure TMainForm.WMMoving(var Msg: TWMMoving);
begin
	if Msg.DragRect^.Left < Screen.WorkAreaLeft then
		OffsetRect(Msg.DragRect^, Screen.WorkAreaLeft - Msg.DragRect^.Left, 0);
	if Msg.DragRect^.Top < Screen.WorkAreaTop then
		OffsetRect(Msg.DragRect^, 0, Screen.WorkAreaTop - Msg.DragRect^.Top);
	if Msg.DragRect^.Right > Screen.WorkAreaRect.Right then
		OffsetRect(Msg.DragRect^, Screen.WorkAreaRect.Right - Msg.DragRect^.Right, 0);
	if Msg.DragRect^.Bottom > Screen.WorkAreaRect.Bottom then
		OffsetRect(Msg.DragRect^, 0, Screen.WorkAreaRect.Bottom - Msg.DragRect^.Bottom);
end;

{ Secondary procedures }

procedure TMainForm.LoadCommands;
var
	I: Byte;
begin
	for I := 0 to Commands.Count - 1 do
		lsbCommands.Items.Add(Commands[I].Text);
	ClientHeight := ammMenuBar.Height + lsbCommands.ItemRect(lsbCommands.Count - 1).Bottom;
	if Height > Screen.Height then Height := Screen.Height;
end;

procedure TMainForm.LoadFromIni;
begin
	with TIniFile.Create(GetCurrentDir + '\Multiclip.ini') do try
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
	if IsHidden or Forced then begin
		IsChangeForm := True;
		if WndPos = 'Left' then Left := 0 else
			if WndPos = 'Right' then Left := Screen.Width - WidthMax;
		if WndPos <> 'Manual' then Width := WidthMax;
		ammMenuBar.Height := ClientHeight - lsbCommands.Height;
		AlphaBlend := False;
		IsChangeForm := False;
	end;
	IsHidden := False;
	tmrMouseLeave.Enabled := True;
end;

procedure TMainForm.SaveToIni;
begin
	with TIniFile.Create(GetCurrentDir + '\Multiclip.ini') do try
		WriteInteger('Settings', 'Left', Left);
		WriteInteger('Settings', 'Top', Top);
		WriteInteger('Settings', 'WidthMin', WidthMin);
		WriteInteger('Settings', 'WidthMax', WidthMax);
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
	Clipboard.AsText := Commands[Number].Text;
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

end.