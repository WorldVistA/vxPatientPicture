
{
tscap32 - Delphi Video Capture Component
Copyright (C) 1996-2003 Thomas Stuefe

contact: tstuefe@users.sourceforge.net
web:     http://tscap32.sourceforge.net


This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
}


unit tsmisc;

{schutthalde für müll, den man immer mal braucht}

//Logbox benutzen oder nich
{$DEFINE LOGBOX}



interface

uses windows, Messages, ComCtrls, SysUtils, TypInfo, Dialogs, forms,
     tslogbox;

{*****************************************************************************}
{ globale Typdefinitionen                                                     }
{*****************************************************************************}

type

  EtsException=class(Exception)
    public
      constructor Create(const Msg: string);
  end;


  // 32bit unsigned int: Standardvariable für alle ganzen Zahlen, die nicht
  // explizit eine kleinere Breite fordern
  int32 = LongInt;

  // Standard-Fließkommazahl
  float = Double;


var
  {zeigen auf globale kontrollelemente: Falls<>nil, bewirken die globalen Funktionen
  Progress... diese Komponenten zur Ausgabe von Proceed-Infos}
  tsGlobalProgressBar: TProgressBar;
  tsGlobalLogBox: TtsLogBox;
  

  procedure ProgressStart(OpDescr: string; MaxValue: LongInt);
  procedure Progress(CurrentValue: LongInt);
  procedure ProgressDone;

  procedure Log(txt: string);

  procedure tsError(TypeInfo: Pointer; Msg: string);


  function IsInRange(val1, val2, Rng: Integer):Boolean;
  procedure tsswap(var x1, x2: Integer);


  function GetBitsSize(pbmih: PBITMAPINFOHEADER): LongInt;
  function GetbmiSize(pbmih: PBITMAPINFOHEADER): LongInt;

  function zweihoch(x: Byte): DWord;

//prüft, ob in messagequeue der Anwendung(des hauptfensters) eine WM_Keydown-message mit esc-scancode liegt
  function CheckForEscKey: Boolean;

//prüft, ob windowsversion (primary language) deutsch
  function IsGermanWindows: Boolean;

  //zeigt deutschen oder engl. text an, abh. von german
  function TsMessageDlg(German: Boolean; MsgD, MsgE: string; AType: TMsgDlgType; AButtons: TMsgDlgButtons): Word;
{*****************************************************************************}
{ implementation                                                              }
{*****************************************************************************}

implementation



(******************************************************************************

Klassenimplementation EtsException

******************************************************************************)

  constructor EtsException.Create(const Msg: string);
  begin
    inherited Create(Msg);
  end;


(******************************************************************************

Funktionen

******************************************************************************)

procedure tsError(TypeInfo:Pointer; Msg: string);
var
  pData: PTypeData;
begin
  if TypeInfo <> nil then begin
    pData:=GetTypeData(PTypeInfo(TypeInfo));
    raise EtsException.Create(pData^.ClassType.ClassName + ' in Unit ' + pData^.UnitName+': '+Msg);
  end else
    raise EtsException.Create(Msg);
end;



{progressgeschichten}

procedure ProgressStart(OpDescr: string; MaxValue: LongInt);
begin
  if tsGlobalLogBox<>nil then tsGlobalLogBox.AddLog(OpDescr);
  if tsGlobalProgressBar<>nil then
    with tsGlobalProgressBar do
    begin
      Max:=MaxValue;
      Position:=0;
    end;
end;

procedure Progress(CurrentValue: LongInt);
begin
  if tsGlobalProgressBar<>nil then
    with tsGlobalProgressBar do
      Position:=CurrentValue;
end;

procedure ProgressDone;
begin
  if tsGlobalProgressBar<>nil then
    with tsGlobalProgressBar do
      Position:=Max;
  if tsGlobalLogBox<>nil then tsGlobalLogBox.AddLog('done');
end;

procedure Log(txt: string);
begin
{$IFDEF LOGBOX}
  if tsGlobalLogBox<>nil then tsGlobalLogBox.AddLog(txt);
{$ENDIF}
end;

{so zeugs}
function IsInRange(val1, val2, Rng: Integer):Boolean;
begin
  if (val1 >= (val2 - Abs(Rng))) and (val1 <= (val2 + Abs(Rng))) then
    Result := TRUE else Result := FALSE;
end;

procedure tsswap(var x1, x2: Integer);
var
  z: Integer;
begin
  z := x1;
  x1 := x2;
  x2 := z;
end;
          

function GetbmiSize(pbmih: PBITMAPINFOHEADER): LongInt;
var
  PalSize: LongInt;
