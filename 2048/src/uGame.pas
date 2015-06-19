unit uGame;

interface

type
	TField = array of array of Cardinal;
	TDirections = (dnNone, dnDown, dnLeft, dnRight, dnUp);

	TGame = class
	private
		FField: TField;
		FMovesCount: Cardinal;
		FScore: Cardinal;
		FTarget: Cardinal;
		function GetSize: Byte;
		function ShiftDown: Boolean; virtual;
		function ShiftLeft: Boolean; virtual;
		function ShiftRight: Boolean; virtual;
		function ShiftUp: Boolean; virtual;
	public
		constructor Create(const ASize: Byte = 4; const ATarget: Cardinal = 2048); overload;
		constructor Create(const AFileName: string); overload;
		destructor Destroy; override;
		function GetCell(const ARow, ACol: Byte): Cardinal;
		function IsLose: Boolean;
		function IsWin: Boolean;
		procedure GenRandomCell(const ACount: Byte = 1);
		procedure SaveToFile(const AFileName: string);
		procedure Shift(const ADirection: TDirections);
		property MovesCount: Cardinal read FMovesCount;
		property Score: Cardinal read FScore;
		property Size: Byte read GetSize;
		property Target: Cardinal read FTarget;
	end;

implementation

uses Math, Classes, SysUtils;

{ TGame }

constructor TGame.Create(const ASize: Byte; const ATarget: Cardinal);
var
	I, J: Byte;
begin
	SetLength(FField, ASize);
	for I := 0 to Size - 1 do begin
		SetLength(FField[I], ASize);
		for J := 0 to Size - 1 do FField[I, J] := 0;
	end;
	FMovesCount := 0;
	FScore := 0;
	FTarget := ATarget;
	GenRandomCell(2);
end;

constructor TGame.Create(const AFileName: string);
var
	fSave: file of Cardinal;
	Temp: Cardinal;
	I, J: Byte;
begin
	AssignFile(fSave, AFileName);
	Reset(fSave);
	try
		Read(fSave, Temp, FMovesCount, FScore, FTarget);
		SetLength(FField, Temp);
		for I := 0 to Size - 1 do begin
			SetLength(FField[I], Size);
			for J := 0 to Size - 1 do Read(fSave, FField[I, J]);
		end;
	finally
		CloseFile(fSave);
	end;
	DeleteFile(AFileName);
end;

destructor TGame.Destroy;
var
	I: Byte;
begin
	for I := 0 to Size - 1 do SetLength(FField[I], 0);
	SetLength(FField, 0);
	inherited;
end;

procedure TGame.GenRandomCell(const ACount: Byte);
var
	Row, Col, I: Byte;
begin
	for I := 1 to ACount do begin
		repeat
			Row := Random(Size);
			Col := Random(Size);
		until FField[Row, Col] = 0;
		if Random < 0.9 then FField[Row, Col] := 2 else FField[Row, Col] := 4;
	end;
end;

function TGame.GetCell(const ARow, ACol: Byte): Cardinal;
begin
	if (ARow < Size) and (ACol < Size) then Result := FField[ARow, ACol]
	else raise EListError.CreateFmt('Access denied to [%i; %i], ''coz Size = %i', [ARow, ACol, Size]);
end;

function TGame.GetSize: Byte;
begin
	Result := Length(FField);
end;

function TGame.IsLose: Boolean;
var
	I, J: Byte;
begin
	Result := True;
	for I := 0 to Size - 1 do
		for J := 0 to Size - 1 do begin
			Result := FField[I, J] <> 0;
			if not Result then Exit;
		end;
	for I := 0 to Size - 2 do begin
		for J := 0 to Size - 2 do begin
			Result := (FField[I, J] <> FField[I + 1, J]) and (FField[I, J] <> FField[I, J + 1]);
			if not Result then Exit;
		end;
		Result := (FField[Size - 1, I] <> FField[Size - 1, I + 1]) and (FField[I, Size - 1] <> FField[I + 1, Size - 1]);
		if not Result then Exit;
	end;
end;

