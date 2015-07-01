object frmMain: TfrmMain
  Left = 626
  Top = 292
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'TO Launcher'
  ClientHeight = 321
  ClientWidth = 468
  Color = 12339
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clLime
  Font.Height = -16
  Font.Name = 'Times New Roman'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object shpClose: TShape
    Left = 280
    Top = 224
    Width = 177
    Height = 89
    Cursor = crHandPoint
    Hint = #1042#1099#1081#1090#1080' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
    Brush.Color = clRed
    Shape = stRoundRect
    OnMouseUp = shpCloseMouseUp
  end
  object shpRun: TShape
    Left = 280
    Top = 128
    Width = 177
    Height = 89
    Cursor = crHandPoint
    Hint = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1080#1075#1088#1091
    Brush.Color = clLime
    Shape = stRoundRect
    OnMouseUp = shpRunMouseUp
  end
  object swfBanner: TShockwaveFlash
    Left = 0
    Top = 0
    Width = 468
    Height = 120
    Align = alTop
    TabOrder = 0
    ControlData = {
      67556655000900005F300000670C000008004C00000068006100730068003D00
      6400300030003600380065006300330030002600730065007200760065007200
      3D00740061006E006B0069006F006E006C0069006E0065002E0063006F006D00
      000008004800000068007400740070003A002F002F00740061006E006B006900
      6F006E006C0069006E0065002E0063006F006D002F00740061006E006B006900
      7200650066002E00730077006600000008004800000068007400740070003A00
      2F002F00740061006E006B0069006F006E006C0069006E0065002E0063006F00
      6D002F00740061006E006B0069007200650066002E0073007700660000000800
      0E000000570069006E0064006F00770000000800040000003000000008000600
      00002D003100000008000A000000480069006700680000000800060000004C00
      540000000800040000003000000008003000000068007400740070003A002F00
      2F00740061006E006B0069006F006E006C0069006E0065002E0063006F006D00
      2F00000008000200000000000800100000004E006F005300630061006C006500
      00000800060000002D0031000000080004000000300000000800020000000000
      08000000000008000200000000000D0000000000000000000000000000000000
      0800040000003100000008000400000030000000080000000000080004000000
      3000000008000800000061006C006C00000008000C000000660061006C007300
      6500000008000C000000660061006C0073006500000008000400000030000000}
  end
  object gpbParams: TGroupBox
    Left = 8
    Top = 128
    Width = 265
    Height = 185
    Caption = ' '#1055#1072#1088#1072#1084#1077#1090#1088#1099' '
    TabOrder = 1
    object lblBrowser: TLabel
      Left = 16
      Top = 28
      Width = 54
      Height = 19
      Caption = #1041#1088#1072#1091#1079#1077#1088':'
      FocusControl = cbbBrowser
    end
    object lblLanguage: TLabel
      Left = 16
      Top = 68
      Width = 38
      Height = 19
      Caption = #1071#1079#1099#1082':'
      FocusControl = cbbLanguage
    end
    object lblLocale: TLabel
      Left = 16
      Top = 108
      Width = 51
      Height = 19
      Caption = #1051#1086#1082#1072#1083#1100':'
      FocusControl = cbbLocale
    end
    object lblServer: TLabel
      Left = 16
      Top = 148
      Width = 52
      Height = 19
      Caption = #1057#1077#1088#1074#1077#1088':'
      FocusControl = cbbServer
    end
    object cbbBrowser: TComboBox
      Left = 80
      Top = 24
      Width = 177
      Height = 27
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1073#1088#1072#1091#1079#1077#1088
      Style = csDropDownList
      Color = 12339
      ItemHeight = 19
      TabOrder = 0
    end
    object cbbLanguage: TComboBox
      Left = 80
      Top = 64
      Width = 177
      Height = 27
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1103#1079#1099#1082' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1072
      Style = csDropDownList
      Color = 12339
      ItemHeight = 19
      TabOrder = 1
      Items.Strings = (
        #1056#1091#1089#1089#1082#1080#1081
        #1040#1085#1075#1083#1080#1081#1089#1082#1080#1081
        #1053#1077#1084#1077#1094#1082#1080#1081)
    end
    object cbbLocale: TComboBox
      Left = 80
      Top = 104
      Width = 177
      Height = 27
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1072#1094#1080#1086#1085#1072#1083#1100#1085#1086#1089#1090#1100' '#1089#1077#1088#1074#1077#1088#1072
      Style = csDropDownList
      Color = 12339
      ItemHeight = 19
      TabOrder = 2
      OnChange = cbbLocaleChange
      Items.Strings = (
        #1056#1091#1089#1089#1082#1072#1103
        #1040#1085#1075#1083#1080#1081#1089#1082#1072#1103
        #1053#1077#1084#1077#1094#1082#1072#1103)
    end
    object cbbServer: TComboBox
      Left = 80
      Top = 144
      Width = 177
      Height = 27
      Hint = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1086#1084#1077#1088' '#1089#1077#1088#1074#1077#1088#1072
      Style = csDropDownList
      Color = 12339
      ItemHeight = 19
      TabOrder = 3
    end
  end
end
