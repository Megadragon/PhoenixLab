unit uSplash;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, ComCtrls, ExtCtrls, PngImage;

type
	TSplashScreen = class(TForm)
		Panel: TPanel;
		imgLogo: TImage;
		lblProductName: TLabel;
		lblDescription: TLabel;
		lblVersion: TLabel;
		lblCopyright: TLabel;
		lblWarning: TLabel;
		pgbLoadStatus: TProgressBar;
	end;

var
	SplashScreen: TSplashScreen;

implementation

{$R *.dfm}

end.
