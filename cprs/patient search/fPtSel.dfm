object frmPtSel: TfrmPtSel
  Left = 676
  Top = 176
  BorderIcons = []
  Caption = 'Patient Selection'
  ClientHeight = 342
  ClientWidth = 636
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object pnlPtSel: TORAutoPanel
    Left = 0
    Top = 0
    Width = 636
    Height = 342
    Align = alClient
    BevelWidth = 2
    Color = clWhite
    TabOrder = 0
    OnResize = pnlPtSelResize
    DesignSize = (
      636
      342)
    object lblPatient: TLabel
      Left = 185
      Top = 8
      Width = 33
      Height = 13
      Caption = 'Patient'
      ShowAccelChar = False
    end
    object imPreview: TImage
      Left = 466
      Top = 22
      Width = 75
      Height = 100
      Center = True
      ParentShowHint = False
      ShowHint = True
      Stretch = True
    end
    object cboPatient: TORComboBox
      Left = 185
      Top = 22
      Width = 272
      Height = 304
      Hint = 'Enter name or use "Last 4" (x1234) format'
      Anchors = [akLeft, akTop, akBottom]
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Patient'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2,3'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabPositions = '20,25,30'
      TabOrder = 1
      OnChange = cboPatientChange
      OnDblClick = cboPatientDblClick
      OnEnter = cboPatientEnter
      OnExit = cboPatientExit
      OnKeyDown = cboPatientKeyDown
      OnKeyPause = cboPatientKeyPause
      OnMouseClick = cboPatientMouseClick
      OnNeedData = cboPatientNeedData
      CharsNeedMatch = 1
    end
    object cmdSaveList: TJvHTButton
      Left = 463
      Top = 308
      Width = 163
      Height = 18
      Caption = 'Save Patient List Settings '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = cmdSaveListClick
      Layout = blGlyphBottom
      Color = 16046267
      ParentColor = False
    end
    object cmdOK: TJvHTButton
      Left = 547
      Top = 22
      Width = 78
      Height = 19
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = cmdOKClick
      Color = 16046267
      ParentColor = False
    end
    object cmdCancel: TJvHTButton
      Left = 547
      Top = 43
      Width = 78
      Height = 19
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = cmdCancelClick
      Color = 16046267
      ParentColor = False
    end
  end
end