function TGame.IsWin: Boolean;
var
	I, J: Byte;
begin
	Result := False;
	for I := 0 to Size - 1 do
		for J := 0 to Size - 1 do begin
			Result := FField[I, J] >= Target;
			if Result then Exit;
		end;
end;

procedure TGame.SaveToFile(const AFileName: string);
var
	fSave: file of Cardinal;
	Temp, I, J: Byte;
begin
	AssignFile(fSave, AFileName);
	Rewrite(fSave);
	try
		Temp := Size;
		Write(fSave, Temp, FMovesCount, FScore, FTarget);
		for I := 0 to Size - 1 do for J := 0 to Size - 1 do Write(fSave, FField[I, J]);
	finally
		CloseFile(fSave);
	end;
end;

procedure TGame.Shift(const ADirection: TDirections);
var
	IsMove: Boolean;
begin
	case ADirection of
		dnDown: IsMove := ShiftDown;
		dnLeft: IsMove := ShiftLeft;
		dnRight: IsMove := ShiftRight;
		dnUp: IsMove := ShiftUp;
	else IsMove := False;
	end;
	if IsMove then begin
		Inc(FMovesCount);
		GenRandomCell;
	end;
end;

function TGame.ShiftDown: Boolean;
var
	I, J, K: Byte;
begin
	Result := False;
	for I := Size - 2 downto 0 do
		for J := 0 to Size - 1 do begin
			if FField[I, J] = 0 then Continue;
			K := I;
			repeat
				Inc(K);
			until (K = Size - 1) or (FField[K, J] > 0);
			if (FField[K, J] > 0) and (FField[K, J] <> FField[I, J]) then Dec(K);
			if K > I then begin
				FField[K, J] := FField[K, J] + FField[I, J];
				if FField[K, J] > FField[I, J] then FScore := FScore + FField[K, J];
				FField[I, J] := 0;
				if not Result then Result := True;
			end;
		end;
end;

function TGame.ShiftLeft: Boolean;
var
	I, J, K: Byte;
begin
	Result := False;
	for I := 1 to Size - 1 do
		for J := 0 to Size - 1 do begin
			if FField[J, I] = 0 then Continue;
			K := I;
			repeat
				Dec(K);
			until (K = 0) or (FField[J, K] > 0);
			if (FField[J, K] > 0) and (FField[J, K] <> FField[J, I]) then Inc(K);
			if K < I then begin
				FField[J, K] := FField[J, K] + FField[J, I];
				if FField[J, K] > FField[J, I] then FScore := FScore + FField[J, K];
				FField[J, I] := 0;
				if not Result then Result := True;
			end;
		end;
end;

function TGame.ShiftRight: Boolean;
var
	I, J, K: Byte;
begin
	Result := False;
	for I := Size - 2 downto 0 do
		for J := 0 to Size - 1 do begin
			if FField[J, I] = 0 then Continue;
			K := I;
			repeat
				Inc(K);
			until (K = Size - 1) or (FField[J, K] > 0);
			if (FField[J, K] > 0) and (FField[J, K] <> FField[J, I]) then Dec(K);
			if K > I then begin
				FField[J, K] := FField[J, K] + FField[J, I];
				if FField[J, K] > FField[J, I] then FScore := FScore + FField[J, K];
				FField[J, I] := 0;
				if not Result then Result := True;
			end;
		end;
end;

function TGame.ShiftUp: Boolean;
var
	I, J, K: Byte;
begin
	Result := False;
	for I := 1 to Size - 1 do
		for J := 0 to Size - 1 do begin
			if FField[I, J] = 0 then Continue;
			K := I;
			repeat
				Dec(K);
			until (K = 0) or (FField[K, J] > 0);
			if (FField[K, J] > 0) and (FField[K, J] <> FField[I, J]) then Inc(K);
			if K < I then begin
				FField[K, J] := FField[K, J] + FField[I, J];
				if FField[K, J] > FField[I, J] then FScore := FScore + FField[K, J];
				FField[I, J] := 0;
				if not Result then Result := True;
			end;
		end;
end;

end.

