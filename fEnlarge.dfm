object fmEnlarge: TfmEnlarge
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'vxPatientPicture'
  ClientHeight = 500
  ClientWidth = 619
  Color = 15921906
  Constraints.MaxHeight = 525
  Constraints.MaxWidth = 625
  Constraints.MinHeight = 525
  Constraints.MinWidth = 625
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 619
    Height = 459
    Align = alClient
    Brush.Color = clSilver
    ExplicitLeft = 248
    ExplicitTop = 240
    ExplicitWidth = 65
    ExplicitHeight = 65
  end
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 619
    Height = 459
    Cursor = crCross
    Align = alClient
    Center = True
    ParentShowHint = False
    ShowHint = False
    Stretch = True
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
    ExplicitTop = 1
  end
  object Shape: TShape
    Left = 158
    Top = 28
    Width = 303
    Height = 400
    Cursor = crSizeAll
    Brush.Style = bsClear
    Pen.Color = clWhite
    Pen.Style = psDot
    OnMouseDown = ShapeMouseDown
    OnMouseMove = ShapeMouseMove
    OnMouseUp = ShapeMouseUp
  end
  object Panel1: TPanel
    Left = 0
    Top = 459
    Width = 619
    Height = 41
    Align = alBottom
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 0
    object buOK: TJvTransparentButton
      Left = 448
      Top = 7
      Width = 75
      Height = 25
      Hint = 'Accept the cropped image'
      Caption = '&OK'
      Enabled = False
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Tahoma'
      HotTrackFont.Style = []
      ParentShowHint = False
      ShowHint = True
      OnClick = buOKClick
    end
    object buUndo: TJvTransparentButton
      Left = 9
      Top = 7
      Width = 110
      Height = 25
      Hint = 
        'Click to undo the most recent crop action.  Or, use Alt+U or Ctr' +
        'l+Z'
      Caption = '&Undo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Tahoma'
      HotTrackFont.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = buUndoClick
    end
    object buCancel: TJvTransparentButton
      Left = 529
      Top = 7
      Width = 75
      Height = 25
      Hint = 'Close this form'
      Caption = '&Cancel'
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Tahoma'
      HotTrackFont.Style = []
      ParentShowHint = False
      ShowHint = True
      OnClick = buCancelClick
    end
    object laX: TLabel
      Left = 136
      Top = 5
      Width = 13
      Height = 13
      Caption = 'X: '
      Visible = False
    end
    object laY: TLabel
      Left = 182
      Top = 5
      Width = 13
      Height = 13
      Caption = 'Y: '
      Visible = False
    end
    object laFSelX: TLabel
      Left = 216
      Top = 5
      Width = 33
      Height = 13
      Caption = 'FSelX: '
      Visible = False
    end
    object laFSelY: TLabel
      Left = 296
      Top = 5
      Width = 33
      Height = 13
      Caption = 'FSelY: '
      Visible = False
    end
    object laH: TLabel
      Left = 306
      Top = 21
      Width = 14
      Height = 13
      Caption = 'H: '
      Visible = False
    end
    object laW: TLabel
      Left = 232
      Top = 21
      Width = 17
      Height = 13
      Caption = 'W: '
      Visible = False
    end
    object btnCrop: TJvTransparentButton
      Left = 351
      Top = 7
      Width = 75
      Height = 25
      Caption = 'C&rop'
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Tahoma'
      HotTrackFont.Style = []
      OnClick = btnCropClick
    end
    object laFSelRectLeft: TLabel
      Left = 126
      Top = 19
      Width = 72
      Height = 13
      Caption = 'FSelRect.Left: '
      Visible = False
    end
  end
end
