unit uMain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, ExtCtrls, uOKRightDlg, uXO, XPMan;

type
	TfrmMain = class(TForm)
		shpBackground: TShape;
		Timer: TTimer;
		XPManifest: TXPManifest;
		procedure FormCreate(Sender: TObject);
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure TimerTimer(Sender: TObject);
	private
		FField: TField;
	public
		property Field: TField read FField write FField;
	end;

var
	frmMain: TfrmMain;

implementation

uses Math;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
	Field := TField.Create;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Field.Free;
end;

procedure TfrmMain.TimerTimer(Sender: TObject);
	var CompTurn: Byte;
begin
	if Field.IsEndOfGame > 0 then begin
		if Player = 1 then ShowMessage('Первый игрок (крестики) выиграл!')
		else ShowMessage('Второй игрок (нолики) выиграл!');
		Timer.Enabled := False;
	end;
	if Turn = 9 then begin
		ShowMessage('Ничья');
		Timer.Enabled := False;
	end;
	{case Mode of
		2: begin
			if Player = 1 then Exit;
			CompTurn := Field.IsChanceToWin;
			if CompTurn = 0 then CompTurn := Field.IsDangerToLose;
			if CompTurn = 0 then CompTurn := Field.CPU;
			if CompTurn = 0 then
				repeat CompTurn := RandomRange(1, 9)
				until Field.GetCell(CompTurn) = 0;
			Field.FCells[CompTurn].OnClick(Field.FCells[CompTurn]);
		end;
		3: begin
			CompTurn := Field.IsChanceToWin;
			if CompTurn = 0 then CompTurn := Field.IsDangerToLose;
			if CompTurn = 0 then CompTurn := Field.CPU;
			if CompTurn = 0 then
				repeat CompTurn := RandomRange(1, 9)
				until Field.GetCell(CompTurn) = 0;
			Field.FCells[CompTurn].OnClick(Field.FCells[CompTurn]);
		end;
	end;}
end;

end.