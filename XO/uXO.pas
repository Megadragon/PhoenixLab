unit uXO;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, ExtCtrls;

type
	TField = class
	private
		FCells: array[1..9] of TImage;
	public
		constructor Create;
		destructor Destroy; override;
		function CPU: Byte;
		function GetCell(const Number: Byte): Byte;
		function IsChanceToWin: Byte;
		function IsDangerToLose: Byte;
		function IsEndOfGame: Byte;
		procedure FillPlayerTurn(Sender: TObject);
		procedure SetCell(const Number, Value: Byte);
	end;

var
	Mode: Byte;
	Player: Byte;
	Turn: Byte;

implementation

uses Math, uMain;

function TField.CPU: Byte;
var
	Opponent: Byte;
begin
	Result := 0;
	if Player = 1 then Opponent := 2 else Opponent := 1;

	case Turn of
		0: Result := 5;
		1: if GetCell(5) <> Opponent then Result := 5 else
			repeat Result := RandomRange(1, 9)
			until Odd(Result) and (Result <> 5);
		2: if GetCell(1) = Opponent then Result := 9 else
			if GetCell(3) = Opponent then Result := 7 else
			if GetCell(7) = Opponent then Result := 3 else
			if GetCell(9) = Opponent then Result := 1 else
			if GetCell(2) = Opponent then
				repeat Result := RandomRange(7, 9)
				until Result <> 8
			else
			if GetCell(4) = Opponent then
				repeat Result := RandomRange(3, 9)
				until (Result = 3) or (Result = 9)
			else
			if GetCell(6) = Opponent then
				repeat Result := RandomRange(1, 7)
				until (Result = 1) or (Result = 7)
			else
			if GetCell(8) = Opponent then
				repeat Result := RandomRange(1, 3)
				until Result <> 2;
		3: if (GetCell(1) = GetCell(9)) and (GetCell(1) <> 0)
				or (GetCell(3) = GetCell(7)) and (GetCell(3) <> 0)
			then
				repeat Result := RandomRange(2, 8)
				until not Odd(Result) and (GetCell(Result) = 0)
			else
				if (GetCell(1) * GetCell(5) * GetCell(9) <> 0)
					or (GetCell(3) * GetCell(5) * GetCell(7) <> 0)
				then
					repeat Result := RandomRange(1, 9)
					until Odd(Result) and (GetCell(Result) = 0);
	end;
end;

constructor TField.Create;
var
	I: Byte;
begin
	for I := 1 to 9 do begin
		FCells[I] := TImage.Create(frmMain);
		with FCells[I] do begin
			Parent := frmMain;
			Width := 100;
			Height := 100;
			Canvas.Brush.Color := clWhite;
			if I >= 7 then Top := 10
			else if I >= 4 then Top := 115
			else Top := 220;
			case I mod 3 of
				1: Left := 10;
				2: Left := 115;
				0: Left := 220;
			end;
			Tag := 0;
			Name := 'Cell' + IntToStr(I);
			OnClick := FillPlayerTurn;
		end;
	end;
end;

destructor TField.Destroy;
var
	I: Byte;
begin
	for I := 1 to 9 do FCells[I].Free;
	inherited;
end;

procedure TField.FillPlayerTurn(Sender: TObject);
var
	CellNum: Byte;
begin
	if not (Sender is TImage) then Exit;
	CellNum := StrToInt((Sender as TImage).Name[5]);
	if GetCell(CellNum) = 0 then SetCell(CellNum, Player) else Exit;
	with (Sender as TImage).Canvas do
		if Player = 1 then begin
			Pen.Color := clBlue;
			MoveTo(10, 10);
			LineTo(90, 90);
			MoveTo(90, 10);
			LineTo(10, 90);
		end else begin
			Pen.Color := clRed;
			Ellipse(10, 10, 90, 90);
		end;
	Inc(Turn);
	if Player = 1 then Player := 2 else Player := 1;
end;

function TField.GetCell(const Number: Byte): Byte;
begin
	Result := FCells[Number].Tag;
end;

