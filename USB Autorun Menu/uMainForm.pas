unit uMainForm;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, ExtCtrls, StdCtrls, ShellAPI, XPMan;

type
	TMainForm = class(TForm)
		imgAIDA64: TImage;
		imgCCleaner: TImage;
		imgDHD_HQ: TImage;
		imgFlashProjector: TImage;
		imgHPlanet: TImage;
		imgNotepad: TImage;
		imgOpera: TImage;
		imgSGCSim: TImage;
		imgSumatraPDF: TImage;
		imgUTool: TImage;
		imgWinRAR: TImage;
		imgUA2003C: TImage;
		btnAIDA64: TButton;
		btnCCleaner: TButton;
		btnDHD_HQ: TButton;
		btnFlashProjector: TButton;
		btnHPlanet: TButton;
		btnNotepad: TButton;
		btnOpera: TButton;
		btnSGCSim: TButton;
		btnSumatraPDF: TButton;
		btnUTool: TButton;
		btnWinRAR: TButton;
		btnUA2003C: TButton;
		XPM: TXPManifest;
		procedure btnAIDA64Click(Sender: TObject);
		procedure btnCCleanerClick(Sender: TObject);
		procedure btnDHD_HQClick(Sender: TObject);
		procedure btnFlashProjectorClick(Sender: TObject);
		procedure btnHPlanetClick(Sender: TObject);
		procedure btnNotepadClick(Sender: TObject);
		procedure btnOperaClick(Sender: TObject);
		procedure btnSGCSimClick(Sender: TObject);
		procedure btnSumatraPDFClick(Sender: TObject);
		procedure btnUToolClick(Sender: TObject);
		procedure btnWinRARClick(Sender: TObject);
		procedure btnUA2003CClick(Sender: TObject);
	end;

var
	MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.btnAIDA64Click(Sender: TObject);
begin
	ShellExecute(Handle, 'Open', '\Program Files\AIDA64 Extreme Edition\aida64.exe', '', '', SW_SHOW);
	Close;
end;

procedure TMainForm.btnCCleanerClick(Sender: TObject);
begin
	ShellExecute(Handle, 'Open', '\Program Files\CCleaner\CCleaner.exe', '', '', SW_SHOW);
	Close;
end;

procedure TMainForm.btnDHD_HQClick(Sender: TObject);
begin
	ShellExecute(Handle, 'Open', '\Program Files\DHD_HQ\DHD_HQ.exe', '', '', SW_SHOW);
	Close;
end;

procedure TMainForm.btnFlashProjectorClick(Sender: TObject);
begin
	ShellExecute(Handle, 'Open', '\Program Files\Adobe Flash Projector\FlashProjector10.EXE', '', '', SW_SHOW);
	Close;
end;

procedure TMainForm.btnHPlanetClick(Sender: TObject);
begin
	ShellExecute(Handle, 'Open', '\Program Files\HPlanet\HomePlanet.exe', '', '', SW_SHOW);
	Close;
end;

procedure TMainForm.btnNotepadClick(Sender: TObject);
begin
	ShellExecute(Handle, 'Open', '\Program Files\Notepad++\notepad++.exe', '', '', SW_SHOW);
	Close;
end;

procedure TMainForm.btnOperaClick(Sender: TObject);
begin
	ShellExecute(Handle, 'Open', '\Program Files\Opera@USB\opera.exe', '', '', SW_SHOW);
	Close;
end;

procedure TMainForm.btnSGCSimClick(Sender: TObject);
begin
	ShellExecute(Handle, 'Open', '\Program Files\SGCSim v5.0.2\SGCSim.exe', '', '', SW_SHOW);
	Close;
end;

procedure TMainForm.btnSumatraPDFClick(Sender: TObject);
begin
	ShellExecute(Handle, 'Open', '\Program Files\Sumatra PDF\SumatraPDF.exe', '', '', SW_SHOW);
	Close;
end;

procedure TMainForm.btnUToolClick(Sender: TObject);
begin
	ShellExecute(Handle, 'Open', '\Program Files\Uninstall Tool\UninstallTool.exe', '', '', SW_SHOW);
	Close;
end;

procedure TMainForm.btnWinRARClick(Sender: TObject);
begin
	ShellExecute(Handle, 'Open', '\Program Files\WinRAR\WinRAR.exe', '', '', SW_SHOW);
	Close;
end;

procedure TMainForm.btnUA2003CClick(Sender: TObject);
begin
	ShellExecute(Handle, 'Open', '\Program Files\Карта України\ua2003c.exe', '', '', SW_SHOW);
	Close;
end;

end.
