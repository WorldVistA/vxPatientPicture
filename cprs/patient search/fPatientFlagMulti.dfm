object frmFlags: TfrmFlags
  Left = 457
  Top = 74
  Caption = 'Patient Record Flags'
  ClientHeight = 371
  ClientWidth = 497
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 80
    Width = 497
    Height = 5
    Align = alNone
  end
  object Panel1: TPanel
    Left = 0
    Top = 340
    Width = 497
    Height = 31
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      497
      31)
    object btnClose: TButton
      Left = 410
      Top = 5
      Width = 77
      Height = 21
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 497
    Height = 80
    Align = alTop
    Constraints.MinHeight = 40
    Constraints.MinWidth = 300
    TabOrder = 2
    object lblFlags: TLabel
      Left = 1
      Top = 1
      Width = 495
      Height = 13
      Align = alTop
      Caption = 'Active Flag'
      Layout = tlCenter
      ExplicitWidth = 53
    end
    object lstFlags: TORListBox
      Left = 1
      Top = 14
      Width = 495
      Height = 65
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = lstFlagsClick
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
      OnChange = lstFlagsClick
    end
  end
  object memFlags: TCaptionMemo
    Left = 0
    Top = 80
    Width = 497
    Height = 260
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WantReturns = False
    WordWrap = False
  end
end
