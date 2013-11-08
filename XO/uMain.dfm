object frmMain: TfrmMain
  Left = 484
  Top = 225
  BorderStyle = bsSingle
  Caption = #1050#1088#1077#1089#1090#1080#1082#1080'-'#1053#1086#1083#1080#1082#1080
  ClientHeight = 330
  ClientWidth = 330
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object shpBackground: TShape
    Left = 10
    Top = 10
    Width = 310
    Height = 310
    Brush.Color = clGray
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 152
    Top = 144
  end
  object XPManifest: TXPManifest
    Left = 152
    Top = 184
  end
end
