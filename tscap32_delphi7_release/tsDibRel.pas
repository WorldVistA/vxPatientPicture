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

unit tsDibRel;


{
unit: tsDibRel
Dib related procedures and functions, chiefly programmed to transfer (packed) DIbs
into Delphi TBitmaps - a bunch of little helper functions
}


interface

uses Windows, Classes, SysUtils, Graphics, vfwunit, mmsystem;

type
  TByteArray = array[0..0] of Byte;
type
  BITMAPFILEHEADER = TBitmapFileHeader;

//returns the size of the BITMAPINFO-structure pointed by pbmi
function GetBmiSize(pBmi: PBITMAPINFO): LongInt;

//returns the size of the bitmap
function GetBitsSize(pBmi: PBITMAPINFO): LongInt;

//returns a Pointer to the bitmap of a packed DIB
function BitsOfPackedDib(pPackedDib: PBITMAPINFO): PChar;

//copies a Dib and returns a Pointer to a packed DIB
//This mem is allocated with GetMem and has to be deleted by the Caller
//with FreeMem
//if pOrigDibBits is NULL, the function assumes pOrigDibBmi as a Pointer to an packed Dib
//returns NULL if an Error occurred
function CopyDib(pOrigDibBmi: PBITMAPINFO; pOrigDibBits: PChar): PBITMAPINFO;

//copies and crops a Dib (works at the time only with 8bpp/24bpp and BI_RGB)
//returns a packed Dib
//if pOrigDibBits is NULL, the function assumes pOrigDibBmi as a Pointer to an packed Dib
//returns NULL if an Error occurred
function CopyAndCropDib(pOrigDibBmi: PBITMAPINFO; pOrigDibBits: PChar; x, y, w, h: Integer): PBITMAPINFO;

//loads a BMP-File and returns a packed Dib
function LoadDib(FileName: String): PBITMAPINFO;

//saves a Dib to a BMP-File
//if pBits is NULL, the function assumes pBits as a Pointer to an packed Dib
procedure SaveDib(pBmi: PBITMAPINFO; pBits: PChar; FileName: String);

//produces a Delphi-conform TBitmap object from the dib given over by the caller
//The dib itself will not be changed, it will be copied
//if pBits is NULL, the function assumes pBits as a Pointer to an packed Dib
function CreateTBitmapFromDib(pBmi: PBITMAPINFO; pBits: PChar):TBitmap;

//Returns TRUE if biCompression <> BI_RGB
function IsCompressed(pBmi: PBITMAPINFO): Boolean;

//Searches a decompressor to handle the overtaken Dib and decompresses the
//dib if a corresponding Driver were found
//if pBits is NULL, the function assumes pBits as a Pointer to an packed Dib
//if no driver were found or an error ocurred, the function returns NULL
function DecompressDib(pBmi: PBITMAPINFO; pBits: PChar): PBITMAPINFO;


implementation


function GetBmiSize(pbmi: PBITMAPINFO): LongInt;
var
  PalSize: LongInt;
begin
  with pbmi^.bmiHeader do
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
      4:
      begin
        if biClrUsed = 0 then
          PalSize := 16 * sizeof(TRGBQUAD) else
          PalSize := biClrUsed * sizeof(TRGBQUAD);
      end;
      {8  The bitmap has a maximum of 256 colors, and the bmiColors member contains
      up to 256 entries. In this case, each byte in the array represents a
      single pixel.}
      8:
      begin
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
    Result := biSize + PalSize;
  end;
end;

function GetBitsSize(pbmi: PBITMAPINFO): LongInt;
var
  retval: LongInt;
begin
  with pbmi^.bmiHeader do
  begin
    if biCompression <> BI_RGB then retval := biSizeImage else
    begin
      retval := biHeight * (((biWidth * biBitCount + 31) div 32) * 4);
    end;
  end;
  Result:=retval;
end;



function BitsOfPackedDib(pPackedDib: PBITMAPINFO): PChar;
begin
  Result := PChar(pPackedDib) + GetBmiSize(pPackedDib);
end;


function CopyDib(pOrigDibBmi: PBITMAPINFO; pOrigDibBits: PChar): PBITMAPINFO;
var
  BmiSize, BitsSize: Integer;
  pCopiedDib: PChar;
begin
  if pOrigDibBits = nil then
    pOrigDibBits := BitsOfPackedDib(pOrigDibBmi);
  BmiSize := GetBmiSize(pOrigDibBmi);
  BitsSize := GetBitsSize(pOrigDibBmi);
  GetMem(pCopiedDib, BmiSize + BitsSize);
  if pCopiedDib <> nil then begin
    Move(pOrigDibBmi^, TByteArray(pCopiedDib^)[0], BmiSize);
    Move(pOrigDibBits^, TByteArray(pCopiedDib^)[BmiSize], BitsSize);
  end;
  Result := PBITMAPINFO(pCopiedDib);
