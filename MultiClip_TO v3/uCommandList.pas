unit uCommandList;

interface

type
	THotKey = record
		Atom: Word;
		IsRegister: Boolean;
		Shortcut: Word;
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
		FCount: Byte;
		FList: array of TCommand;
		FOwnerID: Cardinal;
		function GetItem(Index: Byte): TCommand;
	public
		constructor Create(AOwnerID: Cardinal; AFilename: string);
		destructor Destroy; override;
		procedure LoadFromFile(const AFilename: string);
		procedure RegHK;
		procedure UnregHK;
		property Count: Byte read FCount;
		property OwnerID: Cardinal read FOwnerID;
		property List[Index: Byte]: TCommand read GetItem; default;
	end;

var
	Commands: TCommandList;

implementation

uses Windows, SysUtils, Menus;

{ TCommandList }

constructor TCommandList.Create(AOwnerID: Cardinal; AFilename: string);
begin
	FCount := 0;
	FOwnerID := AOwnerID;
	SetLength(FList, Count);
	LoadFromFile(AFilename);
	RegHK;
end;

destructor TCommandList.Destroy;
var
	I: Word;
begin
	UnregHK;
	for I := 0 to Count - 1 do begin
		if Self[I].hkTeam.Atom > 0 then GlobalDeleteAtom(Self[I].hkTeam.Atom);
		if Self[I].hkGlobal.Atom > 0 then GlobalDeleteAtom(Self[I].hkGlobal.Atom);
	end;
	FCount := 0;
	SetLength(FList, Count);
end;

function TCommandList.GetItem(Index: Byte): TCommand;
begin
	Result := FList[Index];
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
	TabPos: Byte;
begin
	if FileExists(AFilename) then begin
		AssignFile(CmdList, AFilename);
		Reset(CmdList);
		while not Eof(CmdList) do begin
			ReadLn(CmdList, Buffer);
			Inc(FCount);
			SetLength(FList, Count);
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
							Atom := GlobalAddAtom(PChar('G' + IntToStr(Count - 1)));
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
	I: Byte;
begin
	for I := 0 to Count - 1 do with FList[I] do begin
		if hkTeam.Atom > 0 then hkTeam.IsRegister :=
			RegisterHotKey(OwnerID, hkTeam.Atom, hkTeam.Modifiers, hkTeam.VirtualCode);
		if hkGlobal.Atom > 0 then hkGlobal.IsRegister :=
			RegisterHotKey(OwnerID, hkGlobal.Atom, hkGlobal.Modifiers, hkGlobal.VirtualCode);
	end;
end;

procedure TCommandList.UnregHK;
var
	I: Byte;
begin
	for I := 0 to Count - 1 do with FList[I] do begin
		if (hkTeam.Atom > 0) and hkTeam.IsRegister then
			UnregisterHotkey(OwnerID, hkTeam.Atom);
		if (hkGlobal.Atom > 0) and hkGlobal.IsRegister then
			UnregisterHotkey(OwnerID, hkGlobal.Atom);
	end;
end;

end.
