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
		OKButton: TButton;
		procedure CommentsClick(Sender: TObject);
		procedure CommentsMouseEnter(Sender: TObject);
		procedure CommentsMouseLeave(Sender: TObject);
		procedure RemarksClick(Sender: TObject);
		procedure RemarksMouseEnter(Sender: TObject);
		procedure RemarksMouseLeave(Sender: TObject);
	end;

var
	AboutBox: TAboutBox;

implementation

uses ShellAPI;

{$R *.dfm}

procedure TAboutBox.CommentsClick(Sender: TObject);
begin
	ShellExecute(Handle, 'open', 'mailto:antynik@yandex.ru?bcc=ssglobov@gmail.com&subject=Multiclip%20v2.3.2.54', nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutBox.CommentsMouseEnter(Sender: TObject);
begin
	Comments.Font.Color := clRed;
	Comments.Font.Style := Comments.Font.Style - [fsUnderline];
end;

procedure TAboutBox.CommentsMouseLeave(Sender: TObject);
begin
	Comments.Font.Color := clBlue;
	Comments.Font.Style := Comments.Font.Style + [fsUnderline];
end;

procedure TAboutBox.RemarksClick(Sender: TObject);
begin
	ShellExecute(Handle, 'open', 'mailto:ssglobov@gmail.com&subject=Multiclip%20v2.3.2.54', nil, nil, SW_SHOWNORMAL);
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
