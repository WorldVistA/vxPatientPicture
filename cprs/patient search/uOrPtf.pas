unit uOrPtf;   //PRF

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

uses SysUtils, Windows, Classes, Forms, ORFn, ORNet, uCore;

Type
  TPatientFlag = Class(TObject)
  private
    FFlagID:   string;
    FName: string;
    FNarr: TStringList;
    FFlagIndex: integer;
  public
    property FlagID: string      read FFlagID  write FFlagID;
    property Name:   string      read FName    write FName;
    property Narr:   TStringList read FNarr    write FNarr;
    property FlagIndex: integer  read FFlagIndex write FFlagIndex;
    constructor Create;
    procedure Clearup;
  end;

procedure HasActiveFlg(var FlagList: TStringList; var HasFlag: boolean; const PTDFN: string);
function GetCatIFlag(var FlagArr: TStrings): integer;
procedure GetActiveFlg(FlagInfo: TStrings; const PTDFN, FlagRecordID: string);
procedure ClearFlag;

implementation

procedure HasActiveFlg(var FlagList: TStringList; var HasFlag: boolean; const PTDFN: string);
begin
  FlagList.Clear;
  HasFlag := False;
  CallV('ORPRF HASFLG',[PTDFN]);
  if RPCBrokerV.Results.Count > 0 then
  begin
    FlagList.Assign(RPCBrokerV.Results);
    HasFlag := True;
  end;
end;

function GetCatIFlag(var FlagArr: TStrings): integer;
begin
  Result := 0;
  CallV('ORPRF HASCAT1',[nil]);
  if RPCBrokerV.Results.Count < 1 then
    Exit;
  Result := StrToIntDef(Piece(RPCBrokerV.Results[0],'^',2),0);
  RPCBrokerV.Results.Delete(0);
  FlagArr.Assign(RPCBrokerV.Results);
end;

procedure TPatientFlag.Clearup;
begin
  FFlagID := '0';
  FName   := '';
  FNarr.Clear;
  FFlagIndex := -1;
end;

constructor TPatientFlag.Create;
begin
  FFlagID   := '0';
  FName := '';
  FNarr := TStringList.Create;
  FFlagIndex := -1;
end;

procedure GetActiveFlg(FlagInfo: TStrings; const PTDFN, FlagRecordID: string);
begin
  CallV('ORPRF GETFLG', [PTDFN,FlagRecordID]);
  if RPCBrokerV.Results.Count > 0 then
    FlagInfo.Assign(RPCBrokerV.Results);
end;

procedure ClearFlag;
begin
  sCallV('ORPRF CLEAR',[nil]);
end;

end.
