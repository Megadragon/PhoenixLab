unit uMain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, ComCtrls, StdCtrls, Menus, Buttons, ToolWin, ExtCtrls;

type
	TfrmMain = class(TForm)
		mmuMenuBar: TMainMenu;
		MenuFile: TMenuItem;
		MFileExit: TMenuItem;
		MenuHelp: TMenuItem;
		MHelpAbout: TMenuItem;
		tlbRemovableDisks: TToolBar;
		sttChooseDisk: TStaticText;
		cbbRemovableDisks: TComboBox;
		gpbWormSlayer: TGroupBox;
		lblWormSlayer: TLabel;
		spbWSDCUp: TSpeedButton;
		spbWSDCDown: TSpeedButton;
		gpbAntiRecycler: TGroupBox;
		lblAntiRecycler: TLabel;
		spbARDCUp: TSpeedButton;
		spbARDCDown: TSpeedButton;
		bbnAbout: TBitBtn;
		bbnClose: TBitBtn;
		stbStatusLine: TStatusBar;
		tmrScanDrives: TTimer;
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure FormCreate(Sender: TObject);
		procedure MFileExitClick(Sender: TObject);
		procedure MHelpAboutClick(Sender: TObject);
		procedure cbbRemovableDisksSelect(Sender: TObject);
		procedure tmrScanDrivesTimer(Sender: TObject);
		procedure spbWSDCUpClick(Sender: TObject);
		procedure spbWSDCDownClick(Sender: TObject);
		procedure spbARDCUpClick(Sender: TObject);
		procedure spbARDCDownClick(Sender: TObject);
	public
		procedure SetDefConLevel(AModule: TGroupBox; const ALevel: Byte);
	end;

var
	frmMain: TfrmMain;

implementation

uses uAbout, uWormSlayer, uAntiRecycler;

const
	DEFCON_1 = clWhite;
	DEFCON_2 = clRed;
	DEFCON_3 = clYellow;
	DEFCON_4 = clLime;
	DEFCON_5 = clBlue;

resourcestring
	STRING_DEFCON_1 = 'Код 1: не удаётся удалить вирус; вероятно, компьютер заражён.';
	STRING_DEFCON_2 = 'Код 2: обнаружен вирус.';
	STRING_DEFCON_3 = 'Код 3: ни вируса, ни агента не обнаружено.';
	STRING_DEFCON_4 = 'Код 4: снята невидимость; вероятно, агента пытались удалить.';
	STRING_DEFCON_5 = 'Код 5: всё хорошо.';

var
	TargetDrive: string;

{$R *.dfm}

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	WormSlayer.Free;
	AntiRecycler.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
	WormSlayer := TWormSlayer.Create;
	AntiRecycler := TAntiRecycler.Create;
end;

procedure TfrmMain.MFileExitClick(Sender: TObject);
begin
	Close;
end;

procedure TfrmMain.MHelpAboutClick(Sender: TObject);
begin
	AboutBox.ShowModal;
end;

procedure TfrmMain.cbbRemovableDisksSelect(Sender: TObject);
begin
	TargetDrive := cbbRemovableDisks.Items[cbbRemovableDisks.ItemIndex];
	WormSlayer.Scan(TargetDrive);
	SetDefConLevel(gpbWormSlayer, WormSlayer.DefCon);
	AntiRecycler.Scan(TargetDrive);
	SetDefConLevel(gpbAntiRecycler, AntiRecycler.DefCon);
end;

procedure TfrmMain.tmrScanDrivesTimer(Sender: TObject);
var
	C: Char;
	DriveRoot: string;
	Temp: TStringList;
begin
	Temp := TStringList.Create;
	try
		for C := 'A' to 'Z' do begin
			DriveRoot := C + ':\';
			if GetDriveType(PChar(DriveRoot)) = 2 then Temp.Append(DriveRoot);
		end;
		if not cbbRemovableDisks.Items.Equals(Temp) then cbbRemovableDisks.Items.Assign(Temp);
	finally
		Temp.Free;
	end;
end;

procedure TfrmMain.spbWSDCUpClick(Sender: TObject);
begin
	with WormSlayer do case DefCon of
		4: DeleteAgent;
		5: ShowAgent;
		else;
	end;
	SetDefConLevel(gpbWormSlayer, WormSlayer.DefCon);
end;

procedure TfrmMain.spbWSDCDownClick(Sender: TObject);
begin
	with WormSlayer do case DefCon of
		1, 2: ExterminateVirus;
		3: CreateAgent;
		4: HideAgent;
		else;
	end;
	SetDefConLevel(gpbWormSlayer, WormSlayer.DefCon);
end;

procedure TfrmMain.spbARDCUpClick(Sender: TObject);
begin
	with AntiRecycler do case DefCon of
		4: DeleteAgent;
		5: ShowAgent;
		else;
	end;
	SetDefConLevel(gpbAntiRecycler, AntiRecycler.DefCon);
end;

procedure TfrmMain.spbARDCDownClick(Sender: TObject);
begin
	with AntiRecycler do case DefCon of
		1, 2: ExterminateVirus;
		3: CreateAgent;
		4: HideAgent;
		else;
	end;
	SetDefConLevel(gpbAntiRecycler, AntiRecycler.DefCon);
end;

procedure TfrmMain.SetDefConLevel(AModule: TGroupBox; const ALevel: Byte);
begin
	with AModule do begin
		Tag := ALevel;
		case Tag of
			1: begin
				Color := DEFCON_1;
				Hint := STRING_DEFCON_1;
			end;
			2: begin
				Color := DEFCON_2;
				Hint := STRING_DEFCON_2;
			end;
			3: begin
				Color := DEFCON_3;
				Hint := STRING_DEFCON_3;
			end;
			4: begin
				Color := DEFCON_4;
				Hint := STRING_DEFCON_4;
			end;
			5: begin
				Color := DEFCON_5;
				Hint := STRING_DEFCON_5;
			end;
		end;
	end;
end;

end.

