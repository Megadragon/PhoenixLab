object MainForm: TMainForm
  Left = 322
  Top = 264
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'USB Selflink Virus Cleaner'
  ClientHeight = 366
  ClientWidth = 632
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
  DesignSize = (
    632
    366)
  PixelsPerInch = 96
  TextHeight = 13
  object vleVirusCleanLog: TValueListEditor
    Left = 8
    Top = 8
    Width = 617
    Height = 249
    Anchors = [akLeft, akTop, akRight]
    DefaultColWidth = 400
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowMoving, goRowSelect, goThumbTracking]
    TabOrder = 0
    TitleCaptions.Strings = (
      #1048#1084#1103' '#1092#1072#1081#1083#1072
      #1056#1077#1079#1091#1083#1100#1090#1072#1090)
    ColWidths = (
      400
      211)
  end
  object xpmManifest: TXPManifest
    Left = 304
    Top = 272
  end
  object tmrScanner: TTimer
    Interval = 500
    OnTimer = tmrScannerTimer
    Left = 208
    Top = 272
  end
end
