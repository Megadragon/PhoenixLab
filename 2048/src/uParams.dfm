object dlgParams: TdlgParams
  Left = 600
  Top = 322
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
  ClientHeight = 162
  ClientWidth = 284
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblSize: TLabel
    Left = 128
    Top = 20
    Width = 98
    Height = 13
    Caption = '&'#1056#1072#1079#1084#1077#1088' '#1089#1077#1090#1082#1080' (3-9):'
    FocusControl = speSize
  end
  object lblTarget: TLabel
    Left = 128
    Top = 52
    Width = 57
    Height = 13
    Caption = '&'#1062#1077#1083#1100' '#1080#1075#1088#1099':'
    FocusControl = cbbTarget
  end
  object bbnOK: TBitBtn
    Left = 64
    Top = 128
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkOK
  end
  object bbnCancel: TBitBtn
    Left = 144
    Top = 128
    Width = 75
    Height = 25
    TabOrder = 6
    Kind = bkCancel
  end
  object rdgMode: TRadioGroup
    Left = 8
    Top = 8
    Width = 113
    Height = 65
    Caption = ' '#1056#1077#1078#1080#1084' '#1080#1075#1088#1099' '
    Items.Strings = (
      '&'#1050#1083#1072#1089#1089#1080#1095#1077#1089#1082#1080#1081
      '&'#1059#1087#1088#1086#1097#1105#1085#1085#1099#1081)
    TabOrder = 0
  end
  object speSize: TSpinEdit
    Left = 232
    Top = 16
    Width = 41
    Height = 22
    MaxValue = 9
    MinValue = 3
    TabOrder = 1
    Value = 4
  end
  object ckbSaveOnExit: TCheckBox
    Left = 8
    Top = 104
    Width = 201
    Height = 17
    Caption = #1042#1089#1077#1075#1076#1072' &'#1089#1086#1093#1088#1072#1085#1103#1090#1100' '#1080#1075#1088#1091' '#1087#1088#1080' '#1074#1099#1093#1086#1076#1077
    TabOrder = 3
  end
  object ckbLoadOnStart: TCheckBox
    Left = 8
    Top = 80
    Width = 217
    Height = 17
    Caption = #1042#1089#1077#1075#1076#1072' &'#1087#1088#1086#1076#1086#1083#1078#1072#1090#1100' '#1089#1086#1093#1088#1072#1085#1105#1085#1085#1091#1102' '#1080#1075#1088#1091
    TabOrder = 4
  end
  object cbbTarget: TComboBox
    Left = 192
    Top = 48
    Width = 81
    Height = 21
    AutoCloseUp = True
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 2
    Text = '2048'
    Items.Strings = (
      '1024'
      '2048'
      '4096'
      '8192'
      '16384'
      '32768'
      '65536')
  end
end
