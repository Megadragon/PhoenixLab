unit uMain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, ExtCtrls, ComCtrls, Grids, Menus, ActnMan, ActnList, StdActns,
	XPStyleActnCtrls, uGame;

type
	TfrmMain = class(TForm)
		mmuMenuBar: TMainMenu;
		MenuGame: TMenuItem;
		MGameNew: TMenuItem;
		MGameSep1: TMenuItem;
		MGameStats: TMenuItem;
		MGameParams: TMenuItem;
		MGameChangeSkin: TMenuItem;
		MGameSep2: TMenuItem;
		MGameExit: TMenuItem;
		MenuHelp: TMenuItem;
		MHelpShow: TMenuItem;
		MHelpAbout: TMenuItem;
		atmActions: TActionManager;
		acnNew: TAction;
		acnStats: TAction;
		acnParams: TAction;
		acnChangeSkin: TAction;
		acnExit: TFileExit;
		acnHelp: TAction;
		acnAbout: TAction;
		StatusLine: TStatusBar;
		dwgField: TDrawGrid;
		acnDown: TAction;
		acnLeft: TAction;
		acnRight: TAction;
		acnUp: TAction;
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
		procedure FormCreate(Sender: TObject);
		procedure acnNewExecute(Sender: TObject);
		procedure acnStatsExecute(Sender: TObject);
		procedure acnParamsExecute(Sender: TObject);
		procedure acnChangeSkinExecute(Sender: TObject);
		procedure acnHelpExecute(Sender: TObject);
		procedure acnAboutExecute(Sender: TObject);
		procedure acnDownExecute(Sender: TObject);
		procedure acnLeftExecute(Sender: TObject);
		procedure acnRightExecute(Sender: TObject);
		procedure acnUpExecute(Sender: TObject);
		procedure dwgFieldDrawCell(Sender: TObject; ACol, ARow: Integer;
			Rect: TRect; State: TGridDrawState);
	private
		Game: TGame;
		procedure CheckEndOfGame;
		procedure DoMove(const ADirection: TDirections);
		procedure GameOver;
	public
		IsContinue: Boolean;
		function GetApplicationPath: string;
		function QuestionBox(AText: string): Boolean;
		procedure RefreshStatus;
		procedure ResizeGameField(const NewSize: Byte);
		procedure SaveAndFree;
	end;

var
	frmMain: TfrmMain;
	idxMode, Size: Byte;
	Target: Cardinal;
	CurrentSkin: string;
	IsLoadOnStart, IsSaveOnExit: Boolean;

implementation

uses IniFiles, uParams, uStats, uAbout, uSkins;

const
	sIniFileName = 'Settings.ini';
	sSaveFileName = '2048.sav';

{$R *.dfm}
{$R WindowsXP.res}

function TfrmMain.GetApplicationPath: string;
begin
	Result := ExtractFilePath(Application.ExeName);
end;

function TfrmMain.QuestionBox(AText: string): Boolean;
begin
	Result := MessageBox(Handle, PChar(AText), PChar(Application.Title), MB_YESNO or MB_ICONQUESTION) = ID_YES;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
	if (Game <> nil) and (IsSaveOnExit or
		QuestionBox('Игра не завершена. Сохранить её?'))
	then Game.SaveToFile(GetApplicationPath + sSaveFileName);
	with TIniFile.Create(GetApplicationPath + sIniFileName) do try
		WriteInteger('Settings', 'ModeIndex', idxMode);
		WriteInteger('Settings', 'Size', Size);
		WriteInteger('Settings', 'Target', Target);
		WriteString('Settings', 'Skin', CurrentSkin);
		WriteBool('Settings', 'LoadOnStart', IsLoadOnStart);
		WriteBool('Settings', 'SaveOnExit', IsSaveOnExit);
	finally
		Free;
	end;
	FreeAndNil(Game);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
	grtSelection: TGridRect;
