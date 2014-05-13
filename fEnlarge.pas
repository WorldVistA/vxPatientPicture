unit fEnlarge;

{
Copyright 2013 Document Storage Systems, Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, JvExControls, JvButton, JvTransparentButton, AxCtrls, ComObj;

type
  TfmEnlarge = class(TForm)
    Panel1: TPanel;
    buOK: TJvTransparentButton;
    buUndo: TJvTransparentButton;
    buCancel: TJvTransparentButton;
    Shape1: TShape;
    Image1: TImage;
    laX: TLabel;
    laY: TLabel;
    laFSelX: TLabel;
    laFSelY: TLabel;
    laH: TLabel;
    laW: TLabel;
    Shape: TShape;
    btnCrop: TJvTransparentButton;
    laFSelRectLeft: TLabel;
    procedure buOkClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure buUndoClick(Sender: TObject);
    procedure buCancelClick(Sender: TObject);
    procedure ShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ShapeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCropClick(Sender: TObject);
    procedure shDisplayedDefaultCropRectangleMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    fs: TFileStream;
    FSelecting: Boolean;
    FSelRect: TRect;
    FSelX: Integer;
    FSelY: Integer;
    FSelMove: Boolean;
    function BMPtoJPG(var BMPpic, JPGpic: string) : boolean;
    procedure CropBitmap(InBitmap, OutBitMap : TBitmap; X, Y, W, H :Integer);
  public
    croppedImage: TBitmap;
    fOriginalBitmap: TBitmap;
    thumbnail : TBitmap;
    thumbRect : TRect;
    maxWidth: integer;
    maxHeight: integer;
  end;

const
  THUMBNAIL_HEIGHT_100x75 = 100;
  THUMBNAIL_WIDTH_100x75 = 75;
  THUMBNAIL_HEIGHT_200x150 = 250;
  THUMBNAIL_WIDTH_200x150 = 180;
  THUMBNAIL_HEIGHT_400x300 = 400;
  THUMBNAIL_WIDTH_400x300 = 300;
  DEFAULT_TOP = 1;
  DEFAULT_LEFT = 1;
  DEFAULT_HEIGHT = 455;
  DEFAULT_WIDTH = 615;
  DEFAULT_FORM_HEIGHT = 570;
  DEFAULT_FORM_WIDTH = 685;

var
  fmEnlarge: TfmEnlarge;

  Scale: Single;
  W: Integer;
  H: Integer;
  ScaleRect: TRect;

implementation

uses
  Unit1, Math, jpeg;

{$R *.dfm}

procedure TfmEnlarge.ShapeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FSelMove := True;
end;

procedure TfmEnlarge.ShapeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

  procedure MoveControl(AControl: TControl; const X, Y: Integer);
  var
    lPoint: TPoint;
  begin
    lPoint := AControl.Parent.ScreenToClient(AControl.ClientToScreen(Point(X, Y)));

    if not ((lPoint.Y + AControl.Height div 2 >= Image1.Height) or (lPoint.X + AControl.Width div 2 >= Image1.Width) or
    (lPoint.X - AControl.Width div 2 <= Image1.Left) or (lPoint.Y - AControl.Height div 2 <= Image1.Top)) then
    begin
      AControl.Left := lPoint.X - AControl.Width div 2;
      AControl.Top := lPoint.Y - AControl.Height div 2;
    end;
  end;

begin
  if FSelMove then
  begin
    if ssLeft in Shift then // only move it when Left-click is down
    MoveControl(Sender as TControl, X, Y);
  end;

end;

procedure TfmEnlarge.ShapeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FSelMove := False; 
end;

procedure TfmEnlarge.shDisplayedDefaultCropRectangleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //shDisplayedDefaultCropRectangle.Hide;
end;

function TfmEnlarge.BMPtoJPG(var BMPpic, JPGpic: string) : boolean;
//Convert the .bmp to a .jpg
var
  bitmap: TBitmap;
  Stream: TFileStream;
begin
  try
    bitmap := TBitmap.Create;
    try
      try
        bitmap.LoadFromFile(BMPpic);
      except
        on E: EInvalidGraphic do
          MessageDlg('Error attempting to load an invalid graphic image in TfmEnlarge.BMPtoJPG().' + #13#10 +
            E.Message, mtError, [mbOK], 0);
      end;
      with TJPEGImage.Create do
        try
        Assign(bitmap);
        CompressionQuality := StrToIntDef(ParamStr(2),100);
        Stream := TFileStream.Create(ChangeFileExt(JPGpic,'.jpg'),fmCreate);
          try
            SaveToStream(Stream);
          finally
            Stream.Free
          end
        finally
          Free
        end
    finally
      Bitmap.Free
    end;
  except
    on E: Exception do
      MessageDlg('Streaming error in TfmEnlarge.BMPtoJPG', mtError, [mbOK], 0);
  end;
end;

procedure TfmEnlarge.btnCropClick(Sender: TObject);
var
  xx: integer;
  yy: integer;
begin
  Shape.Hide;
  Application.ProcessMessages;
  
  buOK.Enabled := true;
  fmMain.buAccept.Enabled := true; //for 'force crop'
  btnCrop.Enabled := false;

  croppedImage := TBitmap.Create;
  try
    CropBitmap(Image1.Picture.Bitmap, croppedImage, Shape.BoundsRect.BottomRight.X - Shape.Width, Shape.BoundsRect.TopLeft.Y, Shape.Width, Shape.Height);
    Image1.Picture := nil; //clear the original image
    //Resize the TImage
    Image1.Height := croppedImage.Height;
    Image1.Width := croppedImage.Width;
    xx := (fmEnlarge.Width div 2)-(croppedImage.Width div 2); //center in x dimension
    yy := (fmEnlarge.Height div 2)-(croppedImage.Height div 2); //center in y dimension
    Image1.Left := xx;
    Image1.Top := yy;
    Image1.Canvas.Draw(0, 0, croppedImage);

    buUndo.Enabled := true; //Defect 102
  finally
    //
  end;
end;

procedure TfmEnlarge.buCancelClick(Sender: TObject);
begin
  fmMain.buAccept.Enabled := false;
  Close;
end;

procedure TfmEnlarge.buOkClick(Sender: TObject);
begin
  //change preview back to standard size
  fmMain.imPreview.Height := IMPREVIEW_INIT_HEIGHT;
  fmMain.imPreview.Width := IMPREVIEW_INIT_WIDTH;

  if fmMain.me100x75.Checked then
    begin
    maxWidth := THUMBNAIL_WIDTH_100x75;
    maxHeight := THUMBNAIL_HEIGHT_100x75;
    end;

  if fmMain.me200x150.Checked then
    begin
    maxWidth := THUMBNAIL_WIDTH_200x150;
    maxHeight := THUMBNAIL_HEIGHT_200x150;
    end;

  if fmMain.me400x300.Checked then
    begin
    maxWidth := THUMBNAIL_WIDTH_400x300;
    maxHeight := THUMBNAIL_HEIGHT_400x300;
    end;

  fmMain.imPreview.Picture.Bitmap.Assign(croppedImage);

  //Delete the original .jpg snapshot
  DeleteFile(fmMain.jpg);
  try
    //Save the newly cropped (or not) .jpg
    fmMain.imPreview.Picture.SaveToFile(fmMain.jpg);
  except
    on E: EInOutError	do
      MessageDlg('File I/O Error in fmEnlarge.buOkClick()', mtError, [mbOK], 0);
  end;
  Close;

end;

procedure TfmEnlarge.buUndoClick(Sender: TObject);
begin
  try
    btnCrop.Enabled := true;
    buUndo.Enabled := false; //Defect 102
    Image1.Top := DEFAULT_TOP;
    Image1.Left := DEFAULT_LEFT;
    Image1.Height := DEFAULT_HEIGHT;
    Image1.Width := DEFAULT_WIDTH;
    Image1.Picture.Bitmap.Assign(self.fOriginalBitmap);
    FSelMove := False;
    buOK.Enabled := false;
  except
    on E: EInvalidGraphicOperation do
      MessageDlg('An exception has occurred in TfmEnlarge.buUndoClick()' + #13#10 +
        E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfmEnlarge.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    if fmEnlarge.fOriginalBitmap <> nil then
      fmEnlarge.fOriginalBitmap.Free;
  except
    on E: EInvalidGraphicOperation do
      MessageDlg('An exception has occurred in TfmEnlarge.FormClose()' + #13#10 +
        E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfmEnlarge.FormCreate(Sender: TObject);
begin
  Image1.Canvas.Brush.Color := clBlack; //fmMain.imPreview.Canvas.Brush.Color;
end;

procedure TfmEnlarge.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ((ssCtrl in Shift) and ((Key = 90) or (Key = 122))) then //Ctrl+Z or Ctrl+z
    buUndoClick(nil); 
end;

procedure TfmEnlarge.FormShow(Sender: TObject);
begin
  buOK.Enabled := false;
  btnCrop.Enabled := true;

  Image1.Width := DEFAULT_WIDTH; //615;
  Image1.Height := DEFAULT_HEIGHT; //455;
  fOriginalBitmap := TBitmap.Create;
  fOriginalBitmap.Assign(Image1.Picture.Bitmap); //save original image for Undo
  fmEnlarge.Height := DEFAULT_FORM_HEIGHT;
  fmEnlarge.Width := DEFAULT_FORM_WIDTH;
  FSelMove := False;
  Shape.Show;

  //Default Crop rectangle
  Shape.Top := 29; //init
  Shape.Left := 160; //init
  Shape.Width := 300; //init
  Shape.Height := 400; //init
end;

procedure TfmEnlarge.CropBitmap(InBitmap, OutBitMap : TBitmap; X, Y, W, H :Integer);
begin
  try
    OutBitMap.PixelFormat := InBitmap.PixelFormat;
    OutBitMap.Width  := W;
    OutBitMap.Height := H;
    BitBlt(OutBitMap.Canvas.Handle, 0, 0, W, H, InBitmap.Canvas.Handle, X, Y, SRCCOPY);
  except
    on E: EInvalidGraphicOperation do
      MessageDlg('Graphics error in fmEnlarge.CropBitmap()' + #13#10 +
        E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfmEnlarge.Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Shape.Show;

  FSelMove := False;
  laFSelX.Caption := 'FSelX: '; //debug
  laFSelY.Caption := 'FSelY: '; //debug
  laFSelX.Caption := laFSelX.Caption + intToStr(X); //debug
  laFSelY.Caption := laFSelY.Caption + intToStr(Y); //debug
  FSelX := X;
  FSelY := Y;

  FSelRect.Left := 0;
  FSelRect.Top := 0;
  FSelRect.Right := 0;
  FSelRect.Bottom := 0;
  Shape.SetBounds(0,0,0,0);

  H := 0;
  W := 0;

  FSelecting := true;
end;

procedure TfmEnlarge.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if FSelecting then
  begin
  laX.Caption := 'X: '; //debug
  laY.Caption := 'Y: '; //debug
  laX.Caption := laX.Caption + intToStr(X); //debug
  laY.Caption := laY.Caption + intToStr(Y); //debug
  laFSelRectLeft.Caption := 'FSelRect.Left: ';
  laFSelRectLeft.Caption := laFSelRectLeft.Caption + intToStr(FSelRect.Left); //debug

  Shape.BoundsRect := FSelRect;

  Scale := Image1.Width / Image1.Height;

  W := X - FSelX;
  H := Y - FSelY;

  if (W <> 0) and (H <> 0) then
    if Abs(W) / Abs(H) > Scale then
      H := Round(Abs(W) / Scale) * Sign(H)
    else
      W := Round(Abs(H) * Scale) * Sign(W);

  laH.Caption := 'H: '; //debug
  laW.Caption := 'W: '; //debug
  laH.Caption := laH.Caption + intToStr(H); //debug
  laW.Caption := laW.Caption + intToStr(W); //debug

                    //           L                      T               W        H
  Shape.SetBounds(Min(FSelX, FSelX + W), Min(FSelY, FSelY + H), Abs(H), Abs(W));

  //Defect 63 Fix - Cropping rectangle outside of frame borders
  //This causes crop rectangle to "stick" at whichever edge it hits first,
  //with no further rectangle dragging possible, until new MouseDown.
  Application.ProcessMessages;
  if (Shape.BoundsRect.Bottom >= Image1.Height-3) then //cutoff at bottom
    begin
    Image1MouseUp(Sender, mbLeft, [], X, Image1.Height-3);
    Exit;
    end
  else
    if (Shape.BoundsRect.Right >= Image1.Width-2) then //cutoff at right
      begin
      Image1MouseUp(Sender, mbLeft, [], Image1.Width-2, Y);
      Exit;
      end
  else
    if (Shape.BoundsRect.Left <= Image1.Left + 2) then
      begin
      Image1MouseUp(Sender, mbLeft, [], Image1.Left+2, Y);
      Exit;
      end
  else
    if (Shape.BoundsRect.Top <= Image1.Top+2) then //cutoff at top
      begin
      Image1MouseUp(Sender, mbLeft, [], X, Image1.Top+2);
      Exit;
      end;
  //end - Defect 63 Fix
  end;
end;

procedure TfmEnlarge.Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FSelecting then
  begin
  //kw - Defect 92: Added this 'if' to handle the situation where user clicks on the image without dragging
  //     a rectangle, then clicks the 'Crop' button.  When this happens, the entire Image1
  //     goes "blank" because it is trying to crop to a rectangle that consists of a single point.
  //     In fact, it is not blank; but just a single pixel.
  if ((FSelRect.TopLeft.X = FSelRect.BottomRight.X) and (FSelRect.TopLeft.Y = FSelRect.BottomRight.Y)) then
    begin
    FSelecting := False;
    Exit;
    end
  else
    begin
    FSelecting := False;
    Shape.BoundsRect := FSelRect;
    Shape.Show;
    end;
  end;

end;

end.