end;


function CopyAndCropDib(pOrigDibBmi: PBITMAPINFO; pOrigDibBits: PChar; x, y, w, h: Integer): PBITMAPINFO;
var
  pTempBmi, pCroppedDibBmi: PBITMAPINFO;
  pCroppedDibBits: PChar;
  CroppedDibBmiSize, CroppedDibBitsSize,
  CroppedDibScanLineLen: LongInt;
  OrigDibBmiSize, OrigDibBitsSize,
  OrigDibScanLineLen, OrigDibStartOffset,
  ixOrigDib, ixCroppedDib: LongInt;
  i: Integer;
  CropRect: TRect;
begin
  Result := nil;

  if pOrigDibBits = nil then
    pOrigDibBits := BitsOfPackedDib(pOrigDibBmi);

  OrigDibBmiSize := GetbmiSize(pOrigDibBmi);
  OrigDibBitsSize := GetbitsSize(pOrigDibBmi);

  //falls kein 24bit o. 8bit, kein cropping
  //falls nicht bi_rgb, kein cropping
  with pOrigDibBmi^.bmiHeader do begin
    if (biBitCount <> 8) and (biBitCount <> 24) then exit;
    if (bicompression <> BI_RGB) then exit;
    //Croprect zuweisen
    with CropRect do begin
      top := y; left := x; bottom := y + h; right := x + w;
      if top >= biHeight then top := biHeight - 1;
      if top < 0 then top := 0;
      if left >= biWidth then left := biWidth - 1;
      if left < 0 then left := 0;
      if bottom >= biHeight then bottom := biHeight - 1;
      if bottom <= top then bottom := top + 1;
      if right >= biWidth then right := biWidth - 1;
      if right <= left then right := left + 1;
    end;
  end;

  //Palette temporär kopieren und initialisieren: anhand dieser wird die Größe der
  //Bitmap berechnet
  CroppedDibBmiSize := OrigDibBmiSize;
  GetMem(pTempBmi, CroppedDibBmiSize);
  if pTempBmi = nil then exit;
  Move(pOrigDibBmi^, pTempBmi^, CroppedDibBmiSize);
  with CropRect, pTempBmi^.bmiHeader do begin
    biWidth := right - left;
    biHeight := bottom - top;
    //biSizeImage may be set to 0 for BI_RGB-compressed pics
    biSizeImage := 0;
  end;
  CroppedDibBitsSize := GetBitsSize(pTempBmi);

  //Speicher für das ZielDib allokieren und palette aus temporärer Palette kopieren
  GetMem(pCroppedDibBmi, CroppedDibBmiSize + CroppedDibBitsSize);
  if pCroppedDibBmi = nil then begin FreeMem(pTempBmi); exit; end;
  Move(pTempBmi^, pCroppedDibBmi^, CroppedDibBmiSize);
  FreeMem(pTempBmi);
  pCroppedDibBits := BitsOfPackedDib(pCroppedDibBmi);

  //Parameter berechnen
  with pOrigDibBmi^.bmiHeader, CropRect do begin
    OrigDibScanLineLen := (((biWidth * biBitCount) + 31) div 32) * 4;
    CroppedDibScanLineLen := ((((right - left) * biBitCount) + 31) div 32) * 4;
    OrigDibStartOffset := OrigDibScanLineLen * (biHeight - bottom) + ((left * biBitCount) div 8);
  end;                                   //^^^ Bild liegt verkehrt rum!

  //Bits kopieren
  with CropRect do begin
    ixOrigDib := OrigDibStartOffset;
    ixCroppedDib := 0;
    for i := top to bottom - 1 do begin
      Move(TByteArray(pOrigDibBits^)[ixOrigDib], TByteArray(pCroppedDibBits^)[ixCroppedDib], CroppedDibScanLineLen);
      ixOrigDib := ixOrigDib + OrigDibScanLineLen;
      ixCroppedDib := ixCroppedDib + CroppedDibScanLineLen;
    end;
  end;
  Result := pCroppedDibBmi;
end;


//loads a BMP-File and returns a packed Dib
function LoadDib(FileName: String): PBITMAPINFO;
var
  pDib: PChar;
  BmiSize, BitsSize: Integer;
  bmfh: BITMAPFILEHEADER;
  fs: TFileStream;
