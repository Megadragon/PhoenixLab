unit uAbout;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
	Buttons, ExtCtrls;

type
	TAboutBox = class(TForm)
		Panel: TPanel;
		ProgramIcon: TImage;
		ProductName: TLabel;
		Version: TLabel;
		Copyright: TLabel;
		Comments: TLabel;
		Remarks: TLabel;
		OKButton: TBitBtn;
		procedure RemarksClick(Sender: TObject);
		procedure RemarksMouseEnter(Sender: TObject);
		procedure RemarksMouseLeave(Sender: TObject);
	end;

var
	AboutBox: TAboutBox;

implementation

uses ShellAPI;

{$R *.dfm}

procedure TAboutBox.RemarksClick(Sender: TObject);
begin
	ShellExecute(Handle, nil, 'mailto:ssglobov@gmail.com&subject=Multiclip%20v3.2.2.58', nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutBox.RemarksMouseEnter(Sender: TObject);
begin
	Remarks.Font.Color := clRed;
	Remarks.Font.Style := Remarks.Font.Style - [fsUnderline];
end;

procedure TAboutBox.RemarksMouseLeave(Sender: TObject);
begin
	Remarks.Font.Color := clBlue;
	Remarks.Font.Style := Remarks.Font.Style + [fsUnderline];
end;

end.