begin
  PalSize := 0;
  with pbmih^ do
  begin
    {The biBitCount member of the BITMAPINFOHEADER structure determines
     the number of bits that define each pixel and the maximum number of
     colors in the bitmap. This member can be one of the following values:}
    case biBitCount of
      {1 The bitmap is monochrome, and the bmiColors member contains two entries.
      Each bit in the bitmap array represents a pixel. If the bit is clear,
      the pixel is displayed with the color of the first entry in the
      bmiColors table; if the bit is set, the pixel has the color of the second
      entry in the table.}
      1: Palsize := 2 * sizeof(TRGBQUAD);
      {4 The bitmap has a maximum of 16 colors, and the bmiColors member contains
      up to 16 entries. Each pixel in the bitmap is represented by a 4-bit
      index into the color table. For example, if the first byte in the bitmap
      is 0x1F, the byte represents two pixels. The first pixel contains the
      color in the second table entry, and the second pixel contains the color
      in the sixteenth table entry.}
      4: PalSize := 16 * sizeof(TRGBQUAD);
      {8  The bitmap has a maximum of 256 colors, and the bmiColors member contains
      up to 256 entries. In this case, each byte in the array represents a
      single pixel.}
      8: begin
        if biClrUsed = 0 then
          PalSize := 256 * sizeof(TRGBQUAD) else
          PalSize := biClrUsed * sizeof(TRGBQUAD);

      end;
      {16  The bitmap has a maximum of 2^16 colors. If the biCompression member
      of the BITMAPINFOHEADER is BI_RGB, the bmiColors member is NULL.
      Each WORD in the bitmap array represents a single pixel. The relative intensities
      of red, green, and blue are represented with 5 bits for each color component.
      The value for blue is in the least significant 5 bits, followed by 5 bits each
      for green and red, respectively. The most significant bit is not used.
      If the biCompression member of the BITMAPINFOHEADER is BI_BITFIELDS,
      the bmiColors member contains three DWORD color masks that specify the red,
      green, and blue components, respectively, of each pixel. Each WORD in the bitmap
      array represents a single pixel.Windows NT: When the biCompression member is
      BI_BITFIELDS, bits set in each DWORD mask must be contiguous and should not
      overlap the bits of another mask. All the bits in the pixel do not have to
      be used. Windows 95: When the biCompression member is BI_BITFIELDS,
      Windows 95 supports only the following 16bpp color masks}
      16: case biCompression of
            BI_RGB: PalSize := 0;
            BI_BITFIELDS: PalSize := 3 * sizeof(DWORD);
          end;
      {24 The bitmap has a maximum of 2^24 colors, and the bmiColors member is
      NULL. Each 3-byte triplet in the bitmap array represents the relative
      intensities of blue, green, and red, respectively, for a pixel.}
      24: PalSize := 0;
      {32 The bitmap has a maximum of 2^32 colors. If the biCompression member of
      the BITMAPINFOHEADER is BI_RGB, the bmiColors member is NULL. Each DWORD
      in the bitmap array represents the relative intensities of blue, green,
      and red, respectively, for a pixel. The high byte in each DWORD is not
      used.If the biCompression member of the BITMAPINFOHEADER is BI_BITFIELDS,
      the bmiColors member contains three DWORD color masks that specify the
      red, green, and blue components, respectively, of each pixel. Each DWORD
      in the bitmap array represents a single pixel. Windows NT: When the
      biCompression member is BI_BITFIELDS, bits set in each DWORD mask must
      be contiguous and should not overlap the bits of another mask. All the
      bits in the pixel do not have to be used. Windows 95: When the
      biCompression member is BI_BITFIELDS, Windows 95 supports only the
      following 32bpp color mask: The blue mask is 0x000000FF, the green mask
      is 0x0000FF00, and the red mask is 0x00FF0000.}
      32: case biCompression of
      BI_RGB: PalSize := 0;
      BI_BITFIELDS: PalSize := 3 * sizeof(DWORD);
      end;
    end;
    Result := PalSize + biSize;
  end;
end;

function GetBitsSize(pbmih: PBITMAPINFOHEADER): LongInt;
var
  retval: LongInt;
begin
  with pbmih^ do
  begin
    if biCompression<> BI_RGB then retval:=biSizeImage else
    begin
      retval := biHeight * (((biWidth * biBitCount + 31) div 32) * 4);
    end;
  end;
  Result:=retval;
end;

function zweihoch(x: Byte): DWord;
begin
  result := DWORD(1) shl x;
end;

//prüft, ob escapetaste gedrückt wurde
function CheckForEscKey: Boolean;
var
  Mess: TMsg;
begin
  Result := FALSE;
  if LongBool(Peekmessage(Mess, application.MainForm.Handle, WM_KEYDOWN, WM_KEYDOWN, PM_REMOVE)) then
    with Mess do
      if WParam = VK_ESCAPE then
        Result:= TRUE;
end;


//Sprachensynchr.:
//hilfsfunktion
function IsGermanWindows: Boolean;
begin
  Result := ((Word(GetSystemDefaultLCID) and $3ff) = LANG_GERMAN);
end;


function TsMessageDlg(German: Boolean; MsgD, MsgE: string; AType: TMsgDlgType; AButtons: TMsgDlgButtons): Word;
begin
  if German then
    Result := MessageDlg(MsgD, AType, AButtons, 0) else
    Result := MessageDlg(MsgE, AType, AButtons, 0);
end;

initialization
begin
  tsGlobalProgressBar:=nil;
  tsGlobalLogBox:=nil;
end;

end.


