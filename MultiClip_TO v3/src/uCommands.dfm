object frmCommands: TfrmCommands
  Left = 520
  Top = 292
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1082#1086#1084#1072#1085#1076' Multiclip'
  ClientHeight = 412
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object bbnOK: TBitBtn
    Left = 248
    Top = 376
    Width = 75
    Height = 25
    TabOrder = 6
    Kind = bkOK
  end
  object bbnCancel: TBitBtn
    Left = 344
    Top = 376
    Width = 75
    Height = 25
    TabOrder = 7
    Kind = bkCancel
  end
  object gpbCommand: TGroupBox
    Left = 424
    Top = 112
    Width = 193
    Height = 161
    Caption = ' '#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1082#1086#1084#1072#1085#1076#1099' '
    TabOrder = 2
    DesignSize = (
      193
      161)
    object lblHotkey: TLabel
      Left = 8
      Top = 80
      Width = 69
      Height = 13
      Caption = #1054#1089#1085#1086#1074#1085#1086#1081' '#1095#1072#1090
      FocusControl = htkHotkey
    end
    object lblAltHotKey: TLabel
      Left = 8
      Top = 120
      Width = 104
      Height = 13
      Caption = #1040#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1099#1081' '#1095#1072#1090
      FocusControl = htkAltHotKey
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
    object htkHotkey: THotKey
      Left = 8
      Top = 96
      Width = 177
      Height = 19
      HotKey = 0
      InvalidKeys = []
      Modifiers = []
      TabOrder = 2
    end
    object htkAltHotKey: THotKey
      Left = 8
      Top = 136
      Width = 177
      Height = 19
      HotKey = 0
      InvalidKeys = []
      Modifiers = []
      TabOrder = 3
    end
  end
  object btnAddCommand: TButton
    Left = 424
    Top = 280
    Width = 193
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1084#1072#1085#1076#1091
    TabOrder = 3
    OnClick = btnAddCommandClick
  end
  object btnSeparator: TButton
    Left = 424
    Top = 312
    Width = 193
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1088#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100
    TabOrder = 4
    OnClick = btnSeparatorClick
  end
  object btnDelete: TButton
    Left = 424
    Top = 344
    Width = 193
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
    TabOrder = 5
    OnClick = btnDeleteClick
  end
  object gpbHeader: TGroupBox
    Left = 8
    Top = 8
    Width = 609
    Height = 97
    Caption = ' '#1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1089#1087#1080#1089#1082#1072' '
    TabOrder = 0
    object spbChooseTargetWindow: TSpeedButton
      Left = 576
      Top = 16
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = spbChooseTargetWindowClick
    end
    object lblOpenKey: TLabel
      Left = 8
      Top = 52
      Width = 114
      Height = 13
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1086#1089#1085#1086#1074#1085#1086#1081' '#1095#1072#1090
      FocusControl = htkOpenKey
    end
    object lblSendKey: TLabel
      Left = 8
      Top = 76
      Width = 133
      Height = 13
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074' '#1086#1089#1085#1086#1074#1085#1086#1081' '#1095#1072#1090
      FocusControl = htkSendKey
    end
    object lblAltOpenKey: TLabel
      Left = 288
      Top = 52
      Width = 151
      Height = 13
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081' '#1095#1072#1090
      FocusControl = htkAltOpenKey
    end
    object lblAltSendKey: TLabel
      Left = 288
      Top = 76
      Width = 170
      Height = 13
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081' '#1095#1072#1090
      FocusControl = htkAltSendKey
    end
    object lbeTargetWindowName: TLabeledEdit
      Left = 144
      Top = 16
      Width = 425
      Height = 21
      EditLabel.Width = 131
      EditLabel.Height = 13
      EditLabel.Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1094#1077#1083#1077#1074#1086#1075#1086' '#1086#1082#1085#1072
      LabelPosition = lpLeft
      LabelSpacing = 6
      TabOrder = 0
    end
    object htkOpenKey: THotKey
      Left = 144
      Top = 48
      Width = 137
      Height = 19
      HotKey = 0
      InvalidKeys = []
      Modifiers = []
      TabOrder = 1
    end
    object htkSendKey: THotKey
      Left = 144
      Top = 72
      Width = 137
      Height = 19
      HotKey = 13
      InvalidKeys = []
      Modifiers = []
      TabOrder = 2
    end
    object htkAltOpenKey: THotKey
      Left = 464
      Top = 48
      Width = 137
      Height = 19
      HotKey = 0
      InvalidKeys = []
      Modifiers = []
      TabOrder = 3
    end
    object htkAltSendKey: THotKey
      Left = 464
      Top = 72
      Width = 137
      Height = 19
      HotKey = 0
      InvalidKeys = []
      Modifiers = []
      TabOrder = 4
    end
  end
  object ltvCommandList: TListView
    Left = 8
    Top = 112
    Width = 409
    Height = 257
    Checkboxes = True
    Columns = <
      item
        Caption = #1050#1086#1084#1072#1085#1076#1072
        Width = 165
      end
      item
        Caption = #1054#1089#1085#1086#1074#1085#1086#1081' '#1095#1072#1090
        Width = 120
      end
      item
        Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081' '#1095#1072#1090
        Width = 120
      end>
    HotTrack = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
end
