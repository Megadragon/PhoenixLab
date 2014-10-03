unit uCommandList;

interface

uses Contnrs;

type
	THotKey = record
		Atom: Word;
		IsRegister: Boolean;
		Modifiers: Cardinal;
		VirtualCode: Byte;
		AsString: string;
	end;

	TCommand = class
	private
		FIsDelay: Boolean;
		FText: string;
		FHotKey: THotKey;
	public
		constructor Create(ASource: string; const AIndex: Byte);
		destructor Destroy; override;
		procedure RegHotKey;
		procedure UnregHotKey;
		property IsDelay: Boolean read FIsDelay;
		property Text: string read FText;
		property HotKey: THotKey read FHotKey;
	end;

	TCommandList = class(TObjectList)
	private
		function GetItem(Index: Byte): TCommand;
	public
		constructor Create(const AFilename: string);
		procedure LoadFromFile(const AFilename: string);
		procedure RegHK;
		procedure UnregHK;
		property List[Index: Byte]: TCommand read GetItem; default;
	end;

var
	Commands: TCommandList;
	hOwner: THandle;

implementation

uses Windows, SysUtils, Classes, Menus;

{ TCommand }

constructor TCommand.Create(ASource: string; const AIndex: Byte);
var
	TabPos: Byte;
	Shortcut: TShortCut;
begin
	if ASource = '' then Exit else begin
		FIsDelay := ASource[1] = '%';
		if IsDelay then Delete(ASource, 1, 1);
		TabPos := Pos(#9, ASource);
		if TabPos = 0 then FText := ASource else begin
			FText := Copy(ASource, 1, TabPos - 1);
			Delete(ASource, 1, TabPos);
			with HotKey do begin
				AsString := ASource;
				Shortcut := TextToShortCut(AsString);
				if Shortcut > 0 then begin
					Atom := GlobalAddAtom(PChar('Multiclip_Chat_' + IntToStr(AIndex)));
					Modifiers := 0;
					if Shortcut and scShift > 0 then Modifiers := Modifiers or MOD_SHIFT;
					if Shortcut and scCtrl > 0 then Modifiers := Modifiers or MOD_CONTROL;
					if Shortcut and scAlt > 0 then Modifiers := Modifiers or MOD_ALT;
					VirtualCode := Shortcut;
				end;
			end;
		end;
	end;
end;

destructor TCommand.Destroy;
begin
	with HotKey do if Atom > 0 then begin
		UnregHotKey;
		GlobalDeleteAtom(Atom);
	end;
end;

procedure TCommand.RegHotKey;
begin
	with FHotKey do if Atom > 0 then
		IsRegister := RegisterHotKey(hOwner, Atom, Modifiers, VirtualCode);
end;

procedure TCommand.UnregHotKey;
begin
	with HotKey do if (Atom > 0) and IsRegister then
		UnregisterHotKey(hOwner, Atom);
end;

{ TCommandList }

constructor TCommandList.Create(const AFilename: string);
begin
	inherited;
	LoadFromFile(AFilename);
	RegHK;
end;

function TCommandList.GetItem(Index: Byte): TCommand;
begin
	if Index < Count then Result := Items[Index] as TCommand else Result := nil;
end;

procedure TCommandList.LoadFromFile(const AFilename: string);
var
	CmdList: TextFile;
	Buffer: string;
begin
	if FileExists(AFilename) then begin
		AssignFile(CmdList, AFilename);
		Reset(CmdList);
		while not Eof(CmdList) do begin
			ReadLn(CmdList, Buffer);
			Add(TCommand.Create(Buffer, Count));
		end;
		CloseFile(CmdList);
	end;
end;

procedure TCommandList.RegHK;
var
	I: Byte;
begin
	for I := 0 to Count - 1 do Self[I].RegHotKey;
end;

procedure TCommandList.UnregHK;
var
	I: Byte;
begin
	for I := 0 to Count - 1 do Self[I].UnregHotKey;
end;

end.
