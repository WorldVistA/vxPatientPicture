object frmPtSelDemog: TfrmPtSelDemog
  Left = 198
  Top = 110
  BorderStyle = bsNone
  Caption = 'frmPtSelDemog'
  ClientHeight = 151
  ClientWidth = 190
  Color = clSkyBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object orapnlMain: TORAutoPanel
    Left = 0
    Top = 0
    Width = 190
    Height = 151
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object Memo: TCaptionMemo
      Left = 0
      Top = 0
      Width = 190
      Height = 151
      Align = alClient
      Color = 16744703
      HideSelection = False
      Lines.Strings = (
        'Memo')
      ReadOnly = True
      TabOrder = 12
      Visible = False
      WantReturns = False
    end
    object lblPtName: TStaticText
      Tag = 2
      Left = 1
      Top = 2
      Width = 166
      Height = 17
      Caption = 'Winchester,Charles Emerson'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 11
    end
    object lblSSN: TStaticText
      Tag = 1
      Left = 1
      Top = 21
      Width = 32
      Height = 17
      Caption = 'MRN:'
      Color = clWhite
      ParentColor = False
      TabOrder = 0
    end
    object lblPtSSN: TStaticText
      Tag = 2
      Left = 31
      Top = 21
      Width = 64
      Height = 17
      Caption = '123-45-1234'
      Color = clWhite
      ParentColor = False
      TabOrder = 1
    end
    object lblDOB: TStaticText
      Tag = 1
      Left = 1
      Top = 39
      Width = 30
      Height = 17
      Caption = 'DOB:'
      Color = clWhite
      ParentColor = False
      TabOrder = 2
    end
    object lblPtDOB: TStaticText
      Tag = 2
      Left = 31
      Top = 39
      Width = 63
      Height = 17
      Caption = 'Jun 26,1957'
      Color = clWhite
      ParentColor = False
      TabOrder = 3
    end
    object lblPtSex: TStaticText
      Tag = 2
      Left = 29
      Top = 57
      Width = 66
      Height = 17
      Caption = 'Male, age 39'
      Color = clWhite
      ParentColor = False
      TabOrder = 4
    end
    object lblPtVet: TStaticText
      Tag = 1
      Left = 1
      Top = 75
      Width = 48
      Height = 17
      Caption = 'Address: '
      Color = clWhite
      ParentColor = False
      TabOrder = 5
    end
    object lblPtSC: TStaticText
      Tag = 1
      Left = 1
      Top = 93
      Width = 35
      Height = 17
      Caption = 'State: '
      Color = clWhite
      ParentColor = False
      TabOrder = 6
    end
    object lblLocation: TStaticText
      Tag = 1
      Left = 1
      Top = 111
      Width = 48
      Height = 17
      Caption = 'Location:'
      Color = clWhite
      ParentColor = False
      TabOrder = 7
    end
    object lblPtRoomBed: TStaticText
      Tag = 2
      Left = 58
      Top = 131
      Width = 32
      Height = 17
      Caption = '257-B'
      Color = clWhite
      ParentColor = False
      ShowAccelChar = False
      TabOrder = 8
    end
    object lblPtLocation: TStaticText
      Tag = 2
      Left = 49
      Top = 111
      Width = 41
      Height = 17
      Caption = '2 EAST'
      Color = clWhite
      ParentColor = False
      ShowAccelChar = False
      TabOrder = 9
    end
    object lblRoomBed: TStaticText
      Tag = 1
      Left = 1
      Top = 131
      Width = 57
      Height = 17
      Caption = 'Room-Bed:'
      Color = clWhite
      ParentColor = False
      TabOrder = 10
    end
    object lblSex: TStaticText
      Tag = 1
      Left = 1
      Top = 57
      Width = 28
      Height = 17
      Caption = 'Sex: '
      Color = clWhite
      ParentColor = False
      TabOrder = 13
    end
    object lblPtAddress: TStaticText
      Tag = 2
      Left = 49
      Top = 75
      Width = 62
      Height = 17
      Caption = 'lblPtAddress'
      Color = clWhite
      ParentColor = False
      TabOrder = 14
    end
    object lblPtState: TStaticText
      Tag = 2
      Left = 36
      Top = 93
      Width = 49
      Height = 17
      Caption = 'lblPtState'
      Color = clWhite
      ParentColor = False
      TabOrder = 15
    end
  end
end
