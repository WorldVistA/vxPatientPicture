object fmPatientLookup: TfmPatientLookup
  Left = 382
  Top = 245
  BorderStyle = bsDialog
  Caption = 'Patient Lookup'
  ClientHeight = 263
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object buLogon: TSpeedButton
    Left = 32
    Top = 32
    Width = 81
    Height = 22
    Caption = 'Logon'
    OnClick = buLogonClick
  end
  object buLogoff: TSpeedButton
    Left = 32
    Top = 72
    Width = 81
    Height = 22
    Caption = 'Logoff'
    Enabled = False
    OnClick = buLogoffClick
  end
  object buPtSel: TSpeedButton
    Left = 32
    Top = 112
    Width = 81
    Height = 22
    Caption = 'Pt. Sel.'
    Enabled = False
    OnClick = buPtSelClick
  end
  object StaticText1: TStaticText
    Left = 216
    Top = 8
    Width = 289
    Height = 245
    AutoSize = False
    Caption = 'Patient Info'
    Color = clWhite
    ParentColor = False
    TabOrder = 0
  end
  object buSearch: TButton
    Left = 32
    Top = 216
    Width = 147
    Height = 25
    Caption = '&Search'
    TabOrder = 1
    OnClick = buSearchClick
  end
end
