unit uCommandList;

interface

uses Classes;

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
		HotKey, AltHotKey: THotKey;
	end;

	TCommandList = class
	private
		FHeader: TStringList;
		FList: array of TCommand;
		FOwner: THandle;
		function GetCount: Byte;
		function GetItem(Index: Byte): TCommand;
	public
		constructor Create(const AOwner: THandle; const AFileName: string);
		destructor Destroy; override;
		procedure LoadFromFile(const AFilename: string);
		procedure RegisterHotKeys;
		procedure UnregisterHotKeys;
		property Count: Byte read GetCount;
		property Header: TStringList read FHeader;
		property List[Index: Byte]: TCommand read GetItem; default;
	end;

var
	Commands: TCommandList;

implementation

uses Windows, SysUtils, Menus;

const
	sCommandListSignature = 'MCLST';
	sDefaultHotKey = 'Enter';

{ TCommandList }

constructor TCommandList.Create(const AOwner: THandle; const AFileName: string);
begin
	FOwner := AOwner;
	FHeader := TStringList.Create;
	if FileExists(AFileName) then LoadFromFile(AFileName);
	RegisterHotKeys;
end;

destructor TCommandList.Destroy;
var
	I: Byte;
begin
	UnregisterHotKeys;
	for I := 0 to Count - 1 do begin
		if Self[I].HotKey.Atom > 0 then GlobalDeleteAtom(Self[I].HotKey.Atom);
		if Self[I].AltHotKey.Atom > 0 then GlobalDeleteAtom(Self[I].AltHotKey.Atom);
	end;
	SetLength(FList, 0);
	FHeader.Free;
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
var
	Buffer, Lexer: TStringList;
	I: Shortint;
	Shortcut: Word;
begin
	Buffer := TStringList.Create;
	Lexer := TStringList.Create;
	Lexer.Delimiter := #9;
	try
		Buffer.LoadFromFile(AFilename);
		if Buffer.Count = 0 then raise EReadError.CreateFmt('Файл "%s" пуст!', [AFilename]);
		Lexer.DelimitedText := Buffer[0];
		if (Lexer.Count > 0) and SameText(Lexer[0], sCommandListSignature) then begin
			Lexer.Delete(0);
			FHeader.AddStrings(Lexer);
			if FHeader[2] = EmptyStr then FHeader[2] := sDefaultHotKey;
			if FHeader[1] = EmptyStr then FHeader[1] := FHeader[2];
			if FHeader[4] = EmptyStr then FHeader[4] := FHeader[2];
			if FHeader[3] = EmptyStr then FHeader[3] := FHeader[4];
			Buffer.Delete(0);
		end;
		SetLength(FList, Buffer.Count);
		for I := 0 to Buffer.Count - 1 do if Buffer[I] > EmptyStr then begin
			Lexer.DelimitedText := Buffer[I];
			FList[I].Text := Lexer[0];
			FList[I].IsDelay := FList[I].Text[1] = '%';
			if FList[I].IsDelay then Delete(FList[I].Text, 1, 1);
			FList[I].HotKey.AsString := Lexer[1];
			FList[I].AltHotKey.AsString := Lexer[2];
			if FList[I].HotKey.AsString > EmptyStr then begin
				Shortcut := TextToShortCut(FList[I].HotKey.AsString);
				if Shortcut > 0 then begin
					FList[I].HotKey.Atom := GlobalAddAtom(PChar('MC_Main_' + IntToStr(I)));
					if Shortcut and scShift > 0 then FList[I].HotKey.Modifiers := FList[I].HotKey.Modifiers or MOD_SHIFT;
					if Shortcut and scCtrl > 0 then FList[I].HotKey.Modifiers := FList[I].HotKey.Modifiers or MOD_CONTROL;
					if Shortcut and scAlt > 0 then FList[I].HotKey.Modifiers := FList[I].HotKey.Modifiers or MOD_ALT;
					FList[I].HotKey.VirtualCode := Byte(Shortcut);
				end else begin
					FList[I].HotKey.Atom := 0;
					FList[I].HotKey.IsRegister := False;
				end;
			end;
			if FList[I].AltHotKey.AsString > EmptyStr then begin
				Shortcut := TextToShortCut(FList[I].AltHotKey.AsString);
				if Shortcut > 0 then begin
					FList[I].AltHotKey.Atom := GlobalAddAtom(PChar('MC_Alt_' + IntToStr(I)));
					if Shortcut and scShift > 0 then FList[I].AltHotKey.Modifiers := FList[I].AltHotKey.Modifiers or MOD_SHIFT;
					if Shortcut and scCtrl > 0 then FList[I].AltHotKey.Modifiers := FList[I].AltHotKey.Modifiers or MOD_CONTROL;
					if Shortcut and scAlt > 0 then FList[I].AltHotKey.Modifiers := FList[I].AltHotKey.Modifiers or MOD_ALT;
					FList[I].AltHotKey.VirtualCode := Byte(Shortcut);
				end else begin
					FList[I].AltHotKey.Atom := 0;
					FList[I].AltHotKey.IsRegister := False;
				end;
			end;
		end;
	finally
		Lexer.Free;
		Buffer.Free;
	end;
end;

procedure TCommandList.RegisterHotKeys;
var
	I: Shortint;
begin
	for I := 0 to Count - 1 do begin
		if FList[I].HotKey.Atom > 0 then FList[I].HotKey.IsRegister :=
			RegisterHotKey(FOwner, FList[I].HotKey.Atom, FList[I].HotKey.Modifiers, FList[I].HotKey.VirtualCode);
		if FList[I].AltHotKey.Atom > 0 then FList[I].AltHotKey.IsRegister :=
			RegisterHotKey(FOwner, FList[I].AltHotKey.Atom, FList[I].AltHotKey.Modifiers, FList[I].AltHotKey.VirtualCode);
	end;
end;

procedure TCommandList.UnregisterHotKeys;
var
	I: Shortint;
begin
	for I := 0 to Count - 1 do begin
		if (FList[I].HotKey.Atom > 0) and FList[I].HotKey.IsRegister then
			FList[I].HotKey.IsRegister := not UnregisterHotKey(FOwner, FList[I].HotKey.Atom);
		if (FList[I].AltHotKey.Atom > 0) and FList[I].AltHotKey.IsRegister then
			FList[I].AltHotKey.IsRegister := not UnregisterHotKey(FOwner, FList[I].AltHotKey.Atom);
	end;
end;

end.