begin
  Result := nil;
  fs := TFileStream.Create(FileName, fmOpenRead);
  fs.Position := 0;
  fs.Read(bmfh, sizeof(BITMAPFILEHEADER));
  with bmfh do begin
    if bfType <> $4d42 then exit;
    BmiSize := bfOffBits - sizeof(BITMAPFILEHEADER);
    BitsSize := bfSize - bfOffBits;
  end;
  GetMem(pDib, BmiSize + BitsSize);
  if pDib = nil then exit;
  fs.Read(TByteArray(pDib^)[0], BmiSize);
  fs.Read(TByteArray(pDib^)[BmiSize], BitsSize);
  fs.Free;
  Result := PBITMAPINFO(pDib);
end;


procedure SaveDib(pBmi: PBITMAPINFO; pBits: PChar; FileName: String);
var
  fs: TFileStream;
  bmfh: BITMAPFILEHEADER;
  BmiSize, BitsSize, FileSize: LongInt;
begin
  if pBits = nil then
    pBits := BitsOfPackedDib(pBmi);

  fs := TFileStream.Create(FileName, fmCreate);
  fs.Position := 0;
  BmiSize := GetBmiSize(pBmi);
  BitsSize := GetBitsSize(pBmi);
  FileSize := sizeof(BITMAPFILEHEADER) + BmiSize + BitsSize;
  with bmfh do begin
    bfType := $4d42;
    bfSize := FileSize;
    bfReserved1 := 0;
    bfReserved2 := 0;
    bfOffBits := sizeof(BITMAPFILEHEADER) + BmiSize;
  end;
  fs.Write(bmfh, sizeof(BITMAPFILEHEADER));
  fs.Write(pBmi^, BmiSize);
  fs.Write(pBits^, BitsSize);
  fs.Free;
end;


function CreateTBitmapFromDib(pBmi: PBITMAPINFO; pBits: PChar): TBitmap;
var
  ms: TMemoryStream;
  BmiSize, BitsSize, FileSize: LongInt;
  TempBmp: TBitmap;
  Bmfh: BITMAPFILEHEADER;
begin
  Result := nil;
  //nur unkomprimierte Bilder
  if pBmi^.bmiHeader.biCompression <> BI_RGB then exit;

  if pBits = nil then
    pBits := BitsOfPackedDib(pBmi);

  BmiSize := GetBmiSize(pBmi);
  BitsSize := GetBitsSize(pBmi);
  FileSize := sizeof(BITMAPFILEHEADER) + BmiSize + BitsSize;
  ms := TMemoryStream.Create;
  ms.SetSize(FileSize);
  ms.seek(0, soFromBeginning);
  TempBmp := TBitmap.Create;
  with bmfh do begin
    bfType := $4d42;
    bfSize := FileSize;
    bfReserved1 := 0;
    bfReserved2 := 0;
    bfOffBits := sizeof(BITMAPFILEHEADER) + BmiSize;
  end;
  ms.Write(bmfh, sizeof(BITMAPFILEHEADER));
  ms.Write(pBmi^, BmiSize);
  ms.Write(pBits^, BitsSize);
  ms.seek(0, soFromBeginning);
  try
    TempBmp.LoadFromStream(ms);
    Result := TempBmp;
  finally
    ms.Free;
  end;
end;

function IsCompressed(pBmi: PBITMAPINFO): Boolean;
begin
  Result := pBmi^.bmiHeader.biCompression <> BI_RGB;
end;


function DecompressDib(pBmi: PBITMAPINFO; pBits: PChar): PBITMAPINFO;
var
  hCodec: HIC;
  txt: array[0..9] of Char;
  VidfCC: FourCC;
  BmiSize: Integer;
  pBmiOut: PBITMAPINFO;
h: THandle;
begin
  if pBits = nil then
    pBits := BitsOfPackedDib(pBmi);

  if not IsCompressed(pBmi) then Result := pBmi else begin
    Result := nil;
    //mmio-Code erzeugen
    VidfCC := mmioStringToFOURCC(StrPCopy(@txt, 'VIDC'),MMIO_TOUPPER);
    //Ausgangsformat = Eingangsformat, unkomprimiert
    BmiSize := GetBmiSize(pBmi);
    GetMem(pBmiOut, BmiSize);
    if pBmiOut = nil then exit;
    Move(pBmi^, pBmiOut^, BmiSize);
    with pBmiOut^.bmiHeader do begin
      biCompression := BI_RGB;
      biSizeImage := 0;
    end;

    //Dekompressor suchen
    hCodec := ICLocate(VidfCC, 0, PBITMAPINFOHEADER(pBmi), PBITMAPINFOHEADER(pBmiOut), ICMODE_DECOMPRESS);
    if hCodec = 0 then exit;

    //Bild dekomprimieren
    h := ICImageDecompress(hCodec, 0, pBmi, pBits, pBmiOut);
    if h = 0 then exit;

  end;




end;


end.
