
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

unit tsLogBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TtsLogBox = class(TListBox)
  private
    function BooleanGetFalse: Boolean;
    { Private-Deklarationen }
  protected
    LogCnt: Integer;
    EntryCnt: DWord;
    FLastLog: string;
    FLogFile: string;
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SaveLogFile(status: Boolean);
    procedure AddLog(msg: string);
  published
    { Published-Deklarationen }
    property LogFile: string Read FLogFile Write FLogFile;
    property Newlog: string Read FLastLog Write AddLog;
    property SaveLog: Boolean Read BooleanGetFalse Write SaveLogFile;
  end;

procedure Register;

implementation

constructor TtsLogBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LogCnt:=0;
  EntryCnt := 0;
  FLastLog:='';
  if LogFile = '' then LogFile:='D:\Meas32\Log';
end;

destructor TtsLogBox.Destroy;
begin
  inherited Destroy;
end;

procedure TtsLogBox.SaveLogFile(status: Boolean);
var
  fs: TFileStream;
  w: TWriter;
  i: Integer;
begin
if status and (Items.Count<>0) then
  begin
    fs:=TFileStream.Create(LogFile+IntToStr(LogCnt)+'.log', fmCreate);
    w:=TWriter.Create(fs, 1000);
    for i:=0 to Items.Count-1 do
    begin
      w.WriteString(Items[i]+#13);
    end;
    w.Free;
    fs.Free;
    Clear;
    inc(LogCnt);
  end;
end;

procedure TtsLogBox.AddLog(msg: string);
begin
  ItemIndex:=Items.Add(Format('%d: %s: %s',[EntryCnt, TimeToStr(Time), Msg]));
  inc(EntryCnt);
end;

function TtsLogBox.BooleanGetFalse: Boolean;
begin
  Result:=FALSE;
end;










procedure Register;
begin
  RegisterComponents('tsTech', [TtsLogBox]);
end;

end.