function TField.IsChanceToWin: Byte;
begin
	Result := 0;

	if (GetCell(1) = 0) and (GetCell(2) = Player) and (GetCell(3) = Player)
		or (GetCell(1) = 0) and (GetCell(4) = Player) and (GetCell(7) = Player)
		or (GetCell(1) = 0) and (GetCell(5) = Player) and (GetCell(9) = Player)
	then Result := 1;
	if (GetCell(3) = 0) and (GetCell(1) = Player) and (GetCell(2) = Player)
		or (GetCell(3) = 0) and (GetCell(5) = Player) and (GetCell(7) = Player)
		or (GetCell(3) = 0) and (GetCell(6) = Player) and (GetCell(9) = Player)
	then Result := 3;
	if (GetCell(7) = 0) and (GetCell(1) = Player) and (GetCell(4) = Player)
		or (GetCell(7) = 0) and (GetCell(3) = Player) and (GetCell(5) = Player)
		or (GetCell(7) = 0) and (GetCell(8) = Player) and (GetCell(9) = Player)
	then Result := 7;
	if (GetCell(9) = 0) and (GetCell(1) = Player) and (GetCell(5) = Player)
		or (GetCell(9) = 0) and (GetCell(3) = Player) and (GetCell(6) = Player)
		or (GetCell(9) = 0) and (GetCell(7) = Player) and (GetCell(8) = Player)
	then Result := 9;

	if (GetCell(2) = 0) and (GetCell(1) = Player) and (GetCell(3) = Player)
		or (GetCell(1) = 0) and (GetCell(5) = Player) and (GetCell(8) = Player)
	then Result := 2;
	if (GetCell(4) = 0) and (GetCell(1) = Player) and (GetCell(7) = Player)
		or (GetCell(4) = 0) and (GetCell(5) = Player) and (GetCell(6) = Player)
	then Result := 4;
	if (GetCell(6) = 0) and (GetCell(4) = Player) and (GetCell(5) = Player)
		or (GetCell(6) = 0) and (GetCell(3) = Player) and (GetCell(9) = Player)
	then Result := 6;
	if (GetCell(8) = 0) and (GetCell(2) = Player) and (GetCell(5) = Player)
		or (GetCell(8) = 0) and (GetCell(7) = Player) and (GetCell(9) = Player)
	then Result := 8;

	if (GetCell(5) = 0) and (GetCell(1) = Player) and (GetCell(9) = Player)
		or (GetCell(5) = 0) and (GetCell(3) = Player) and (GetCell(7) = Player)
		or (GetCell(5) = 0) and (GetCell(2) = Player) and (GetCell(8) = Player)
		or (GetCell(5) = 0) and (GetCell(4) = Player) and (GetCell(6) = Player)
	then Result := 5;
end;

function TField.IsDangerToLose: Byte;
var
	Opponent: Byte;