begin
	with grtSelection do begin
		Bottom := -1;
		Left := -1;
		Right := -1;
		Top := -1;
	end;
	dwgField.DoubleBuffered := True;
	dwgField.Selection := grtSelection;
	with TIniFile.Create(GetApplicationPath + sIniFileName) do try
		idxMode := ReadInteger('Settings', 'ModeIndex', 1);
		Size := ReadInteger('Settings', 'Size', 4);
		Target := ReadInteger('Settings', 'Target', 2048);
		CurrentSkin := ReadString('Settings', 'Skin', 'Standard');
		IsLoadOnStart := ReadBool('Settings', 'LoadOnStart', False);
		IsSaveOnExit := ReadBool('Settings', 'SaveOnExit', False);
	finally
		Free;
	end;
	if FileExists(GetApplicationPath + sSaveFileName) and (IsLoadOnStart or
		QuestionBox('Найдено сохранение старой игры. Загрузить его?'))
	then begin
		Game := TGame.Create(GetApplicationPath + sSaveFileName);
		RefreshStatus;
	end;
end;

procedure TfrmMain.acnNewExecute(Sender: TObject);
begin
	if Game <> nil then
		if QuestionBox('Предыдущая игра не окончена. Продолжить её?')
		then Exit else GameOver;
	case idxMode of
		{ TODO 2 -oMegadragon : Релизовать классический режим }
		0: MessageBox(Handle, 'Классический режим не реализован.', '2048', MB_OK or MB_ICONINFORMATION);
		1: Game := TGame.Create(Size, Target);
	else EListError.Create('Game mode doesn''t select!');
	end;
	ResizeGameField(Game.Size);
	IsContinue := False;
	RefreshStatus;
	dwgField.Refresh;
end;

procedure TfrmMain.acnStatsExecute(Sender: TObject);
begin
	frmStats.ShowModal;
end;

procedure TfrmMain.acnParamsExecute(Sender: TObject);
begin
	with dlgParams do if ShowModal = mrOk then begin
		Size := speSize.Value;
		Target := StrToInt(cbbTarget.Text);
		IsLoadOnStart := ckbLoadOnStart.Checked;
		IsSaveOnExit := ckbSaveOnExit.Checked;
		if (idxMode <> rdgMode.ItemIndex) and QuestionBox('Игра будет закончена. Продолжить?')
		then begin
			GameOver;
			idxMode := rdgMode.ItemIndex;
			acnNew.Execute;
		end;
	end;
end;

procedure TfrmMain.acnChangeSkinExecute(Sender: TObject);
begin
	with dlgSkins do if ShowModal = mrOk then
		CurrentSkin := lsbSkinNames.Items[lsbSkinNames.ItemIndex];
end;

procedure TfrmMain.acnHelpExecute(Sender: TObject);
begin
	{ TODO 3 -oMegadragon : Create and show help }
end;

procedure TfrmMain.acnAboutExecute(Sender: TObject);
begin
	AboutBox.ShowModal;
end;

procedure TfrmMain.acnDownExecute(Sender: TObject);
begin
	DoMove(dnDown);
end;

procedure TfrmMain.acnLeftExecute(Sender: TObject);
begin
	DoMove(dnLeft);
end;

procedure TfrmMain.acnRightExecute(Sender: TObject);
begin
	DoMove(dnRight);
end;

procedure TfrmMain.acnUpExecute(Sender: TObject);
begin
	DoMove(dnUp);
end;

procedure TfrmMain.dwgFieldDrawCell(Sender: TObject; ACol, ARow: Integer;
	Rect: TRect; State: TGridDrawState);
var
	bmpCurrImage: TBitmap;
	sFilename: string;
	Value: Cardinal;
