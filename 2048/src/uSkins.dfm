object dlgSkins: TdlgSkins
  Left = 633
  Top = 309
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1086#1092#1086#1088#1084#1083#1077#1085#1080#1103
  ClientHeight = 282
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imgSample: TImage
    Left = 272
    Top = 8
    Width = 105
    Height = 105
    Stretch = True
  end
  object lsbSkinNames: TListBox
    Left = 8
    Top = 8
    Width = 121
    Height = 233
    Style = lbOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 0
    OnClick = lsbSkinNamesClick
  end
  object clbSkinImages: TCheckListBox
    Left = 140
    Top = 8
    Width = 121
    Height = 233
    OnClickCheck = clbSkinImagesClickCheck
    ItemHeight = 13
    Items.Strings = (
      '0.bmp'
      '2.bmp'
      '4.bmp'
      '8.bmp'
      '16.bmp'
      '32.bmp'
      '64.bmp'
      '128.bmp'
      '256.bmp'
      '512.bmp'
      '1024.bmp'
      '2048.bmp'
      '4096.bmp'
      '8192.bmp'
      '16384.bmp'
      '32768.bmp'
      '65536.bmp'
      '131072.bmp'
      '262144.bmp'
      '524288.bmp')
    TabOrder = 1
    OnClick = clbSkinImagesClick
  end
  object bbnOK: TBitBtn
    Left = 112
    Top = 248
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object bbnCancel: TBitBtn
    Left = 200
    Top = 248
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
end
