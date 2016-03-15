unit uSkins;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, ExtCtrls, CheckLst, Buttons;

type
	TdlgSkins = class(TForm)
		lsbSkinNames: TListBox;
		clbSkinImages: TCheckListBox;
		imgSample: TImage;
		bbnOK: TBitBtn;
		bbnCancel: TBitBtn;
		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure lsbSkinNamesClick(Sender: TObject);
		procedure clbSkinImagesClickCheck(Sender: TObject);
		procedure clbSkinImagesClick(Sender: TObject);
	end;

var
	dlgSkins: TdlgSkins;

implementation

uses uMain;

{$R *.dfm}

procedure TdlgSkins.FormCreate(Sender: TObject);
var
	SearchRec: TSearchRec;
begin
	if FindFirst(frmMain.GetApplicationPath + '*.*', faDirectory, SearchRec) = 0 then try
		repeat
			if (SearchRec.Attr and faDirectory > 0)
				and (SearchRec.Name > '') and (Pos('.', SearchRec.Name) = 0)
			then lsbSkinNames.Items.Add(SearchRec.Name);
		until FindNext(SearchRec) <> 0;
	finally
		FindClose(SearchRec);
	end;
end;

procedure TdlgSkins.FormShow(Sender: TObject);
begin
	with lsbSkinNames do Tag := ItemIndex;
end;

procedure TdlgSkins.lsbSkinNamesClick(Sender: TObject);
var
	Index: Byte;
	SkinPath: string;
begin
	with lsbSkinNames do SkinPath := frmMain.GetApplicationPath + Items[ItemIndex] + '\';
	with clbSkinImages do for Index := 0 to Count - 1 do
		Checked[Index] := FileExists(SkinPath + Items[Index]);
end;

procedure TdlgSkins.clbSkinImagesClick(Sender: TObject);
begin
	if clbSkinImages.Checked[clbSkinImages.ItemIndex] then
		imgSample.Picture.LoadFromFile(frmMain.GetApplicationPath + lsbSkinNames.Items[lsbSkinNames.ItemIndex] + '\' + clbSkinImages.Items[clbSkinImages.ItemIndex])
	else imgSample.Picture := nil;
end;

procedure TdlgSkins.clbSkinImagesClickCheck(Sender: TObject);
begin
	with clbSkinImages do Checked[ItemIndex] := not Checked[ItemIndex];
end;

end.

