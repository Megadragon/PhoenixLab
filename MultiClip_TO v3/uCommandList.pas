unit uCommandList;

interface

type
	THotKey = record
		Atom: Word;
		IsRegister: Boolean;
		Modifiers: Cardinal;
		VirtualCode: Byte;
		AsString: string;
	end;

	TCommand = record
		IsDelay: Boolean;
		Text: string;
		HotKey: THotKey;
	end;

	TCommandList = class
	private
		FList: array of TCommand;
		function GetCount: Byte;
		function GetItem(Index: Byte): TCommand;
	public
		constructor Create(const AFilename: string);
		destructor Destroy; override;
		procedure LoadFromFile(const AFilename: string);
		procedure RegHK;
		procedure UnregHK;
		property Count: Byte read GetCount;
		property List[Index: Byte]: TCommand read GetItem; default;
	end;

var
	Commands: TCommandList;
	hOwner: THandle;

implementation

uses Windows, SysUtils, Menus;

{ TCommandList }

constructor TCommandList.Create(const AFilename: string);
begin
	if FileExists(AFilename) then LoadFromFile(AFilename);
	RegHK;
end;

destructor TCommandList.Destroy;
var
	I: Byte;
begin
	UnregHK;
	for I := 0 to Count - 1 do with Self[I].HotKey do
		if Atom > 0 then GlobalDeleteAtom(Atom);
	SetLength(FList, 0);
end;

function TCommandList.GetCount: Byte;
begin
	Result := Length(FList);
end;

function TCommandList.GetItem(Index: Byte): TCommand;
begin
	if Index < Count then Result := FList[Index];
end;

procedure TCommandList.LoadFromFile(const AFilename: string);
const // import from Classes.pas
	scShift = $2000;
	scCtrl = $4000;
	scAlt = $8000;
	scNone = 0;
var
	CmdList: TextFile;
	Buffer: string;
	TabPos: Byte;
	Shortcut: Word;
begin
	AssignFile(CmdList, AFilename);
	Reset(CmdList);
	while not Eof(CmdList) do begin
		ReadLn(CmdList, Buffer);
		SetLength(FList, Count + 1);
		if Buffer > '' then with FList[Count - 1] do begin
			IsDelay := Buffer[1] = '%';
			if IsDelay then Delete(Buffer, 1, 1);
			TabPos := Pos(#9, Buffer);
			if TabPos = 0 then Text := Buffer else begin
				Text := Copy(Buffer, 1, TabPos - 1);
				Delete(Buffer, 1, TabPos);
				with HotKey do begin
					AsString := Buffer;
					Shortcut := TextToShortCut(AsString);
					if Shortcut > 0 then begin
						Atom := GlobalAddAtom(PChar('Multiclip_Chat_' + IntToStr(Count - 1)));
						if Shortcut and scShift > 0 then Modifiers := Modifiers or MOD_SHIFT;
						if Shortcut and scCtrl > 0 then Modifiers := Modifiers or MOD_CONTROL;
						if Shortcut and scAlt > 0 then Modifiers := Modifiers or MOD_ALT;
						VirtualCode := Shortcut;
					end else begin
						Atom := 0;
						IsRegister := False;
					end;
				end;
			end;
		end;
	end;
	CloseFile(CmdList);
end;

procedure TCommandList.RegHK;
var
	I: Byte;
begin
	for I := 0 to Count - 1 do with Self[I].HotKey do if Atom > 0 then
		FList[I].HotKey.IsRegister := RegisterHotKey(hOwner, Atom, Modifiers, VirtualCode);
end;

procedure TCommandList.UnregHK;
var
	I: Byte;
begin
	for I := 0 to Count - 1 do with Self[I].HotKey do
		if (Atom > 0) and IsRegister then UnregisterHotKey(hOwner, Atom);
end;

end.
