object OKRightDlg: TOKRightDlg
  Left = 318
  Top = 199
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
  ClientHeight = 153
  ClientWidth = 337
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 84
    Top = 120
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 180
    Top = 118
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object rdgMode: TRadioGroup
    Left = 8
    Top = 8
    Width = 201
    Height = 105
    Caption = ' '#1056#1077#1078#1080#1084' '#1080#1075#1088#1099' '
    ItemIndex = 0
    Items.Strings = (
      #1055#1042#1055' ('#1048#1075#1088#1086#1082' '#1087#1088#1086#1090#1080#1074' '#1048#1075#1088#1086#1082#1072')'
      #1055#1042#1045' ('#1048#1075#1088#1086#1082' '#1087#1088#1086#1090#1080#1074' '#1050#1086#1084#1087#1100#1102#1090#1077#1088#1072')'
      #1050#1086#1084#1087#1100#1102#1090#1077#1088' '#1087#1088#1086#1090#1080#1074' '#1050#1086#1084#1087#1100#1102#1090#1077#1088#1072)
    TabOrder = 2
    OnClick = rdgModeClick
  end
  object rdgPlayer: TRadioGroup
    Left = 216
    Top = 8
    Width = 113
    Height = 105
    Caption = ' '#1055#1077#1088#1074#1099#1081' '#1093#1086#1076' '
    Items.Strings = (
      #1048#1075#1088#1086#1082' '#8470'1'
      #1048#1075#1088#1086#1082' '#8470'2')
    TabOrder = 3
  end
  object XPManifest: TXPManifest
    Left = 296
    Top = 32
  end
end
