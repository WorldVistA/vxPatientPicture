object frmPtSelOptns: TfrmPtSelOptns
  Left = 457
  Top = 213
  BorderStyle = bsNone
  Caption = 'frmPtSelOptns'
  ClientHeight = 248
  ClientWidth = 176
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object orapnlMain: TORAutoPanel
    Left = 0
    Top = 0
    Width = 176
    Height = 248
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object lblPtList: TLabel
      Left = 4
      Top = 4
      Width = 52
      Height = 13
      Caption = 'Patient List'
    end
    object lblDateRange: TLabel
      Left = 4
      Top = 212
      Width = 98
      Height = 13
      Caption = 'List Appointments for'
    end
    object bvlPtList: TORAutoPanel
      Left = 3
      Top = 18
      Width = 168
      Height = 69
      BevelOuter = bvLowered
      Color = clWhite
      TabOrder = 0
      object radAll: TRadioButton
        Tag = 18
        Left = 103
        Top = 49
        Width = 60
        Height = 17
        Caption = '&All'
        TabOrder = 6
        OnClick = radHideSrcClick
      end
      object radWards: TRadioButton
        Tag = 17
        Left = 103
        Top = 33
        Width = 60
        Height = 17
        Caption = '&Wards'
        TabOrder = 5
        OnClick = radShowSrcClick
      end
      object radClinics: TRadioButton
        Tag = 16
        Left = 103
        Top = 18
        Width = 60
        Height = 17
        Caption = '&Clinics'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 4
        OnClick = radLongSrcClick
      end
      object radSpecialties: TRadioButton
        Tag = 14
        Left = 1
        Top = 49
        Width = 84
        Height = 17
        Caption = '&Specialties'
        TabOrder = 3
        OnClick = radShowSrcClick
      end
      object radTeams: TRadioButton
        Tag = 13
        Left = 1
        Top = 33
        Width = 98
        Height = 17
        Caption = '&Team/Personal'
        TabOrder = 2
        OnClick = radShowSrcClick
      end
      object radProviders: TRadioButton
        Tag = 12
        Left = 1
        Top = 18
        Width = 84
        Height = 17
        Caption = '&Providers'
        TabOrder = 1
        OnClick = radLongSrcClick
      end
      object radDflt: TRadioButton
        Tag = 11
        Left = 1
        Top = 3
        Width = 162
        Height = 17
        Caption = 'No &Default'
        TabOrder = 0
        OnClick = radHideSrcClick
      end
    end
    object cboList: TORComboBox
      Left = 4
      Top = 92
      Width = 169
      Height = 116
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Patient List'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 2
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      OnExit = cboListExit
      OnKeyPause = cboListKeyPause
      OnMouseClick = cboListMouseClick
      OnNeedData = cboListNeedData
      CharsNeedMatch = 1
    end
    object cboDateRange: TORComboBox
      Left = 4
      Top = 226
      Width = 169
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'List Appointments for'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 2
      OnExit = cboDateRangeExit
      OnMouseClick = cboDateRangeMouseClick
      CharsNeedMatch = 1
    end
  end
  object calApptRng: TORDateRangeDlg
    DateOnly = True
    Instruction = 'Enter a date range -'
    LabelStart = 'First Appointment Date'
    LabelStop = 'Last Appointment Date'
    RequireTime = False
    Format = 'mmm d,yy'
    Left = 72
    Top = 128
  end
end
