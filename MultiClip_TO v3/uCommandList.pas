unit uCommandList;

interface

uses Windows;

type
	THotKey = record
		Atom: Integer;
		IsRegister: Boolean;
		Shortcut: Cardinal;
		Modifiers: Cardinal;
		VirtualCode: Byte;
		AsString: string;
	end;

	TCommand = record
		IsDelay: Boolean;
		Text: string;
		hkTeam: THotKey;
		hkGlobal: THotKey;
	end;

	TCommandList = class
	private
		FCount: Word;
		FList: array of TCommand;
		function GetItem(Index: Word): TCommand;
	public
		constructor Create(const AFilename: string);
		destructor Destroy; override;
		procedure LoadFromFile(const AFilename: string);
		procedure RegHK;
		procedure UnregHK;
		property Count: Word read FCount;
		property List[index: Word]: TCommand read GetItem;
	end;

var
	Commands: TCommandList;

implementation

uses SysUtils, Menus, uMain, Dialogs;

{ TCommandList }

constructor TCommandList.Create(const AFilename: string);
begin
	FCount := 0;
	SetLength(FList, FCount);
	LoadFromFile(AFilename);
	RegHK;
end;

destructor TCommandList.Destroy;
var
	I: Word;
begin
	UnregHK;
	for I := 0 to Count - 1 do begin
		if List[I].hkTeam.Atom > 0 then GlobalDeleteAtom(List[I].hkTeam.Atom);
		if List[I].hkGlobal.Atom > 0 then GlobalDeleteAtom(List[I].hkGlobal.Atom);
	end;
	FCount := 0;
	SetLength(FList, FCount);
	inherited;
end;

function TCommandList.GetItem(Index: Word): TCommand;
begin
	with Result do begin
		IsDelay := FList[Index].IsDelay;
		Text := FList[Index].Text;
		hkTeam := FList[Index].hkTeam;
		hkGlobal := FList[Index].hkGlobal;
	end;
end;

procedure TCommandList.LoadFromFile(const AFilename: string);
const
	// from unit Classes
	scNone = 0;
	scShift = $2000;
	scCtrl = $4000;
	scAlt = $8000;
var
	CmdList: TextFile;
	Buffer: string;
	TabPos: Word;
begin
	if FileExists(AFilename) then begin
		AssignFile(CmdList, AFilename);
		Reset(CmdList);
		while not Eof(CmdList) do begin
			ReadLn(CmdList, Buffer);
			Inc(FCount);
			SetLength(FList, FCount);
			with FList[Count - 1] do begin
				hkTeam.Atom := 0;
				hkTeam.IsRegister := False;
				hkGlobal.Atom := 0;
				hkGlobal.IsRegister := False;
				if Buffer = '' then Continue;
				IsDelay := Buffer[1] = '%';
				if IsDelay then Delete(Buffer, 1, 1);
				TabPos := Pos(#9, Buffer);
				if TabPos > 0 then begin
					Text := Copy(Buffer, 1, TabPos - 1);
					Delete(Buffer, 1, TabPos);
					TabPos := Pos(#9, Buffer);
					if TabPos > 0 then begin
						hkTeam.AsString := Copy(Buffer, 1, TabPos - 1);
						Delete(Buffer, 1, TabPos);
						hkGlobal.AsString := Buffer;
					end else hkTeam.AsString := Buffer;
					with hkTeam do begin
						Shortcut := TextToShortCut(AsString);
						if Shortcut > 0 then begin
							Atom := GlobalAddAtom(PChar('T' + IntToStr(Count - 1)));
							Modifiers := 0;
							if Shortcut and scShift > 0 then Modifiers := Modifiers or MOD_SHIFT;
							if Shortcut and scCtrl > 0 then Modifiers := Modifiers or MOD_CONTROL;
							if Shortcut and scAlt > 0 then Modifiers := Modifiers or MOD_ALT;
							VirtualCode := Shortcut;
						end;
					end;
					with hkGlobal do begin
						Shortcut := TextToShortCut(AsString);
						if Shortcut > 0 then begin
							Atom := GlobalAddAtom(PChar('T' + IntToStr(Count - 1)));
							Modifiers := 0;
							if Shortcut and scShift > 0 then Modifiers := Modifiers or MOD_SHIFT;
							if Shortcut and scCtrl > 0 then Modifiers := Modifiers or MOD_CONTROL;
							if Shortcut and scAlt > 0 then Modifiers := Modifiers or MOD_ALT;
							VirtualCode := Shortcut;
						end;
					end;
				end else Text := Buffer;
			end;
		end;
		CloseFile(CmdList);
	end;
end;

procedure TCommandList.RegHK;
var
	I: Word;
begin
	for I := 0 to Count - 1 do begin
		if List[I].hkTeam.Atom > 0 then FList[I].hkTeam.IsRegister :=
			RegisterHotKey(MainForm.Handle, List[I].hkTeam.Atom, List[I].hkTeam.Modifiers, List[I].hkTeam.VirtualCode);
		if List[I].hkGlobal.Atom > 0 then FList[I].hkGlobal.IsRegister :=
			RegisterHotKey(MainForm.Handle, List[I].hkGlobal.Atom, List[I].hkGlobal.Modifiers, List[I].hkGlobal.VirtualCode);
	end;
end;

procedure TCommandList.UnregHK;
var
	I: Word;
begin
	for I := 0 to Count - 1 do begin
		if (List[I].hkTeam.Atom > 0) and FList[I].hkTeam.IsRegister then
			UnregisterHotkey(MainForm.Handle, List[I].hkTeam.Atom);
		if (List[I].hkGlobal.Atom > 0) and FList[I].hkGlobal.IsRegister then
			UnregisterHotkey(MainForm.Handle, List[I].hkGlobal.Atom);
	end;
end;

end.
