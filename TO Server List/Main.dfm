object MainForm: TMainForm
  Left = 615
  Top = 276
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'TO Server List'
  ClientHeight = 568
  ClientWidth = 468
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
  PixelsPerInch = 96
  TextHeight = 13
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
  object Panel: TPanel
    Left = 0
    Top = 120
    Width = 468
    Height = 448
    Align = alClient
    BevelInner = bvLowered
    Color = 12339
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clLime
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    Locked = True
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object shpRun: TShape
      Left = 208
      Top = 8
      Width = 121
      Height = 81
      Cursor = crHandPoint
      Hint = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1080#1075#1088#1091
      Brush.Color = clLime
      Shape = stRoundRect
      OnMouseUp = shpRunMouseUp
    end
    object shpClose: TShape
      Left = 336
      Top = 8
      Width = 121
      Height = 81
      Cursor = crHandPoint
      Hint = #1042#1099#1093#1086#1076' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      Brush.Color = clRed
      Shape = stRoundRect
      OnMouseUp = shpCloseMouseUp
    end
    object gpbClient: TGroupBox
      Left = 8
      Top = 8
      Width = 193
      Height = 81
      Caption = ' '#1050#1083#1080#1077#1085#1090' '
      TabOrder = 0
      object cbbBrowser: TComboBox
        Left = 8
        Top = 24
        Width = 177
        Height = 27
        Style = csDropDownList
        Color = 12339
        ItemHeight = 19
        TabOrder = 0
      end
      object ckbFlashPlayer: TCheckBox
        Left = 8
        Top = 56
        Width = 97
        Height = 17
        Caption = 'Flash Player'
        TabOrder = 1
        OnClick = ckbFlashPlayerClick
      end
    end
    object rdgServers: TRadioGroup
      Left = 8
      Top = 96
      Width = 449
      Height = 345
      Caption = ' '#1057#1087#1080#1089#1086#1082' '#1089#1077#1088#1074#1077#1088#1086#1074' '
      Columns = 3
      Items.Strings = (
        #1057#1077#1088#1074#1077#1088' 0'
        #1057#1077#1088#1074#1077#1088' 1'
        #1057#1077#1088#1074#1077#1088' 2'
        #1057#1077#1088#1074#1077#1088' 3'
        #1057#1077#1088#1074#1077#1088' 4'
        #1057#1077#1088#1074#1077#1088' 5'
        #1057#1077#1088#1074#1077#1088' 6'
        #1057#1077#1088#1074#1077#1088' 7'
        #1057#1077#1088#1074#1077#1088' 8'
        #1057#1077#1088#1074#1077#1088' 9'
        #1057#1077#1088#1074#1077#1088' 10'
        #1057#1077#1088#1074#1077#1088' 11'
        #1057#1077#1088#1074#1077#1088' 12'
        #1057#1077#1088#1074#1077#1088' 13'
        #1057#1077#1088#1074#1077#1088' 14'
        #1057#1077#1088#1074#1077#1088' 15'
        #1057#1077#1088#1074#1077#1088' 16'
        #1057#1077#1088#1074#1077#1088' 17'
        #1057#1077#1088#1074#1077#1088' 18'
        #1057#1077#1088#1074#1077#1088' 19'
        #1057#1077#1088#1074#1077#1088' 20'
        #1057#1077#1088#1074#1077#1088' 21'
        #1057#1077#1088#1074#1077#1088' 22'
        #1057#1077#1088#1074#1077#1088' 23'
        #1057#1077#1088#1074#1077#1088' 24'
        #1057#1077#1088#1074#1077#1088' 25'
        #1057#1077#1088#1074#1077#1088' 26'
        #1057#1077#1088#1074#1077#1088' 27'
        #1057#1077#1088#1074#1077#1088' 28'
        #1057#1077#1088#1074#1077#1088' 29'
        #1057#1077#1088#1074#1077#1088' 30'
        #1057#1077#1088#1074#1077#1088' 31'
        #1057#1077#1088#1074#1077#1088' 32'
        #1057#1077#1088#1074#1077#1088' 33'
        #1057#1077#1088#1074#1077#1088' 34'
        #1057#1077#1088#1074#1077#1088' 35'
        #1057#1077#1088#1074#1077#1088' 36'
        #1057#1077#1088#1074#1077#1088' 37'
        #1057#1077#1088#1074#1077#1088' 38'
        #1057#1077#1088#1074#1077#1088' 39'
        #1057#1077#1088#1074#1077#1088' 40'
        #1057#1077#1088#1074#1077#1088' 41'
        #1057#1077#1088#1074#1077#1088' 42'
        #1057#1077#1088#1074#1077#1088' 43'
        #1057#1077#1088#1074#1077#1088' 44'
        #1057#1077#1088#1074#1077#1088' 45')
      TabOrder = 1
    end
  end
end