begin
	if Game = nil then inherited else begin
		Value := Game.GetCell(ARow, ACol);
		sFilename := GetApplicationPath + CurrentSkin + '\' + IntToStr(Value) + '.bmp';
		if FileExists(sFilename) then begin
			bmpCurrImage := TBitmap.Create;
			try
				bmpCurrImage.LoadFromFile(sFilename);
				dwgField.Canvas.Draw(Rect.Left, Rect.Top, bmpCurrImage);
			finally
				bmpCurrImage.Free;
			end;
		end else with dwgField.Canvas do begin
			case Value of
				0: Brush.Color := $B4C1CD;
				2: Brush.Color := $DAE4EE;
				4: Brush.Color := $C8E0ED;
				8: Brush.Color := $79B1F2;
				16: Brush.Color := $6395F5;
				32: Brush.Color := $5F7CF6;
				64: Brush.Color := $3B5EF6;
				128: Brush.Color := $72CFED;
				256: Brush.Color := $61CCED;
				512: Brush.Color := $50C8ED;
				1024: Brush.Color := $3FC5ED;
				2048: Brush.Color := $2EC2ED;
				else Brush.Color := $323A3C;
			end;
			FillRect(Rect);
			if Value = 0 then Exit;
			Font.Name := 'Arial';
			case Value of
				0..64: Font.Size := 55;
				128..512: Font.Size := 45;
				1024..2048: Font.Size := 35;
				4096..8192: Font.Size := 30;
				16384..65536: Font.Size := 25;
				131072..524288: Font.Size := 20;
			else Font.Size := 15;
			end;
			Font.Style := [fsBold];
			if Value < 8 then Font.Color := $656E77 else Font.Color := $F2F6F9;
			TextOut((Rect.Left + Rect.Right - TextWidth(IntToStr(Value))) div 2,
				(Rect.Top + Rect.Bottom - TextHeight(IntToStr(Value))) div 2, IntToStr(Value));
		end;
	end;
end;

procedure TfrmMain.CheckEndOfGame;
begin
	if not IsContinue and Game.IsWin then begin
		IsContinue := QuestionBox('Вы выиграли! Хотите ли Вы продолжить игру?');
		if not IsContinue then GameOver;
	end else if Game.IsLose then GameOver;
end;

procedure TfrmMain.DoMove(const ADirection: TDirections);
begin
	Game.Shift(ADirection);
	dwgField.Refresh;
	CheckEndOfGame;
	RefreshStatus;
end;

procedure TfrmMain.GameOver;
var
	Username: string;
begin
	if Game = nil then raise EInvalidContainer.CreateFmt('Game = %x', [Game]);
	repeat
		Username := InputBox('2048', 'Игра закончена. Введите своё имя:', 'Player' + IntToStr(frmStats.ltvUsers.Items.Count));
	until Username <> '';
	with frmStats.ltvUsers.Items.Add do begin
		Caption := Username;
		SubItems.Add(IntToStr(Game.Target));
		SubItems.Add(IntToStr(Game.Size));
		SubItems.Add(IntToStr(Game.MovesCount));
		SubItems.Add(IntToStr(Game.Score));
	end;
	FreeAndNil(Game);
end;

procedure TfrmMain.RefreshStatus;
begin
	if Game <> nil then with StatusLine do begin
		Panels[1].Text := 'Ходов: ' + IntToStr(Game.MovesCount);
		Panels[2].Text := 'Очки: ' + IntToStr(Game.Score);
	end else raise EInvalidContainer.CreateFmt('Game = %x', [Game]);
end;

procedure TfrmMain.ResizeGameField(const NewSize: Byte);
begin
	with dwgField do begin
		ColCount := NewSize;
		RowCount := NewSize;
		Self.ClientHeight := DefaultRowHeight * RowCount + GridLineWidth * (RowCount - 1) + StatusLine.Height;
		Self.ClientWidth := DefaultColWidth * ColCount + GridLineWidth * (ColCount - 1);
	end;
end;

procedure TfrmMain.SaveAndFree;
begin
	if Game <> nil then begin
		Game.SaveToFile(GetApplicationPath + sSaveFileName);
		FreeAndNil(Game);
	end else raise EInvalidContainer.CreateFmt('Game = %x', [Game]);
end;

end.

