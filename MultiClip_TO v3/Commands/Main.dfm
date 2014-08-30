object frmCommands: TfrmCommands
  Left = 520
  Top = 289
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1082#1086#1084#1072#1085#1076' Multiclip'
  ClientHeight = 345
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
    345)
  PixelsPerInch = 96
  TextHeight = 13
  object bvlControl: TBevel
    Left = 432
    Top = 232
    Width = 193
    Height = 74
    Anchors = [akTop, akRight, akBottom]
  end
  object bbnOK: TBitBtn
    Left = 232
    Top = 312
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    OnClick = bbnOKClick
    Kind = bkOK
  end
  object bbnCancel: TBitBtn
    Left = 328
    Top = 312
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 4
    OnClick = bbnCancelClick
    Kind = bkCancel
  end
  object gpbCommand: TGroupBox
    Left = 432
    Top = 8
    Width = 193
    Height = 217
    Anchors = [akTop, akRight]
    Caption = ' '#1053#1086#1074#1072#1103' '#1082#1086#1084#1072#1085#1076#1072' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      193
      217)
    object lblTeamHotkey: TLabel
      Left = 8
      Top = 88
      Width = 147
      Height = 13
      Caption = #1050#1086#1084#1072#1085#1076#1085#1072#1103' '#1075#1086#1088#1103#1095#1072#1103' '#1082#1083#1072#1074#1080#1096#1072
    end
    object lblGlobalHotkey: TLabel
      Left = 8
      Top = 136
      Width = 125
      Height = 13
      Caption = #1054#1073#1097#1072#1103' '#1075#1086#1088#1103#1095#1072#1103' '#1082#1083#1072#1074#1080#1096#1072
    end
    object chbDelay: TCheckBox
      Left = 8
      Top = 16
      Width = 161
      Height = 17
      Caption = #1047#1072#1076#1077#1088#1078#1082#1072' '#1087#1077#1088#1077#1076' '#1086#1090#1087#1088#1072#1074#1082#1086#1081
      TabOrder = 0
    end
    object lbeText: TLabeledEdit
      Left = 8
      Top = 56
      Width = 177
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 125
      EditLabel.Height = 13
      EditLabel.Caption = #1058#1077#1082#1089#1090' '#1073#1099#1089#1090#1088#1086#1081' '#1082#1086#1084#1072#1085#1076#1099
      TabOrder = 1
    end
    object htkTeam: THotKey
      Left = 8
      Top = 104
      Width = 177
      Height = 19
      HotKey = 0
      InvalidKeys = []
      Modifiers = []
      TabOrder = 2
    end
    object htkGlobal: THotKey
      Left = 8
      Top = 152
      Width = 177
      Height = 19
      HotKey = 0
      InvalidKeys = []
      Modifiers = []
      TabOrder = 3
    end
    object btnAddCommand: TButton
      Left = 8
      Top = 184
      Width = 177
      Height = 25
      Anchors = [akLeft, akRight, akBottom]
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1084#1072#1085#1076#1091
      TabOrder = 4
      OnClick = btnAddCommandClick
    end
  end
  object btnSeparator: TButton
    Left = 440
    Top = 240
    Width = 177
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1088#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100
    TabOrder = 1
    OnClick = btnSeparatorClick
  end
  object btnDelete: TButton
    Left = 440
    Top = 272
    Width = 177
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
    TabOrder = 2
    OnClick = btnDeleteClick
  end
  object ltvCommandList: TListView
    Left = 8
    Top = 8
    Width = 417
    Height = 297
    Checkboxes = True
    Columns = <
      item
        AutoSize = True
        Caption = #1050#1086#1084#1072#1085#1076#1072
      end
      item
        AutoSize = True
        Caption = #1050#1086#1084#1072#1085#1076#1085#1072#1103' '#1075#1086#1088#1103#1095#1072#1103' '#1082#1083#1072#1074#1080#1096#1072
      end
      item
        AutoSize = True
        Caption = #1054#1073#1097#1072#1103' '#1075#1086#1088#1103#1095#1072#1103' '#1082#1083#1072#1074#1080#1096#1072
      end>
    ColumnClick = False
    GridLines = True
    HideSelection = False
    IconOptions.Arrangement = iaLeft
    ReadOnly = True
    RowSelect = True
    TabOrder = 5
    ViewStyle = vsReport
  end
end
