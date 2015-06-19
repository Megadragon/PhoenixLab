unit uStats;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
	TPlayer = record
		Name: string[32];
		Target: Cardinal;
		Size: Byte;
		MovesCount: Cardinal;
		Score: Cardinal;
	end;

	TfrmStats = class(TForm)
		bbnOK: TBitBtn;
		ltvUsers: TListView;
		procedure FormCreate(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure ltvUsersCompare(Sender: TObject; Item1, Item2: TListItem;
			Data: Integer; var Compare: Integer);
	public
		procedure LoadUsers(const AFilename: string);
		procedure SaveUsers(const AFilename: string);
	end;

var
	frmStats: TfrmStats;

implementation

uses IniFiles;

const
	sPlayersFileName = 'Players.dat';

{$R *.dfm}

procedure TfrmStats.FormCreate(Sender: TObject);
begin
	LoadUsers(GetCurrentDir + '\' + sPlayersFileName);
end;

procedure TfrmStats.FormDestroy(Sender: TObject);
begin
	SaveUsers(GetCurrentDir + '\' + sPlayersFileName);
end;

procedure TfrmStats.FormShow(Sender: TObject);
begin
	ltvUsers.AlphaSort;
end;

procedure TfrmStats.ltvUsersCompare(Sender: TObject; Item1,
	Item2: TListItem; Data: Integer; var Compare: Integer);
begin
	Compare := StrToInt(Item2.SubItems[1]) - StrToInt(Item1.SubItems[1]);
end;

procedure TfrmStats.LoadUsers(const AFilename: string);
var
	fPlayers: file of TPlayer;
	CurrPlayer: TPlayer;
begin
	AssignFile(fPlayers, AFilename);
	Reset(fPlayers);
	try
		while not Eof(fPlayers) do begin
			Read(fPlayers, CurrPlayer);
			with ltvUsers.Items.Add do begin
				Caption := CurrPlayer.Name;
				SubItems.Add(IntToStr(CurrPlayer.Target));
				SubItems.Add(IntToStr(CurrPlayer.Size));
				SubItems.Add(IntToStr(CurrPlayer.MovesCount));
				SubItems.Add(IntToStr(CurrPlayer.Score));
			end;
		end;
	finally
		CloseFile(fPlayers);
	end;
end;

procedure TfrmStats.SaveUsers(const AFilename: string);
var
	fPlayers: file of TPlayer;
	Temp: TPlayer;
	I: Cardinal;
begin
	AssignFile(fPlayers, AFilename);
	Rewrite(fPlayers);
	try
		if ltvUsers.Items.Count > 0 then
			for I := 0 to ltvUsers.Items.Count - 1 do begin
				Temp.Name := ltvUsers.Items[I].Caption;
				Temp.Target := StrToInt(ltvUsers.Items[I].SubItems[0]);
				Temp.Size := StrToInt(ltvUsers.Items[I].SubItems[1]);
				Temp.MovesCount := StrToInt(ltvUsers.Items[I].SubItems[2]);
				Temp.Score := StrToInt(ltvUsers.Items[I].SubItems[3]);
				Write(fPlayers, Temp);
			end;
	finally
		CloseFile(fPlayers);
	end;
end;

end.
