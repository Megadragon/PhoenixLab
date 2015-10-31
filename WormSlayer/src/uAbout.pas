unit uAbout;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
	ExtCtrls, ShellAPI;

type
	TAboutBox = class(TForm)
		Panel: TPanel;
		ProgramIcon: TImage;
		ProductName: TLabel;
		Version: TLabel;
		Copyright: TLabel;
		Comments: TLabel;
		OKButton: TButton;
		Feedback: TLabel;
		EMail: TLabel;
		procedure EMailMouseEnter(Sender: TObject);
		procedure EMailMouseLeave(Sender: TObject);
		procedure EMailClick(Sender: TObject);
	end;

var
	AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.EMailMouseEnter(Sender: TObject);
begin
	with EMail.Font do begin
		Color := clRed;
		Style := [];
	end;
end;

procedure TAboutBox.EMailMouseLeave(Sender: TObject);
begin
	with EMail.Font do begin
		Color := clBlue;
		Style := [fsUnderline];
	end;
end;

procedure TAboutBox.EMailClick(Sender: TObject);
begin
	ShellExecute(Handle, nil, 'mailto:Glossit@2upost.com?subject=WormSlayer v3.0.0.45', nil, nil, SW_SHOW);
end;

end.
