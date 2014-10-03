unit uMain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, ExtCtrls, ActnList, StdActns, AppEvnts;

type
	TMainForm = class(TForm)
		lsbCommands: TListBox;
		acnActions: TActionList;
		acnExit: TFileExit;
		acnAbout: TAction;
		apeEvents: TApplicationEvents;
		tmrMouseLeave: TTimer;
		tmrTargetWndActivate: TTimer;
		procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
			var Resize: Boolean);
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
		procedure FormCreate(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
		procedure FormResize(Sender: TObject);
		procedure lsbCommandsClick(Sender: TObject);
		procedure lsbCommandsDrawItem(Control: TWinControl; Index: Integer;
			Rect: TRect; State: TOwnerDrawState);
		procedure lsbCommandsMeasureItem(Control: TWinControl; Index: Integer;
			var Height: Integer);
		procedure lsbCommandsMouseMove(Sender: TObject; Shift: TShiftState;
			X, Y: Integer);
		procedure acnAboutExecute(Sender: TObject);
		procedure apeEventsMinimize(Sender: TObject);
		procedure apeEventsRestore(Sender: TObject);
		procedure tmrMouseLeaveTimer(Sender: TObject);
		procedure tmrTargetWndActivateTimer(Sender: TObject);
	public
		procedure LoadCommands;
		procedure LoadFromIni;
		procedure Restore;
		procedure SaveToIni;
		procedure SendCommand(const Number: Byte);
		procedure Shrink;
		procedure WndProc(var Msg: TMessage); override;
	end;

var
	MainForm: TMainForm;

	WidthMin, WidthMax: Word;
	IsHidden, IsChangeForm: Boolean;
	FontSz, HKFontSz: Byte;

	clList, clSelected: TColor;
	clText, clSeparator: TColor;
	clHotkey: TColor;

	hActiveWnd: THandle;
	TargetWndName: string;
	WndPos: string;

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
				if WndPos = 'Right' then Left := Screen.WorkAreaWidth - WidthMax;
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
	hOwner := Handle;
	Commands := TCommandList.Create(GetCurrentDir + '\command.lst');
	LoadFromIni;
	LoadCommands;
	Restore;
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
		SendCommand(ItemIndex);
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
		if Index = lsbCommands.ItemIndex then Brush.Color := clSelected else Brush.Color := clList;
		FillRect(Rect);
		Font.Height := FontSz;
		Font.Color := clText;
		TextOut(Rect.Left + 2, Rect.Top, Commands[Index].Text);
		Font.Height := HKFontSz;
		if Commands[Index].HotKey.IsRegister then Font.Color := clHotkey else Font.Color := clRed;
		hkWidth := TextWidth(Commands[Index].HotKey.AsString);
		TextOut(Rect.Right - hkWidth - 2, Rect.Top, Commands[Index].HotKey.AsString);
		Brush.Color := clWhite;
		Font.Color := clBlack;
	end;
end;

procedure TMainForm.lsbCommandsMeasureItem(Control: TWinControl; Index: Integer;
	var Height: Integer);
begin
	if lsbCommands.Items[Index] = '' then Height := 2 else Height := FontSz;
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

procedure TMainForm.apeEventsMinimize(Sender: TObject);
begin
	Commands.UnregHK;
	ShowWindow(Application.Handle, SW_SHOW);
end;

procedure TMainForm.apeEventsRestore(Sender: TObject);
begin
	Commands.RegHK;
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
	if H <> Handle then hActiveWnd := H;
	if (Tag >= 0) and (GetKeyState(VK_SHIFT) + GetKeyState(VK_CONTROL) + GetKeyState(VK_MENU) >= 0)
	then begin
		SendCommand(Tag);
		Tag := -1;
	end;
end;

{ Public procedures }

procedure TMainForm.LoadCommands;
var
	I: Byte;
begin
	lsbCommands.Items.BeginUpdate;
	for I := 0 to Commands.Count - 1 do
		lsbCommands.Items.Add(Commands[I].Text);
	lsbCommands.Items.EndUpdate;
	ClientHeight := lsbCommands.ItemRect(lsbCommands.Count - 1).Bottom;
	if Height > Screen.Height then Height := Screen.Height;
end;

procedure TMainForm.LoadFromIni;
begin
	with TIniFile.Create(GetCurrentDir + '\Multiclip.ini') do try
		Left := ReadInteger('Settings', 'Left', Left);
		Top := ReadInteger('Settings', 'Top', Top);
		WidthMin := ReadInteger('Settings', 'WidthMin', 132);
		if WidthMin < 132 then WidthMin := 132;
		WidthMax := ReadInteger('Settings', 'WidthMax', 300);
		if WidthMax < WidthMin then WidthMax := WidthMin;
		AlphaBlendValue := ReadInteger('Settings', 'AlphaBlendValue', 40);
		tmrMouseLeave.Interval := ReadInteger('Settings', 'DelayBeforeMinimize', 300);
		FontSz := ReadInteger('Settings', 'FontSize', 30);
		HKFontSz := ReadInteger('Settings', 'HKFontSize', 15);
		WndPos := ReadString('Settings', 'WindowPosition', 'Right');
		if (WndPos <> 'Left') and (WndPos <> 'Right') and (WndPos <> 'Manual') then WndPos := 'Right';
		TargetWndName := ReadString('Settings', 'TargetWindowName', '');
		clList := StringToColor(ReadString('Colors', 'List', 'clWhite'));
		clSelected := StringToColor(ReadString('Colors', 'Selected', 'clLime'));
		clText := StringToColor(ReadString('Colors', 'Text', 'clBlack'));
		clHotkey := StringToColor(ReadString('Colors', 'Hotkey', 'clOlive'));
		clSeparator := StringToColor(ReadString('Colors', 'Separator', 'clBlack'));
	finally
		Free;
	end;
end;

procedure TMainForm.Restore;
begin
	if IsHidden then begin
		IsChangeForm := True;
		if WndPos = 'Left' then Left := 0 else
			if WndPos = 'Right' then Left := Screen.Width - WidthMax;
		if WndPos <> 'Manual' then Width := WidthMax;
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
		WriteInteger('Settings', 'WidthMax', WidthMax);
		WriteString('Settings', 'WindowPosition', WndPos);
	finally
		Free;
	end;
end;

procedure TMainForm.SendCommand(const Number: Byte);
var
	IsWindowFound: Boolean;
	CurrKbdLayout: HKL;

	procedure ClickKey(Key: Word);
	begin
		keybd_event(Key, 0, 0, 0);
		keybd_event(Key, 0, KEYEVENTF_KEYUP, 0);
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
		{if InsertMode = 'AnyChat' then} ClickKey(VK_RETURN);
		Sleep(100);
		keybd_event(VK_CONTROL, 0, 0, 0); // Press Ctrl
		ClickKey(Ord('V'));
		keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0); // Release Ctrl
		Sleep(100);
		if not Commands[Number].IsDelay then ClickKey(VK_RETURN);
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

procedure TMainForm.WndProc(var Msg: TMessage);
var
	I: Byte;
begin
	case Msg.Msg of
		WM_ENTERSIZEMOVE: tmrMouseLeave.Enabled := False;
		WM_EXITSIZEMOVE: tmrMouseLeave.Enabled := True;
		WM_HOTKEY: for I := 0 to Commands.Count - 1 do
			if Msg.wParam = Commands[I].HotKey.Atom then Tag := I;
		WM_MOVE: if not IsChangeForm then begin
			IsChangeForm := True;
			if Left = 0 then WndPos := 'Left' else
				if Left + Width = Screen.WorkAreaWidth then WndPos := 'Right'
				else WndPos := 'Manual';
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

initialization

	IsHidden := True;
	IsChangeForm := True;

end.