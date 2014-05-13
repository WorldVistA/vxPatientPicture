object fmAdmin: TfmAdmin
  Left = 0
  Top = 0
  Caption = 'vxPatientPicture Administrator Settings'
  ClientHeight = 440
  ClientWidth = 645
  Color = clBtnFace
  Constraints.MaxHeight = 486
  Constraints.MaxWidth = 653
  Constraints.MinHeight = 486
  Constraints.MinWidth = 653
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 380
    Width = 645
    Height = 41
    Align = alBottom
    Color = clWhite
    TabOrder = 0
    object buClose: TButton
      Left = 562
      Top = 8
      Width = 75
      Height = 25
      Hint = 'Close this form'
      Caption = '&Close'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = buCloseClick
    end
    object buSaveAll: TButton
      Left = 6
      Top = 8
      Width = 75
      Height = 25
      Hint = 'Save the values of all the fields on this form'
      Caption = '&Save All'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = buSaveAllClick
    end
  end
  object sbStatusBar: TStatusBar
    Left = 0
    Top = 421
    Width = 645
    Height = 19
    Panels = <
      item
        Text = 'asdf'
        Width = 150
      end
      item
        Text = 'asdf'
        Width = 100
      end>
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 645
    Height = 380
    Align = alClient
    TabOrder = 2
    object Bevel2: TBevel
      Left = 11
      Top = 15
      Width = 622
      Height = 177
    end
    object Bevel1: TBevel
      Left = 11
      Top = 209
      Width = 622
      Height = 157
    end
    object Label1: TLabel
      Left = 19
      Top = 24
      Width = 606
      Height = 99
      AutoSize = False
      Caption = 
        'Populate the '#39'Image Root Directory'#39' edit boxes (below)  by manua' +
        'lly entering valid paths.  NOTE: The directories that you enter ' +
        'must exist.  If they do not exist, they are not created automati' +
        'cally.   Note that '#39'Division'#39' takes precedence over '#39'System'#39'.   ' +
        'If Division has a value, that value will be used regardless of a' +
        'ny value for System.  System will be used only if Division does ' +
        'not have a value.                                               ' +
        '                                                                ' +
        '                                                                ' +
        '                                                                ' +
        '                                                                ' +
        '                                    CAUTION: If any patient pict' +
        'ures already exist, DO NOT re-define the '#39'Image Root Directories' +
        #39'.  Doing so will invalidate the image paths in the Patient Reco' +
        'rds for patients who already have a picture.'
      Color = 16046267
      ParentColor = False
      Transparent = False
      Layout = tlCenter
      WordWrap = True
    end
    object Label2: TLabel
      Left = 19
      Top = 220
      Width = 606
      Height = 81
      AutoSize = False
      Caption = 
        'Use these edit boxes to set the maximum number of patient image ' +
        'files allowed per image subdirectory.  When an image subdirector' +
        'y becomes "full" (i.e., the subdirectory contains this maximum n' +
        'umber of patient images), a new image subdirectory is automatica' +
        'lly created under the Image Root Directory (specified above).   ' +
        '                                                                ' +
        '                                                                ' +
        '                                                                ' +
        '                                                                ' +
        '      Default maximum is 100,000 image files per image subdirect' +
        'ory.                                                            ' +
        '                                    Default minimum is 1.'
      Color = 16046267
      ParentColor = False
      Transparent = False
      Layout = tlCenter
      WordWrap = True
    end
    object Label4: TLabel
      Left = 22
      Top = 202
      Width = 200
      Height = 13
      Caption = 'Maximum Images per Subdirectory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 22
      Top = 8
      Width = 123
      Height = 13
      Caption = 'Image Root Directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 25
      Top = 136
      Width = 40
      Height = 13
      Caption = 'Division:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 25
      Top = 162
      Width = 39
      Height = 13
      Caption = 'System:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 234
      Top = 338
      Width = 39
      Height = 13
      Caption = 'System:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 234
      Top = 312
      Width = 40
      Height = 13
      Caption = 'Division:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object seMaxFilesDIV: TJvSpinEdit
      Left = 286
      Top = 308
      Width = 89
      Height = 24
      ButtonKind = bkStandard
      Thousands = True
      Decimal = 0
      MaxValue = 100000.000000000000000000
      MinValue = 1.000000000000000000
      Value = 100000.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnChange = seMaxFilesDIVChange
    end
    object edImageRootDirectoryDIV: TEdit
      Left = 78
      Top = 132
      Width = 535
      Height = 21
      TabOrder = 0
      OnChange = edImageRootDirectoryDIVChange
    end
    object edImageRootDirectorySYS: TEdit
      Left = 78
      Top = 159
      Width = 535
      Height = 21
      TabOrder = 1
      OnChange = edImageRootDirectorySYSChange
    end
    object seMaxFilesSYS: TJvSpinEdit
      Left = 286
      Top = 334
      Width = 89
      Height = 24
      ButtonKind = bkStandard
      Thousands = True
      Decimal = 0
      MaxValue = 100000.000000000000000000
      MinValue = 1.000000000000000000
      Value = 100000.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnChange = seMaxFilesSYSChange
    end
  end
  object MainMenu1: TMainMenu
    Left = 264
    object meFile: TMenuItem
      Caption = '&File'
      object meClose: TMenuItem
        Caption = '&Close'
        OnClick = meCloseClick
      end
    end
  end
end
