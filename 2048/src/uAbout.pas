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
		OKButton: TBitBtn;
	end;

var
	AboutBox: TAboutBox;

implementation

{$R *.dfm}

end.
