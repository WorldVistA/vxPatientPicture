
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


unit tsTechAboutFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  tstlg2, StdCtrls;

type
  TtsTechAboutFrm = class(TForm)
    OkBn: TButton;
    procedure FormShow(Sender: TObject);
    procedure Paint; override;
  public
    Txt: array[0..9]of string;
  end;


implementation

{$R tsTechAboutFormResources\tsTechAboutFrm.DFM}

procedure TtsTechAboutFrm.FormShow(Sender: TObject);
var
  maxTextWidth: Integer;
  maxText: Integer;
  i, j: Integer;
begin
  with Canvas do begin
    maxText := 0;
    maxTextWidth := 0;
    for i := 0 to 9 do
      if Txt[i] <> '' then begin
        maxText := i + 1;
        j := TextWidth(DeNoise(Txt[i]));
        if j > maxTextWidth then
          maxTextWidth := j;
      end;
  end;
  ClientWidth := maxTextWidth + 40;
  if ClientWidth < 150 then ClientWidth := 150;
  ClientHeight := (maxText * 10) + 32 + 8;
  if ClientHeight < 80 then ClientHeight := 80;
  Font.Size := 7;
  OkBn.Left := (ClientWidth div 2) - (OkBn.Width div 2);
  OkBn.Top := ClientHeight - 28;
  Color := clBlack;
end;

procedure TtsTechAboutFrm.Paint;
var
  i: Integer;
begin
  inherited Paint;
  FIXWMF_DrawToCanvas(Canvas, 0, 0, ClientWidth + 2, ClientHeight + 2);
  with canvas do begin
    Canvas.Brush.Style := bsClear;
    for i := 0 to 9 do
      textOut((ClientWidth - TextWidth((Txt[i]))) div 2, (i * 10) + 4 , (Txt[i]));
  end;
end;

end.