begin
	Result := 0;
	if Player = 1 then Opponent := 2 else Opponent := 1;

	if (GetCell(1) = 0) and (GetCell(2) = Opponent) and (GetCell(3) = Opponent)
		or (GetCell(1) = 0) and (GetCell(4) = Opponent) and (GetCell(7) = Opponent)
		or (GetCell(1) = 0) and (GetCell(5) = Opponent) and (GetCell(9) = Opponent)
	then Result := 1;
	if (GetCell(3) = 0) and (GetCell(1) = Opponent) and (GetCell(2) = Opponent)
		or (GetCell(3) = 0) and (GetCell(5) = Opponent) and (GetCell(7) = Opponent)
		or (GetCell(3) = 0) and (GetCell(6) = Opponent) and (GetCell(9) = Opponent)
	then Result := 3;
	if (GetCell(7) = 0) and (GetCell(1) = Opponent) and (GetCell(4) = Opponent)
		or (GetCell(7) = 0) and (GetCell(3) = Opponent) and (GetCell(5) = Opponent)
		or (GetCell(7) = 0) and (GetCell(8) = Opponent) and (GetCell(9) = Opponent)
	then Result := 7;
	if (GetCell(9) = 0) and (GetCell(1) = Opponent) and (GetCell(5) = Opponent)
		or (GetCell(9) = 0) and (GetCell(3) = Opponent) and (GetCell(6) = Opponent)
		or (GetCell(9) = 0) and (GetCell(7) = Opponent) and (GetCell(8) = Opponent)
	then Result := 9;

	if (GetCell(2) = 0) and (GetCell(1) = Opponent) and (GetCell(3) = Opponent)
		or (GetCell(1) = 0) and (GetCell(5) = Opponent) and (GetCell(8) = Opponent)
	then Result := 2;
	if (GetCell(4) = 0) and (GetCell(1) = Opponent) and (GetCell(7) = Opponent)
		or (GetCell(4) = 0) and (GetCell(5) = Opponent) and (GetCell(6) = Opponent)
	then Result := 4;
	if (GetCell(6) = 0) and (GetCell(4) = Opponent) and (GetCell(5) = Opponent)
		or (GetCell(6) = 0) and (GetCell(3) = Opponent) and (GetCell(9) = Opponent)
	then Result := 6;
	if (GetCell(8) = 0) and (GetCell(2) = Opponent) and (GetCell(5) = Opponent)
		or (GetCell(8) = 0) and (GetCell(7) = Opponent) and (GetCell(9) = Opponent)
	then Result := 8;

	if (GetCell(5) = 0) and (GetCell(1) = Opponent) and (GetCell(9) = Opponent)
		or (GetCell(5) = 0) and (GetCell(3) = Opponent) and (GetCell(7) = Opponent)
		or (GetCell(5) = 0) and (GetCell(2) = Opponent) and (GetCell(8) = Opponent)
		or (GetCell(5) = 0) and (GetCell(4) = Opponent) and (GetCell(6) = Opponent)
	then Result := 5;
end;

function TField.IsEndOfGame: Byte;
begin
	Result := 0;

	if (GetCell(1) = 1) and (GetCell(2) = 1) and (GetCell(3) = 1) then Result := 1;
	if (GetCell(4) = 1) and (GetCell(5) = 1) and (GetCell(6) = 1) then Result := 1;
	if (GetCell(7) = 1) and (GetCell(8) = 1) and (GetCell(9) = 1) then Result := 1;
	if (GetCell(1) = 1) and (GetCell(4) = 1) and (GetCell(7) = 1) then Result := 1;
	if (GetCell(2) = 1) and (GetCell(5) = 1) and (GetCell(8) = 1) then Result := 1;
	if (GetCell(3) = 1) and (GetCell(6) = 1) and (GetCell(9) = 1) then Result := 1;
	if (GetCell(1) = 1) and (GetCell(5) = 1) and (GetCell(9) = 1) then Result := 1;
	if (GetCell(3) = 1) and (GetCell(5) = 1) and (GetCell(7) = 1) then Result := 1;

	if (GetCell(1) = 2) and (GetCell(2) = 2) and (GetCell(3) = 2) then Result := 2;
	if (GetCell(4) = 2) and (GetCell(5) = 2) and (GetCell(6) = 2) then Result := 2;
	if (GetCell(7) = 2) and (GetCell(8) = 2) and (GetCell(9) = 2) then Result := 2;
	if (GetCell(1) = 2) and (GetCell(4) = 2) and (GetCell(7) = 2) then Result := 2;
	if (GetCell(2) = 2) and (GetCell(5) = 2) and (GetCell(8) = 2) then Result := 2;
	if (GetCell(3) = 2) and (GetCell(6) = 2) and (GetCell(9) = 2) then Result := 2;
	if (GetCell(1) = 2) and (GetCell(5) = 2) and (GetCell(9) = 2) then Result := 2;
	if (GetCell(3) = 2) and (GetCell(5) = 2) and (GetCell(7) = 2) then Result := 2;
end;

procedure TField.SetCell(const Number, Value: Byte);
begin
	FCells[Number].Tag := Value;
end;

initialization

	Mode := 0;
	Player := 0;
	Turn := 0;

end.
